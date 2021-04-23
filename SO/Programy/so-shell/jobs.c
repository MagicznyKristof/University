#include "shell.h"

typedef struct proc {
  pid_t pid;    /* process identifier */
  int state;    /* RUNNING or STOPPED or FINISHED */
  int exitcode; /* -1 if exit status not yet received */
} proc_t;

typedef struct job {
  pid_t pgid;            /* 0 if slot is free */
  proc_t *proc;          /* array of processes running in as a job */
  struct termios tmodes; /* saved terminal modes */
  int nproc;             /* number of processes */
  int state;             /* changes when live processes have same state */
  char *command;         /* textual representation of command line */
} job_t;

static job_t *jobs = NULL;          /* array of all jobs */
static int njobmax = 1;             /* number of slots in jobs array */
static int tty_fd = -1;             /* controlling terminal file descriptor */
static struct termios shell_tmodes; /* saved shell terminal modes */

static void sigchld_handler(int sig) {
  int old_errno = errno;
  pid_t pid;
  int status;
  /* DONE: Change state (FINISHED, RUNNING, STOPPED) of processes and jobs.
   * Bury all children that finished saving their status in jobs. */
  for (int j = 0; j < njobmax; j++) {
    /* newstate is used to save how the job status changed.
    It's set to FINISHED because FINISHED is the 'lowest' state of the job */
    int newstate = FINISHED;

    /* iterate through all processes in a job */
    for (int p = 0; p < jobs[j].nproc; p++) {
      proc_t *proc = &jobs[j].proc[p];
      /* check if something has changed.
      pid = proc.pid because otherwise compiler would throw error unused
      variable for pid */
      if (waitpid(pid = proc->pid, &status, WNOHANG | WUNTRACED | WCONTINUED)) {
        /* if the job was continued or stopped, change it's state */
        if (WIFCONTINUED(status))
          proc->state = RUNNING;

        if (WIFSTOPPED(status))
          proc->state = STOPPED;

        /* if the job finished, change it's state and save exitcode

        is the problem with pkill in dojobs? it doesn't seem to
        create a separate job for pkill and it returns the exitcode of pkill as
        exitcode of cat (I think)
        or is it there?
        The test passes very rarely so I wonder */
        if (WIFSIGNALED(status)) {

          proc->state = FINISHED;
          proc->exitcode = status;
        }
        if (WIFEXITED(status)) {
          proc->state = FINISHED;
          proc->exitcode = status;
        }
      }
      /* check the status of the process after handling the signal and update
      the new job status if needed (hierarchy is RUNNING > STOPPED > FINISHED)
      */
      if (proc->state == STOPPED && newstate != RUNNING)
        newstate = STOPPED;
      else if (proc->state == RUNNING)
        newstate = RUNNING;
    }
    /* update the state of the job */
    jobs[j].state = newstate;
  }
  errno = old_errno;
}

/* When pipeline is done, its exitcode is fetched from the last process. */
static int exitcode(job_t *job) {
  return job->proc[job->nproc - 1].exitcode;
}

static int allocjob(void) {
  /* Find empty slot for background job. */
  for (int j = BG; j < njobmax; j++)
    if (jobs[j].pgid == 0)
      return j;

  /* If none found, allocate new one. */
  jobs = realloc(jobs, sizeof(job_t) * (njobmax + 1));
  memset(&jobs[njobmax], 0, sizeof(job_t));
  return njobmax++;
}

static int allocproc(int j) {
  job_t *job = &jobs[j];
  job->proc = realloc(job->proc, sizeof(proc_t) * (job->nproc + 1));
  return job->nproc++;
}

int addjob(pid_t pgid, int bg) {
  int j = bg ? allocjob() : FG;
  job_t *job = &jobs[j];
  /* Initial state of a job. */
  job->pgid = pgid;
  job->state = RUNNING;
  job->command = NULL;
  job->proc = NULL;
  job->nproc = 0;
  job->tmodes = shell_tmodes;
  return j;
}

static void deljob(job_t *job) {
  assert(job->state == FINISHED);
  free(job->command);
  free(job->proc);
  job->pgid = 0;
  job->command = NULL;
  job->proc = NULL;
  job->nproc = 0;
}

static void movejob(int from, int to) {
  assert(jobs[to].pgid == 0);
  memcpy(&jobs[to], &jobs[from], sizeof(job_t));
  memset(&jobs[from], 0, sizeof(job_t));
}

static void mkcommand(char **cmdp, char **argv) {
  if (*cmdp)
    strapp(cmdp, " | ");

  for (strapp(cmdp, *argv++); *argv; argv++) {
    strapp(cmdp, " ");
    strapp(cmdp, *argv);
  }
}

void addproc(int j, pid_t pid, char **argv) {
  assert(j < njobmax);
  job_t *job = &jobs[j];

  int p = allocproc(j);
  proc_t *proc = &job->proc[p];
  /* Initial state of a process. */
  proc->pid = pid;
  proc->state = RUNNING;
  proc->exitcode = -1;
  mkcommand(&job->command, argv);
}

/* Returns job's state.
 * If it's finished, delete it and return exitcode through statusp. */
int jobstate(int j, int *statusp) {
  assert(j < njobmax);
  job_t *job = &jobs[j];
  int state = job->state;

  /* DONE: Handle case where job has finished. */
  if (state == FINISHED) {
    /* not sure what more to say here, just save exitcode and delete it */
    *statusp = exitcode(job);
    deljob(job);
  }

  return state;
}

char *jobcmd(int j) {
  assert(j < njobmax);
  job_t *job = &jobs[j];
  return job->command;
}

/* Continues a job that has been stopped. If move to foreground was requested,
 * then move the job to foreground and start monitoring it. */
