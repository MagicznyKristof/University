#include <readline/readline.h>
#include <readline/history.h>

#define DEBUG 0
#include "shell.h"

sigset_t sigchld_mask;

static sigjmp_buf loop_env;

static void sigint_handler(int sig) {
  siglongjmp(loop_env, sig);
}

/* Rewrite closed file descriptors to -1,
 * to make sure we don't attempt do close them twice. */
static void MaybeClose(int *fdp) {
  if (*fdp < 0)
    return;
  Close(*fdp);
  *fdp = -1;
}

/* Consume all tokens related to redirection operators.
 * Put opened file descriptors into inputp & output respectively. */
static int do_redir(token_t *token, int ntokens, int *inputp, int *outputp) {
  token_t mode = NULL; /* T_INPUT, T_OUTPUT or NULL */
  int n = 0;           /* number of tokens after redirections are removed */

  for (int i = 0; i < ntokens; i++) {
    /* DONE: Handle tokens and open files as requested. */
    /* check if there's need to handle the token */
    if (token[i] == T_INPUT) {
      /* redirect the input */
      *inputp = Open(token[i + 1], O_RDONLY, 0);

      /* update the number of tokens after redirection and set the correct mode
       */
      if (!mode)
        n = i;
      mode = token[i];
    }
    /* check if there's need to handle the token */
    if (token[i] == T_OUTPUT) {
      /* redirect the output */
      *outputp = Open(token[i + 1], O_WRONLY | O_CREAT, S_IRWXU);

      /* update the number of tokens after redirection and set the correct mode
       */
      if (!mode)
        n = i;
      mode = token[i];
    }
  }

  /* if we didn't redirect anything,
  there's no need to change the number of tokens */
  if (!mode)
    n = ntokens;

  token[n] = NULL;
  return n;
}

/* Execute internal command within shell's process or execute external command
 * in a subprocess. External command can be run in the background. */
static int do_job(token_t *token, int ntokens, bool bg) {
  int input = -1, output = -1;
  int exitcode = 0;

  ntokens = do_redir(token, ntokens, &input, &output);

  if (!bg) {
    if ((exitcode = builtin_command(token)) >= 0)
      return exitcode;
  }

  sigset_t mask;
  Sigprocmask(SIG_BLOCK, &sigchld_mask, &mask);

  /* DONE: Start a subprocess, create a job and monitor it. */
  pid_t pid = fork(); /* create new process */
  /* child */
  if (pid == 0) {
    /* restore default signal handling and signal mask */
    Signal(SIGINT, SIG_DFL);
    Signal(SIGTSTP, SIG_DFL);
    Signal(SIGTTIN, SIG_DFL);
    Signal(SIGTTOU, SIG_DFL);
    Sigprocmask(SIG_SETMASK, &mask, NULL);

    /* Redirect I/O if needed */
    if (input != -1) {
      dup2(input, STDIN_FILENO);
      Close(input);
    }
    if (output != -1) {
      dup2(output, STDOUT_FILENO);
      Close(output);
    }

    /* run the command */
    external_command(token);
  }
  /* parent */
  setpgid(pid, pid);

  /* close file descriptors that may have been opened earlier */
  MaybeClose(&input);
  MaybeClose(&output);

  /* create a new job and process */
  int job = addjob(pid, bg);
  addproc(job, pid, token);

  /* if the job is in the foreground, monitor it
  if it's in the background, let the user know it's running */
  if (!bg)
    exitcode = monitorjob(&mask);
  else
    msg("[%d] running '%s'\n", job, jobcmd(job));

  Sigprocmask(SIG_SETMASK, &mask, NULL);
  return exitcode;
}

/* Start internal or external command in a subprocess that belongs to pipeline.
 * All subprocesses in pipeline must belong to the same process group. */
static pid_t do_stage(pid_t pgid, sigset_t *mask, int input, int output,
                      token_t *token, int ntokens) {
  ntokens = do_redir(token, ntokens, &input, &output);

  if (ntokens == 0)
    app_error("ERROR: Command line is not well formed!");

  /* DONE?: Start a subprocess and make sure it's moved to a process group. */
  pid_t pid = Fork();

  /* child */
  if (pid == 0) {
    /* restore default signal handling and signal mask */
    Signal(SIGINT, SIG_DFL);
    Signal(SIGTSTP, SIG_DFL);
    Signal(SIGTTIN, SIG_DFL);
    Signal(SIGTTOU, SIG_DFL);
    Sigprocmask(SIG_SETMASK, mask, NULL);

    /* Redirect I/O if needed */
    if (input != -1) {
      dup2(input, STDIN_FILENO);
      Close(input);
    }
    if (output != -1) {
      dup2(output, STDOUT_FILENO);
      Close(output);
    }
    /* run the command */
    external_command(token);
  }
  /* parent */
  /* close file descriptors that may have been opened earlier */
  MaybeClose(&input);
  MaybeClose(&output);

  /* move the process to process group */
  setpgid(pid, pgid);

  return pid;
}