bool resumejob(int j, int bg, sigset_t *mask) {
  if (j < 0) {
    for (j = njobmax - 1; j > 0 && jobs[j].state == FINISHED; j--)
      continue;
  }

  if (j >= njobmax || jobs[j].state == FINISHED)
    return false;

  /* DONE: Continue stopped job. Possibly move job to foreground slot. */
  /* change the state of job and all its processes to running <- we do that in
   * sigchld handler*/
  /*jobs[ j ].state = RUNNING;
  for( int i = 0; i < jobs[j].nproc; i++ )
    jobs[ j ].proc[ i ].state = RUNNING;
*/
  /* if foreground save shell settings and restore job settings
  then move it to the foreground, notify user,
  give control of the terminal, resume and start monitoring */
  if (!bg) {
    Tcgetattr(tty_fd, &shell_tmodes);
    Tcsetattr(tty_fd, 0, &jobs[FG].tmodes);
    movejob(j, FG);
    kill(-jobs[FG].pgid, SIGCONT);
    msg("continue '%s'\n", jobcmd(FG));
    monitorjob(mask);
  }
  /* if not foreground just resume it and notify user */
  else {
    kill(jobs[j].pgid, SIGCONT);
    msg("continue '%s'\n", jobcmd(j));
  }

  return true;
}

/* Kill the job by sending it a SIGTERM. */
bool killjob(int j) {
  if (j >= njobmax || jobs[j].state == FINISHED)
    return false;
  debug("[%d] killing '%s'\n", j, jobs[j].command);

  /* DONE: I love the smell of napalm in the morning. */
  /* start if stopped so it can be killed */
  kill(-jobs[j].pgid, SIGTERM);
  kill(-jobs[j].pgid, SIGCONT);

  return true;
}

/* Report state of requested background jobs. Clean up finished jobs. */
void watchjobs(int which) {
  for (int j = BG; j < njobmax; j++) {
    if (jobs[j].pgid == 0)
      continue;

    /* DONE: Report job number, state, command and exit code or signal. */
    /* check if there's a need to report the job */
    if (which == ALL || jobs[j].state == which) {
      /* report job number */
      msg("[%d] ", j);
      /* there's a need to clean up */
      if (jobs[j].state == FINISHED) {
        /* get exitcode and report what happened */
        /* !! what if exited with singal exitcode
        (WIFSIGNALED = true, but exited and not killed)
        or the same but another way? */
        int extcode = exitcode(&jobs[j]);

        if (WIFSIGNALED(extcode))
          msg("killed '%s' by signal %d\n", jobcmd(j), WTERMSIG(extcode));
        else if (WIFEXITED(extcode))
          msg("exited '%s', status=%d\n", jobcmd(j), WEXITSTATUS(extcode));
        deljob(&jobs[j]);
      }
      /* if running or stopped report it */
      else if (jobs[j].state == STOPPED)
        msg("suspended '%s'\n", jobcmd(j));
      else
        msg("running '%s'\n", jobcmd(j));
      /* absolutely no idea how those msg need to look like bc different tests
      require
      different versions of the output */
    }
  }
}

/* Monitor job execution. If it gets stopped move it to background.
 * When a job has finished or has been stopped move shell to foreground. */
int monitorjob(sigset_t *mask) {
  int exitcode = 0, state;

  /* DONE: Following code requires use of Tcsetpgrp of tty_fd. */
  /* give job control of the terminal */
  /* the gnu manual says it should be done before continuing job that was
  stopped
  but I don't have any errors doing it after sending SIGCONT
  (at least I hope I don't...)  and I don't want to do it twice */
  Tcsetpgrp(tty_fd, jobs[FG].pgid);

  /* wait for the job to stop running */
  while ((state = jobstate(FG, &exitcode)) == RUNNING)
    Sigsuspend(mask);

  /* check if job is finished or just stopped
  state = jobs[ FG ].state because otherwise compiler throws error unused for
  state */
  if (state == STOPPED) {
    /* save the job state */
    Tcgetattr(tty_fd, &jobs[FG].tmodes);

    /* move job to bg */
    int to = allocjob();
    movejob(FG, to);

    /* inform user the job has stopped */
    msg("stopped %s\n", jobcmd(to));
  }

  /* return control to the shell */
  Tcsetattr(tty_fd, 0, &shell_tmodes);
  Tcsetpgrp(tty_fd, getpgrp());

  return exitcode;
}

/* Called just at the beginning of shell's life. */
void initjobs(void) {
  Signal(SIGCHLD, sigchld_handler);
  jobs = calloc(sizeof(job_t), 1);

  /* Assume we're running in interactive mode, so move us to foreground.
   * Duplicate terminal fd, but do not leak it to subprocesses that execve. */
  assert(isatty(STDIN_FILENO));
  tty_fd = Dup(STDIN_FILENO);
  fcntl(tty_fd, F_SETFD, FD_CLOEXEC);

  /* Take control of the terminal. */
  Tcsetpgrp(tty_fd, getpgrp());

  /* Save default terminal attributes for the shell. */
  Tcgetattr(tty_fd, &shell_tmodes);
}

/* Called just before the shell finishes. */
void shutdownjobs(void) {
  sigset_t mask;
  Sigprocmask(SIG_BLOCK, &sigchld_mask, &mask);

  /* DONE: Kill remaining jobs and wait for them to finish. */
  /* iterate through all remaining jobs */
  for (int j = BG; j < njobmax; j++) {
    /* if job is not finished, kill it */
    if (jobs[j].state != FINISHED)
      killjob(j);

    /* wait for the job to be killed */
    while (jobs[j].state != FINISHED)
      Sigsuspend(&mask);
  }

  watchjobs(FINISHED);

  Sigprocmask(SIG_SETMASK, &mask, NULL);

  Close(tty_fd);
}