static void mkpipe(int *readp, int *writep) {
  int fds[2];
  Pipe(fds);
  fcntl(fds[0], F_SETFD, FD_CLOEXEC);
  fcntl(fds[1], F_SETFD, FD_CLOEXEC);
  *readp = fds[0];
  *writep = fds[1];
}

/* Pipeline execution creates a multiprocess job. Both internal and external
 * commands are executed in subprocesses. */
static int do_pipeline(token_t *token, int ntokens, bool bg) {
  pid_t pid, pgid = 0;
  int job = -1;
  int exitcode = 0;

  int input = -1, output = -1, next_input = -1;

  mkpipe(&next_input, &output);

  sigset_t mask;
  Sigprocmask(SIG_BLOCK, &sigchld_mask, &mask);

  /* DONE: Start pipeline subprocesses, create a job and monitor it.
   * Remember to close unused pipe ends! */

  /* TODO: fix leaks, find what's the problem with pipe test 3, comment */

  token_t *proc_tokens = token;
  int proc_end = 0;

  /* find where the first process in pipe ends, null the T_PIPE */
  while (token[proc_end] != T_PIPE) {
    proc_end++;
  }
  token[proc_end] = T_NULL;

  /* start the first process, save its pid and set the pid of the first process
  add a new job and add the first process to it */
  pid = do_stage(pgid, &mask, input, output, proc_tokens, proc_end);
  pgid = pid;        // do we need to set the pgid of the first process as well?
  Setpgid(pid, pid); // doesn't seem to change anything but let's leave it
  job = addjob(pgid, bg);
  addproc(job, pid, proc_tokens);

  while (proc_end < ntokens) {

    /* close pipe ends

    Is it supposed to be like that, leaks and stuff? Doesn't close the <next>
    (?)
    pipe in # check shell 'ls -l /proc/$pid/fd'. Or is the problem with
    something else? */
    close(input);
    close(output);

    /* move the pointer to the start of the next process */
    proc_tokens = token + proc_end + 1;

    /* find the end of the next process */
    while (token[proc_end] != T_PIPE && proc_end < ntokens) {
      proc_end++;
    }

    /* if the process is the last process in the job */
    if (proc_end < ntokens) {
      /* mark the end */
      token[proc_end] = T_NULL;

      /* update input, make new pipe */
      input = next_input;
      mkpipe(&next_input, &output);

      /* add the process to the job */
      pid = do_stage(pgid, &mask, input, output, proc_tokens, proc_end);
      addproc(job, pid, proc_tokens);
    } else { /* last process in pipe */

      /* update input, make new pipe */
      input = next_input;

      /* make new pipe, make sure the output is correct */
      mkpipe(&next_input, &output);
      output = -1;

      /* add the process to the job */
      pid = do_stage(pgid, &mask, input, output, proc_tokens, proc_end);
      addproc(job, pid, proc_tokens);

      /* close everything */
      close(input);
      close(output);
      close(next_input);
    }
  }

  /* if the job is in the foreground, monitor it
  if it's in the background, let the user know it's running */
  if (!bg)
    exitcode = monitorjob(&mask);
  else
    msg("[%d] running '%s'\n", job, jobcmd(job));

  Sigprocmask(SIG_SETMASK, &mask, NULL);
  return exitcode;
}

static bool is_pipeline(token_t *token, int ntokens) {
  for (int i = 0; i < ntokens; i++)
    if (token[i] == T_PIPE)
      return true;
  return false;
}

static void eval(char *cmdline) {
  bool bg = false;
  int ntokens;
  token_t *token = tokenize(cmdline, &ntokens);

  if (ntokens > 0 && token[ntokens - 1] == T_BGJOB) {
    token[--ntokens] = NULL;
    bg = true;
  }

  if (ntokens > 0) {
    if (is_pipeline(token, ntokens)) {
      do_pipeline(token, ntokens, bg);
    } else {
      do_job(token, ntokens, bg);
    }
  }

  free(token);
}

int main(int argc, char *argv[]) {
  rl_initialize();

  sigemptyset(&sigchld_mask);
  sigaddset(&sigchld_mask, SIGCHLD);

  if (getsid(0) != getpgid(0))
    Setpgid(0, 0);

  initjobs();

  Signal(SIGINT, sigint_handler);
  Signal(SIGTSTP, SIG_IGN);
  Signal(SIGTTIN, SIG_IGN);
  Signal(SIGTTOU, SIG_IGN);

  char *line;
  while (true) {
    if (!sigsetjmp(loop_env, 1)) {
      line = readline("# ");
    } else {
      msg("\n");
      continue;
    }

    if (line == NULL)
      break;

    if (strlen(line)) {
      add_history(line);
      eval(line);
    }
    free(line);
    watchjobs(FINISHED);
  }

  msg("\n");
  shutdownjobs();

  return 0;
}
