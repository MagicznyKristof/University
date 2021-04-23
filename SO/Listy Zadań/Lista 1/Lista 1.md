# SO Lista 1

###### tags: `SO`

## Zadanie 1

Pojęcia do wyjaśnienia:
**rodzic-dziecko** - relacja miedzy procesami. Rodzic to proces, z którego tworzy się proces dziecko wywołaniem systemowym fork() w procesie-rodzicu
**Identyfikator procesu** - unikalny identyfikator (numer) procesu. W tabelce w kolumnie *PID*
**Identyfikator rodzica** - PID rodzica procesu. W tabelce w kolumnie *PPID*. ***init*** (PID = 1) nie ma rodzica (mimo, że istnieje proces o PID = 0 - proces bezczynności systemu).
**Identyfikator grupy procesów** - PID grupy procesów. wskazuje na PID pierwszego członka grupy. W tabelce w kolumnie *PGID*
**Właściciel procesu** - użytkownik, który uruchomił proces. W tabelce w kolumnie *USER*

```
USER       PID  PPID  PGID   TID PRI STAT WCHAN  CMD
root         1     0     1     1  19 Ss   -      /sbin/init splash
root         2     0     0     2  19 S    -      [kthreadd]
root         3     2     0     3  19 S    -      [ksoftirqd/0]
root         4     2     0     4  19 S    -      [kworker/0:0]
root         5     2     0     5  39 S<   -      [kworker/0:0H]
root         6     2     0     6  19 S    -      [kworker/u8:0]
root         7     2     0     7  19 S    -      [rcu_sched]
root         8     2     0     8  19 S    -      [rcu_bh]
root         9     2     0     9 139 S    -      [migration/0]
root        10     2     0    10 139 S    -      [watchdog/0]
root        11     2     0    11 139 S    -      [watchdog/1]
root        12     2     0    12 139 S    -      [migration/1]
root        13     2     0    13  19 S    -      [ksoftirqd/1]
root        14     2     0    14  19 S    -      [kworker/1:0]
root        15     2     0    15  39 S<   -      [kworker/1:0H]
root        16     2     0    16 139 S    -      [watchdog/2]
root        17     2     0    17 139 S    -      [migration/2]
root        18     2     0    18  19 S    -      [ksoftirqd/2]
root        19     2     0    19  19 S    -      [kworker/2:0]
root        20     2     0    20  39 S<   -      [kworker/2:0H]
root        21     2     0    21 139 S    -      [watchdog/3]
root        22     2     0    22 139 S    -      [migration/3]
root        23     2     0    23  19 S    -      [ksoftirqd/3]
root        24     2     0    24  19 S    -      [kworker/3:0]
root        25     2     0    25  39 S<   -      [kworker/3:0H]
root        26     2     0    26  19 S    -      [kdevtmpfs]
root        27     2     0    27  39 S<   -      [netns]
root        28     2     0    28  39 S<   -      [perf]
root        29     2     0    29  19 S    -      [khungtaskd]
root        30     2     0    30  39 S<   -      [writeback]
root        31     2     0    31  14 SN   -      [ksmd]
root        32     2     0    32   0 SN   -      [khugepaged]
root        33     2     0    33  39 S<   -      [crypto]
root        34     2     0    34  39 S<   -      [kintegrityd]
root        35     2     0    35  39 S<   -      [bioset]
root        36     2     0    36  39 S<   -      [kblockd]
root        37     2     0    37  39 S<   -      [ata_sff]
root        38     2     0    38  39 S<   -      [md]
root        39     2     0    39  39 S<   -      [devfreq_wq]
root        40     2     0    40  19 S    -      [kworker/0:1]
root        41     2     0    41  19 S    -      [kworker/u8:1]
root        42     2     0    42  19 S    -      [kworker/1:1]
root        44     2     0    44  19 S    -      [kswapd0]
root        45     2     0    45  39 S<   -      [vmstat]
root        46     2     0    46  19 S    -      [fsnotify_mark]
root        47     2     0    47  19 S    -      [ecryptfs-kthrea]
root        63     2     0    63  39 S<   -      [kthrotld]
root        64     2     0    64  39 S<   -      [acpi_thermal_pm]
root        65     2     0    65  19 S    -      [kworker/u8:2]
root        66     2     0    66  19 S    -      [kworker/3:1]
root        67     2     0    67  19 S    -      [kworker/2:1]
root        68     2     0    68  39 S<   -      [bioset]
root        69     2     0    69  39 S<   -      [bioset]
root        70     2     0    70  39 S<   -      [bioset]
root        71     2     0    71  39 S<   -      [bioset]
root        72     2     0    72  39 S<   -      [bioset]
root        73     2     0    73  39 S<   -      [bioset]
root        74     2     0    74  39 S<   -      [bioset]
root        75     2     0    75  39 S<   -      [bioset]
root        79     2     0    79  39 S<   -      [ipv6_addrconf]
root        92     2     0    92  19 S    -      [kworker/0:2]
root        93     2     0    93  39 S<   -      [deferwq]
root        94     2     0    94  39 S<   -      [charger_manager]
root       127     2     0   127  19 S    -      [kworker/0:3]
root       142     2     0   142  39 S<   -      [kpsmoused]
root       143     2     0   143  19 S    -      [kworker/2:2]
root       144     2     0   144  19 S    -      [scsi_eh_0]
root       145     2     0   145  39 S<   -      [scsi_tmf_0]
root       146     2     0   146  19 S    -      [scsi_eh_1]
root       147     2     0   147  39 S<   -      [scsi_tmf_1]
root       148     2     0   148  19 S    -      [scsi_eh_2]
root       149     2     0   149  39 S<   -      [scsi_tmf_2]
root       150     2     0   150  19 S    -      [scsi_eh_3]
root       151     2     0   151  39 S<   -      [scsi_tmf_3]
root       152     2     0   152  19 S    -      [kworker/u8:3]
root       153     2     0   153  19 S    -      [kworker/u8:4]
root       154     2     0   154  19 S    -      [kworker/u8:5]
root       155     2     0   155  39 S<   -      [rtsx_pci_sdmmc_]
root       156     2     0   156  19 S    -      [kworker/0:4]
root       161     2     0   161  39 S<   -      [bioset]
root       162     2     0   162  19 S    -      [kworker/u8:6]
root       184     2     0   184  39 S<   -      [kworker/2:1H]
root       186     2     0   186  19 S    -      [jbd2/sda6-8]
root       187     2     0   187  39 S<   -      [ext4-rsv-conver]
root       197     2     0   197  19 S    -      [kworker/3:2]
root       227     2     0   227  19 S    -      [kauditd]
root       236     2     0   236  19 S    -      [kworker/1:2]
root       241     1   241   241  19 Ss   -      /lib/systemd/systemd-journald
root       250     2     0   250  39 S<   -      [kworker/3:1H]
root       267     2     0   267  39 S<   -      [kworker/0:1H]
root       277     2     0   277  19 S    -      [kworker/3:3]
root       297     1   297   297  19 Ss   -      /lib/systemd/systemd-udevd
root       325     2     0   325  19 S    -      [kworker/2:3]
systemd+   383     1   383   383  19 Ssl  -      /lib/systemd/systemd-timesyncd
root       483     2     0   483  90 S    -      [irq/49-mei_me]
root       500     2     0   500  39 S<   -      [kmemstick]
root       533     2     0   533  39 S<   -      [cfg80211]
root       544     2     0   544  90 S    -      [irq/50-iwlwifi]
root       545     2     0   545  39 S<   -      [kworker/u9:0]
root       546     2     0   546  39 S<   -      [hci0]
root       548     2     0   548  39 S<   -      [hci0]
root       550     2     0   550  39 S<   -      [kworker/u9:1]
root       554     2     0   554  39 S<   -      [kworker/u9:2]
root       662     2     0   662  39 S<   -      [kvm-irqfd-clean]
root       742     2     0   742  39 S<   -      [kworker/1:1H]
root       848     1   848   848  19 Ssl  -      /usr/lib/accountsservice/accoun
root       856     1   856   856  19 Ssl  -      /usr/sbin/ModemManager
root       861     1   861   861  19 Ss   -      /usr/sbin/acpid
root       867     1   867   867  19 Ssl  -      /usr/sbin/thermald --no-daemon 
message+   869     1   869   869  19 Ss   -      /usr/bin/dbus-daemon --system -
root       878     1   878   878  19 Ssl  -      /usr/sbin/NetworkManager --no-d
root       882     1   882   882  19 Ss   -      /lib/systemd/systemd-logind
syslog     885     1   885   885  19 Ssl  -      /usr/sbin/rsyslogd -n
root       891     1   891   891  19 Ss   -      /usr/sbin/cron -f
root       905     1   905   905  19 Ss   -      /usr/sbin/smartd -n
root       917     1   917   917  19 Ss   -      /usr/sbin/cupsd -l
avahi      922     1   922   922  19 Ss   -      avahi-daemon: running [Latitude
root       924     1   924   924  19 Ss   -      /usr/lib/bluetooth/bluetoothd
avahi      951   922   922   951  19 S    -      avahi-daemon: chroot helper
root       984     1   984   984  19 Ss   -      /usr/sbin/irqbalance --pid=/var
root       992     1   992   992  19 Ssl  -      /usr/sbin/cups-browsed
root       993     1   993   993  19 Ssl  -      /usr/lib/policykit-1/polkitd --
root      1014     1  1014  1014  19 SLsl -      /usr/sbin/lightdm
colord    1040     1  1040  1040  19 Ssl  -      /usr/lib/colord/colord
root      1049     1  1049  1049  19 Ssl  -      /usr/bin/python3 /usr/share/una
root      1061  1014  1061  1061  19 Ssl+ -      /usr/lib/xorg/Xorg -core :0 -se
postgres  1125     1  1125  1125  19 Ss   -      /usr/lib/postgresql/12/bin/post
postgres  1126     1  1105  1126  19 S    -      /usr/lib/postgresql/11/bin/post
postgres  1159  1125  1159  1159  19 Ss   -      postgres: 12/main: checkpointer
postgres  1160  1125  1160  1160  19 Ss   -      postgres: 12/main: background w
postgres  1161  1125  1161  1161  19 Ss   -      postgres: 12/main: walwriter   
postgres  1163  1125  1163  1163  19 Ss   -      postgres: 12/main: autovacuum l
postgres  1164  1125  1164  1164  19 Ss   -      postgres: 12/main: stats collec
postgres  1165  1125  1165  1165  19 Ss   -      postgres: 12/main: logical repl
postgres  1166  1126  1166  1166  19 Ss   -      postgres: 11/main: checkpointer
postgres  1167  1126  1167  1167  19 Ss   -      postgres: 11/main: background w
postgres  1168  1126  1168  1168  19 Ss   -      postgres: 11/main: walwriter   
postgres  1169  1126  1169  1169  19 Ss   -      postgres: 11/main: autovacuum l
postgres  1170  1126  1170  1170  19 Ss   -      postgres: 11/main: stats collec
postgres  1171  1126  1171  1171  19 Ss   -      postgres: 11/main: logical repl
root      1213     1  1213  1213  19 Ss   -      /sbin/wpa_supplicant -u -s -O /
lightdm   1227     1  1227  1227  19 Ss   -      /lib/systemd/systemd --user
lightdm   1229  1227  1227  1229  19 S    -      (sd-pam)
lightdm   1245     1  1244  1245  19 Sl   -      /usr/bin/gnome-keyring-daemon -
rtkit     1510     1  1510  1510  18 SNsl -      /usr/lib/rtkit/rtkit-daemon
root      1562     1  1562  1562  19 Ssl  -      /usr/lib/upower/upowerd
root      1593     2     0  1593  29 S<   -      [krfcommd]
whoopsie  2255     1  2255  2255  19 Ssl  -      /usr/bin/whoopsie -f
root      2256     1  2256  2256  19 Ssl  -      /usr/sbin/nordvpnd
root      2275     1  2275  2275  19 Ss+  -      /sbin/agetty --noclear tty1 lin
root      2441  1014  1014  2441  19 Sl   -      lightdm --session-child 12 19
magiczn+  2453     1  2453  2453  19 Ss   ep_pol /lib/systemd/systemd --user
magiczn+  2454  2453  2453  2454  19 S    -      (sd-pam)
magiczn+  2460     1  2459  2460  19 Sl   -      /usr/bin/gnome-keyring-daemon -
magiczn+  2462  2441  2462  2462  19 Ss   poll_s /sbin/upstart --user
magiczn+  2537  2462  2535  2537  19 S    poll_s upstart-udev-bridge --daemon --
magiczn+  2550  2462  2550  2550  19 Ss   ep_pol dbus-daemon --fork --session --
magiczn+  2562  2462  2562  2562  19 Ss   poll_s /usr/lib/x86_64-linux-gnu/hud/w
magiczn+  2598  2462  2596  2598  19 S    poll_s upstart-dbus-bridge --daemon --
magiczn+  2600  2462  2599  2600  19 S    poll_s upstart-file-bridge --daemon --
magiczn+  2603  2462  2602  2603  19 S    poll_s upstart-dbus-bridge --daemon --
magiczn+  2607  2462  2607  2607  19 Ssl  poll_s /usr/bin/ibus-daemon --daemoniz
magiczn+  2616  2462  2550  2616  19 Sl   poll_s /usr/lib/gvfs/gvfsd
magiczn+  2618  2462  2618  2618  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/bamf/
magiczn+  2625  2462  2550  2625  19 Sl   futex_ /usr/lib/gvfs/gvfsd-fuse /run/u
magiczn+  2634  2607  2607  2634  19 Sl   poll_s /usr/lib/ibus/ibus-dconf
magiczn+  2635  2607  2607  2635  19 Sl   poll_s /usr/lib/ibus/ibus-ui-gtk3
magiczn+  2638  2462  2607  2638  19 Sl   poll_s /usr/lib/ibus/ibus-x11 --kill-d
magiczn+  2654  2607  2607  2654  19 Sl   poll_s /usr/lib/ibus/ibus-engine-simpl
root      2703   878  2703  2703  19 S    -      /sbin/dhclient -d -q -sf /usr/l
magiczn+  2709  2462  2709  2709  19 Ss   -      gpg-agent --homedir /home/magic
nobody    2714   878  2714  2714  19 S    -      /usr/sbin/dnsmasq --no-resolv -
magiczn+  2872  2462  2872  2872  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/hud/h
magiczn+  2874  2462  2874  2874  19 Ssl  poll_s /usr/lib/unity-settings-daemon/
magiczn+  2880  2462  2880  2880  19 Ssl  poll_s /usr/lib/at-spi2-core/at-spi-bu
magiczn+  2881  2462  2881  2881  19 Ssl  poll_s /usr/lib/gnome-session/gnome-se
magiczn+  2890  2880  2880  2890  19 S    ep_pol /usr/bin/dbus-daemon --config-f
magiczn+  2897  2462  2897  2897  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/unity
magiczn+  2903  2462  2880  2903  19 Sl   poll_s /usr/lib/at-spi2-core/at-spi2-r
magiczn+  2932  2462  2932  2932  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2933  2462  2933  2933  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2943  2462  2943  2943  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2944  2462  2944  2944  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2945  2462  2945  2945  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2946  2462  2946  2946  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2947  2462  2947  2947  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2950  2462  2950  2950  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2969  2462  2550  2969  19 Sl   poll_s /usr/lib/dconf/dconf-service
magiczn+  2978  2462  2978  2978  19 Ssl  poll_s /usr/lib/x86_64-linux-gnu/indic
magiczn+  2992  2462  2991  2992  30 S<l  poll_s /usr/bin/pulseaudio --start --l
magiczn+  3013  2874  2874  3013  19 S    poll_s syndaemon -i 1.0 -t -K -R
magiczn+  3017  2462  2550  3017  19 Sl   poll_s /usr/lib/evolution/evolution-so
magiczn+  3025  2462  3025  3025  19 Ssl  poll_s compiz
magiczn+  3061  2881  2881  3061  19 Sl   poll_s /usr/lib/policykit-1-gnome/polk
magiczn+  3062  2881  2881  3062  19 Sl   poll_s /usr/lib/unity-settings-daemon/
magiczn+  3063  2881  2881  3063  19 Sl   poll_s nautilus -n
magiczn+  3074  2462  2550  3074  19 Sl   poll_s /usr/lib/evolution/evolution-ca
magiczn+  3076  2881  2881  3076  19 SLl  poll_s /usr/bin/gnome-software --gappl
magiczn+  3080  2881  2881  3080  19 Sl   poll_s nm-applet
magiczn+  3108  2462  2550  3108  19 Sl   poll_s /usr/lib/gvfs/gvfs-udisks2-volu
root      3112     1  3112  3112  19 Ssl  -      /usr/lib/udisks2/udisksd --no-d
root      3119     1  3119  3119  19 Ssl  -      /usr/lib/x86_64-linux-gnu/fwupd
magiczn+  3124  2462  2550  3124  19 Sl   poll_s /usr/lib/gvfs/gvfs-goa-volume-m
magiczn+  3130  2462  2550  3130  19 Sl   poll_s /usr/lib/gvfs/gvfs-mtp-volume-m
magiczn+  3135  2462  2550  3135  19 Sl   poll_s /usr/lib/gvfs/gvfs-gphoto2-volu
magiczn+  3142  2462  2550  3142  19 Sl   poll_s /usr/lib/gvfs/gvfs-afc-volume-m
magiczn+  3154  3074  2550  3154  19 Sl   poll_s /usr/lib/evolution/evolution-ca
magiczn+  3165  2462  2550  3165  19 Sl   poll_s /usr/lib/evolution/evolution-ad
magiczn+  3166  3074  2550  3166  19 Sl   poll_s /usr/lib/evolution/evolution-ca
magiczn+  3178  3165  2550  3178  19 Sl   poll_s /usr/lib/evolution/evolution-ad
magiczn+  3196  2462  2550  3196  19 Sl   poll_s /usr/lib/gvfs/gvfsd-trash --spa
magiczn+  3220  2462  2550  3220  19 Sl   poll_s /usr/lib/gvfs/gvfsd-metadata
magiczn+  3245  2462  3025  3245  19 SLl  poll_s /opt/google/chrome/chrome
magiczn+  3252  3245  3025  3252  19 S    pipe_w cat
magiczn+  3253  3245  3025  3253  19 S    pipe_w cat
magiczn+  3256  3245  3025  3256  19 S    poll_s /opt/google/chrome/chrome --typ
magiczn+  3257  3245  3025  3257  19 S    wait   /opt/google/chrome/chrome --typ
magiczn+  3258  3257  3025  3258  19 S    skb_re /opt/google/chrome/nacl_helper
magiczn+  3261  3257  3025  3261  19 S    poll_s /opt/google/chrome/chrome --typ
magiczn+  3281  3256  3025  3281  19 Sl   poll_s /opt/google/chrome/chrome --typ
magiczn+  3285  3245  3025  3285  19 SLl  futex_ /opt/google/chrome/chrome --typ
magiczn+  3294  3281  3025  3294  19 S    skb_re /opt/google/chrome/chrome --typ
magiczn+  3306  2462  2550  3306  19 Sl   poll_s /usr/lib/x86_64-linux-gnu/notif
magiczn+  3321  3261  3025  3321  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3323  3261  3025  3323  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3345  3261  3025  3345  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3369  3261  3025  3369  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3392  3261  3025  3392  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3405  3261  3025  3405  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3409  3261  3025  3409  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3427  3261  3025  3427  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3442  2881  2881  3442  19 Sl   poll_s zeitgeist-datahub
magiczn+  3450  2462  2550  3450  19 S    wait   /bin/sh -c /usr/lib/x86_64-linu
magiczn+  3454  3450  2550  3454  19 Sl   poll_s /usr/bin/zeitgeist-daemon
magiczn+  3463  2462  2550  3463  19 Sl   poll_s /usr/lib/x86_64-linux-gnu/zeitg
magiczn+  3493  3261  3025  3493  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3508  3261  3025  3508  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3520  3261  3025  3520  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3574  3261  3025  3574  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3595  3261  3025  3595  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3607  3261  3025  3607  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3619  3261  3025  3619  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3632  3261  3025  3632  19 Sl   futex_ /opt/google/chrome/chrome --typ
magiczn+  3647  2462  2550  3647  19 Rl   poll_s /usr/lib/gnome-terminal/gnome-t
magiczn+  3654  3647  3654  3654  19 Ss   wait   bash
magiczn+  3698  3654  3698  3698  19 R+   -      ps -eo user,pid,ppid,pgid,tid,p

```

Jakie jest znaczenie poszczególnych znaków w kolumnie STAT?
Za podręcznikiem systemowym:


```
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state
       of a process:

               D    uninterruptible sleep (usually IO)
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

```

Drzewo hierarchii procesów ({wątki} oznaczone w ten sposób):
```
systemd─┬─ModemManager─┬─{gdbus}
        │              └─{gmain}
        ├─NetworkManager─┬─dhclient
        │                ├─dnsmasq
        │                ├─{gdbus}
        │                └─{gmain}
        ├─accounts-daemon─┬─{gdbus}
        │                 └─{gmain}
        ├─acpid
        ├─agetty
        ├─avahi-daemon───avahi-daemon
        ├─bluetoothd
        ├─colord─┬─{gdbus}
        │        └─{gmain}
        ├─cron
        ├─cups-browsed─┬─{gdbus}
        │              └─{gmain}
        ├─cupsd
        ├─dbus-daemon
        ├─fwupd─┬─{GUsbEventThread}
        │       ├─{fwupd}
        │       ├─{gdbus}
        │       └─{gmain}
        ├─gnome-keyring-d─┬─{gdbus}
        │                 ├─{gmain}
        │                 └─{timer}
        ├─irqbalance
        ├─lightdm─┬─Xorg───{Xorg}
        │         ├─lightdm─┬─upstart─┬─at-spi-bus-laun─┬─dbus-daemon
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─at-spi2-registr─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─bamfdaemon─┬─{dconf worker}
        │         │         │         │            ├─{gdbus}
        │         │         │         │            ├─{gmain}
        │         │         │         │            └─{pool}
        │         │         │         ├─chrome─┬─2*[cat]
        │         │         │         │        ├─chrome───chrome─┬─chrome
        │         │         │         │        │                 ├─{Chrome_ChildIOT}
        │         │         │         │        │                 ├─{GpuWatchdog}
        │         │         │         │        │                 ├─{MemoryInfra}
        │         │         │         │        │                 ├─2*[{ThreadPoolForeg}]
        │         │         │         │        │                 ├─{ThreadPoolServi}
        │         │         │         │        │                 └─{VizCompositorTh}
        │         │         │         │        ├─chrome─┬─chrome─┬─7*[chrome─┬─{Chrome_ChildIOT}]
        │         │         │         │        │        │        │           ├─3*[{CompositorTileW}]]
        │         │         │         │        │        │        │           ├─{Compositor}]
        │         │         │         │        │        │        │           ├─{GpuMemoryThread}]
        │         │         │         │        │        │        │           ├─{MemoryInfra}]
        │         │         │         │        │        │        │           ├─{ThreadPoolForeg}]
        │         │         │         │        │        │        │           ├─{ThreadPoolServi}]
        │         │         │         │        │        │        │           └─{ThreadPoolSingl}]
        │         │         │         │        │        │        ├─chrome─┬─{Chrome_ChildIOT}
        │         │         │         │        │        │        │        ├─3*[{CompositorTileW}]
        │         │         │         │        │        │        │        ├─{Compositor}
        │         │         │         │        │        │        │        ├─{GpuMemoryThread}
        │         │         │         │        │        │        │        ├─{MemoryInfra}
        │         │         │         │        │        │        │        ├─{ThreadPoolForeg}
        │         │         │         │        │        │        │        ├─{ThreadPoolServi}
        │         │         │         │        │        │        │        ├─{ThreadPoolSingl}
        │         │         │         │        │        │        │        └─{WebCrypto}
        │         │         │         │        │        │        ├─chrome─┬─{Chrome_ChildIOT}
        │         │         │         │        │        │        │        ├─3*[{CompositorTileW}]
        │         │         │         │        │        │        │        ├─{Compositor}
        │         │         │         │        │        │        │        ├─{GpuMemoryThread}
        │         │         │         │        │        │        │        ├─{MemoryInfra}
        │         │         │         │        │        │        │        ├─{ThreadPoolForeg}
        │         │         │         │        │        │        │        ├─{ThreadPoolServi}
        │         │         │         │        │        │        │        ├─2*[{ThreadPoolSingl}]
        │         │         │         │        │        │        │        └─{WebCrypto}
        │         │         │         │        │        │        ├─2*[chrome─┬─{Chrome_ChildIOT}]
        │         │         │         │        │        │        │           ├─{MemoryInfra}]
        │         │         │         │        │        │        │           ├─{ThreadPoolForeg}]
        │         │         │         │        │        │        │           └─{ThreadPoolServi}]
        │         │         │         │        │        │        └─9*[chrome─┬─{Chrome_ChildIOT}]
        │         │         │         │        │        │                    ├─3*[{CompositorTileW}]]
        │         │         │         │        │        │                    ├─{Compositor}]
        │         │         │         │        │        │                    ├─{GpuMemoryThread}]
        │         │         │         │        │        │                    ├─{MemoryInfra}]
        │         │         │         │        │        │                    ├─2*[{ThreadPoolForeg}]]
        │         │         │         │        │        │                    ├─{ThreadPoolServi}]
        │         │         │         │        │        │                    └─{ThreadPoolSingl}]
        │         │         │         │        │        └─nacl_helper
        │         │         │         │        ├─chrome─┬─{Chrome_ChildIOT}
        │         │         │         │        │        ├─{MemoryInfra}
        │         │         │         │        │        ├─10*[{ThreadPoolForeg}]
        │         │         │         │        │        ├─{ThreadPoolServi}
        │         │         │         │        │        ├─{gdbus}
        │         │         │         │        │        ├─{gmain}
        │         │         │         │        │        └─{inotify_reader}
        │         │         │         │        ├─{BatteryStatusNo}
        │         │         │         │        ├─{Bluez D-Bus thr}
        │         │         │         │        ├─{BrowserWatchdog}
        │         │         │         │        ├─{CacheThread_Blo}
        │         │         │         │        ├─{Chrome_DevTools}
        │         │         │         │        ├─{Chrome_IOThread}
        │         │         │         │        ├─{CompositorTileW}
        │         │         │         │        ├─{CrShutdownDetec}
        │         │         │         │        ├─{MemoryInfra}
        │         │         │         │        ├─6*[{ThreadPoolForeg}]
        │         │         │         │        ├─{ThreadPoolServi}
        │         │         │         │        ├─2*[{ThreadPoolSingl}]
        │         │         │         │        ├─{VideoCaptureThr}
        │         │         │         │        ├─{chrome}
        │         │         │         │        ├─{dconf worker}
        │         │         │         │        ├─{extension_crash}
        │         │         │         │        ├─{gdbus}
        │         │         │         │        ├─{gmain}
        │         │         │         │        ├─{gpu-process_cra}
        │         │         │         │        ├─{inotify_reader}
        │         │         │         │        ├─{ppapi_crash_upl}
        │         │         │         │        ├─{renderer_crash_}
        │         │         │         │        ├─{sandbox_ipc_thr}
        │         │         │         │        └─{utility_crash_u}
        │         │         │         ├─compiz─┬─{dconf worker}
        │         │         │         │        ├─{gdbus}
        │         │         │         │        ├─{gmain}
        │         │         │         │        └─4*[{pool}]
        │         │         │         ├─dbus-daemon
        │         │         │         ├─dconf-service─┬─{gdbus}
        │         │         │         │               └─{gmain}
        │         │         │         ├─evolution-addre─┬─evolution-addre─┬─{dconf worker}
        │         │         │         │                 │                 ├─{evolution-addre}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{evolution-addre}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─evolution-calen─┬─evolution-calen─┬─{dconf worker}
        │         │         │         │                 │                 ├─2*[{evolution-calen}]
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 ├─{gmain}
        │         │         │         │                 │                 └─{pool}
        │         │         │         │                 ├─evolution-calen─┬─{dconf worker}
        │         │         │         │                 │                 ├─{evolution-calen}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{evolution-calen}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─evolution-sourc─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gnome-session-b─┬─deja-dup-monito─┬─{dconf worker}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─gnome-software─┬─{dconf worker}
        │         │         │         │                 │                ├─{gdbus}
        │         │         │         │                 │                └─{gmain}
        │         │         │         │                 ├─nautilus─┬─{dconf worker}
        │         │         │         │                 │          ├─{gdbus}
        │         │         │         │                 │          └─{gmain}
        │         │         │         │                 ├─nm-applet─┬─{dconf worker}
        │         │         │         │                 │           ├─{gdbus}
        │         │         │         │                 │           └─{gmain}
        │         │         │         │                 ├─polkit-gnome-au─┬─{dconf worker}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─unity-fallback-─┬─{dconf worker}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─update-notifier─┬─{dconf worker}
        │         │         │         │                 │                 ├─{gdbus}
        │         │         │         │                 │                 └─{gmain}
        │         │         │         │                 ├─zeitgeist-datah─┬─{gdbus}
        │         │         │         │                 │                 ├─{gmain}
        │         │         │         │                 │                 └─4*[{pool}]
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gnome-terminal-─┬─bash───pstree
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gpg-agent
        │         │         │         ├─gvfs-afc-volume─┬─{gdbus}
        │         │         │         │                 ├─{gmain}
        │         │         │         │                 └─{gvfs-afc-volume}
        │         │         │         ├─gvfs-goa-volume─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gvfs-gphoto2-vo─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gvfs-mtp-volume─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gvfs-udisks2-vo─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gvfsd─┬─{gdbus}
        │         │         │         │       └─{gmain}
        │         │         │         ├─gvfsd-dnssd─┬─{gdbus}
        │         │         │         │             └─{gmain}
        │         │         │         ├─gvfsd-fuse─┬─{gdbus}
        │         │         │         │            ├─{gmain}
        │         │         │         │            ├─{gvfs-fuse-sub}
        │         │         │         │            └─2*[{gvfsd-fuse}]
        │         │         │         ├─gvfsd-metadata─┬─{gdbus}
        │         │         │         │                └─{gmain}
        │         │         │         ├─gvfsd-network─┬─{dconf worker}
        │         │         │         │               ├─{gdbus}
        │         │         │         │               └─{gmain}
        │         │         │         ├─gvfsd-smb-brows─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─gvfsd-trash─┬─{gdbus}
        │         │         │         │             └─{gmain}
        │         │         │         ├─hud-service─┬─{dconf worker}
        │         │         │         │             ├─{gdbus}
        │         │         │         │             └─{gmain}
        │         │         │         ├─ibus-daemon─┬─ibus-dconf─┬─{dconf worker}
        │         │         │         │             │            ├─{gdbus}
        │         │         │         │             │            └─{gmain}
        │         │         │         │             ├─ibus-engine-sim─┬─{gdbus}
        │         │         │         │             │                 └─{gmain}
        │         │         │         │             ├─ibus-ui-gtk3─┬─{dconf worker}
        │         │         │         │             │              ├─{gdbus}
        │         │         │         │             │              └─{gmain}
        │         │         │         │             ├─{gdbus}
        │         │         │         │             └─{gmain}
        │         │         │         ├─ibus-x11─┬─{dconf worker}
        │         │         │         │          ├─{gdbus}
        │         │         │         │          └─{gmain}
        │         │         │         ├─indicator-appli─┬─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-bluet─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-datet─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 ├─{gmain}
        │         │         │         │                 ├─{indicator-datet}
        │         │         │         │                 └─{pool}
        │         │         │         ├─indicator-keybo─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-messa─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-power─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-print─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-sessi─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─indicator-sound─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─notify-osd─┬─{dconf worker}
        │         │         │         │            ├─{gdbus}
        │         │         │         │            └─{gmain}
        │         │         │         ├─pulseaudio─┬─{alsa-sink-ALC32}
        │         │         │         │            ├─{alsa-sink-HDMI }
        │         │         │         │            └─{alsa-source-ALC}
        │         │         │         ├─sh───zeitgeist-daemo─┬─{gdbus}
        │         │         │         │                      └─{gmain}
        │         │         │         ├─unity-panel-ser─┬─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─unity-settings-─┬─syndaemon
        │         │         │         │                 ├─{dconf worker}
        │         │         │         │                 ├─{gdbus}
        │         │         │         │                 └─{gmain}
        │         │         │         ├─2*[upstart-dbus-br]
        │         │         │         ├─upstart-file-br
        │         │         │         ├─upstart-udev-br
        │         │         │         ├─window-stack-br
        │         │         │         └─zeitgeist-fts─┬─{gdbus}
        │         │         │                         └─{gmain}
        │         │         ├─{gdbus}
        │         │         └─{gmain}
        │         ├─{gdbus}
        │         └─{gmain}
        ├─nordvpnd───9*[{nordvpnd}]
        ├─polkitd─┬─{gdbus}
        │         └─{gmain}
        ├─2*[postgres───6*[postgres]]
        ├─rsyslogd─┬─{in:imklog}
        │          ├─{in:imuxsock}
        │          └─{rs:main Q:Reg}
        ├─rtkit-daemon───2*[{rtkit-daemon}]
        ├─smartd
        ├─systemd───(sd-pam)
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-timesyn───{sd-resolve}
        ├─systemd-udevd
        ├─thermald───{thermald}
        ├─udisksd─┬─{cleanup}
        │         ├─{gdbus}
        │         ├─{gmain}
        │         └─{probing-thread}
        ├─unattended-upgr───{gmain}
        ├─upowerd─┬─{gdbus}
        │         └─{gmain}
        ├─whoopsie─┬─{gdbus}
        │          └─{gmain}
        └─wpa_supplicant

```

## Zadanie 2

system plików proc(5) - system plików służący jako interfejs do struktur kernela. 

*/proc* zawiera folder */proc/pid* dla każdego procesu. 

Plik zawierający zmienne systemowe i argumenty programu (environ)
```
XDG_VTNR=7
LC_PAPER=pl_PL.UTF-8
XDG_SESSION_ID=c2
LC_ADDRESS=pl_PL.UTF-8
CLUTTER_IM_MODULE=xim
XDG_GREETER_DATA_DIR=/var/lib/lightdm-data/magicznykrzysztof
LC_MONETARY=pl_PL.UTF-8
SHELL=/bin/bash
QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1
LC_NUMERIC=pl_PL.UTF-8
GTK_MODULES=gail:atk-bridge
USER=magicznykrzysztof
QT_ACCESSIBILITY=1
LC_TELEPHONE=pl_PL.UTF-8
XDG_SESSION_PATH=/org/freedesktop/DisplayManager/Session0
XDG_SEAT_PATH=/org/freedesktop/DisplayManager/Seat0
DEFAULTS_PATH=/usr/share/gconf/ubuntu.default.path
XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/usr/share/upstart/xdg:/etc/xdg
DESKTOP_SESSION=ubuntu
PATH=/home/magicznykrzysztof/bin:/home/magicznykrzysztof/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
QT_IM_MODULE=ibus
QT_QPA_PLATFORMTHEME=appmenu-qt5
LC_IDENTIFICATION=pl_PL.UTF-8
PWD=/home/magicznykrzysztof
XDG_SESSION_TYPE=x11
XMODIFIERS=@im=ibus
LANG=en_US.UTF-8
MANDATORY_PATH=/usr/share/gconf/ubuntu.mandatory.path
GDM_LANG=en_US
LC_MEASUREMENT=pl_PL.UTF-8
IM_CONFIG_PHASE=1
COMPIZ_CONFIG_PROFILE=ubuntu
GDMSESSION=ubuntu
SESSIONTYPE=gnome-session
GTK2_MODULES=overlay-scrollbar
SHLVL=0
XDG_SEAT=seat0
HOME=/home/magicznykrzysztof
LANGUAGE=en_US
XDG_SESSION_DESKTOP=ubuntu
LOGNAME=magicznykrzysztof
QT4_IM_MODULE=xim
XDG_DATA_DIRS=/usr/share/ubuntu:/usr/share/gnome:/usr/local/share:/usr/share:/var/lib/snapd/desktop:/var/lib/snapd/desktop
XDG_RUNTIME_DIR=/run/user/1000
DISPLAY=:0
GTK_IM_MODULE=ibus
XDG_CURRENT_DESKTOP=Unity
LC_TIME=pl_PL.UTF-8
XAUTHORITY=/home/magicznykrzysztof/.Xauthority
LC_NAME=pl_PL.UTF-8
```

Plik status

Uid - user ID
Gid - group ID
Groups - uzupełniająca lista grup
Vmpeak - najwyższa pamięć wirtualna programu
Vmsize - rozmiar programu
VmRSS - rozmiar pamięci
Threads - liczba wątków procesu
volountary_ctxt_switches - liczba dobrowolnych przełączeń kontekstu
nonvolountary_ctxt_switches - liczba wymuszonych przełączeń kontekstu
```
Name:	upstart
State:	S (sleeping)
Tgid:	2462
Ngid:	0
Pid:	2462
PPid:	2441
TracerPid:	0
Uid:	1000	1000	1000	1000
Gid:	1000	1000	1000	1000
FDSize:	256
Groups:	4 20 24 27 30 46 113 128 1000 1001 
NStgid:	2462
NSpid:	2462
NSpgid:	2462
NSsid:	2462
VmPeak:	   47684 kB
VmSize:	   47684 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	    4884 kB
VmRSS:	    4884 kB
VmData:	    1040 kB
VmStk:	     132 kB
VmExe:	     284 kB
VmLib:	    5024 kB
VmPTE:	     112 kB
VmPMD:	      12 kB
VmSwap:	       0 kB
HugetlbPages:	       0 kB
Threads:	1
SigQ:	0/30256
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	0000000000001000
SigCgt:	0000000180016001
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	0000003fffffffff
CapAmb:	0000000000000000
Seccomp:	0
Speculation_Store_Bypass:	thread vulnerable
Cpus_allowed:	f
Cpus_allowed_list:	0-3
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	763
nonvoluntary_ctxt_switches:	471
```

## Zadanie 3

stos - linijka oznaczona w kolumnie Mapping jako [ stack ]
sterta - linijka 5

pamięć anonimowa - pamięć niepowiązana z żadnym plikiem - oznaczona jako [ anon ]

pliki odwzorowane do pamięci - segmenty programu, które są odwzorowaniem jakichś akichś fragmentów pliku - wszystkie linijki, gdzie mamy nazwę (adres?) pliku

1. adres w pamięci
2. rozmiar
3. pozwolenia - read, write, execute, shared, private
4. mapowanie

```=
00005597a1523000   2288K r-x-- Xorg
00005597a195f000      8K r---- Xorg
00005597a1961000     52K rw--- Xorg
00005597a196e000     68K rw---   [ anon ]
00005597a3117000   8512K rw---   [ anon ]
00007fc5f40c8000   4092K rw-s- drm mm object (deleted)
00007fc5f44c7000   4224K rw-s- card0
00007fc5f48e7000   4224K rw-s- drm mm object (deleted)
00007fc5f4d07000   4224K rw-s- drm mm object (deleted)
00007fc5f5127000   4224K rw-s- drm mm object (deleted)
00007fc5f5547000  65536K rw-s-   [ shmid=0x138009 ]
00007fc5f9547000   1092K rw-s- drm mm object (deleted)
00007fc5f9658000   1092K rw-s- drm mm object (deleted)
00007fc5f9929000    512K rw-s-   [ shmid=0x1b800c ]
00007fc5f99a9000    512K rw-s-   [ shmid=0x1a000b ]
00007fc5f9a69000    512K rw-s-   [ shmid=0x16800a ]
00007fc5f9ae9000    512K rw-s-   [ shmid=0x150007 ]
00007fc5f9b69000    512K rw-s-   [ shmid=0x120008 ]
00007fc5f9be9000    512K rw-s-   [ shmid=0x100006 ]
00007fc5f9c69000  16384K rw-s-   [ shmid=0xd8003 ]
00007fc5fac69000   4224K rw-s- card0
00007fc5fb089000    512K rw-s-   [ shmid=0x180005 ]
00007fc5fb109000    512K rw-s-   [ shmid=0xb0004 ]
00007fc5fb189000   4224K rw-s- card0
00007fc5fb5a9000   4224K rw-s- card0
00007fc5fb9c9000     44K r-x-- libnss_files-2.23.so
00007fc5fb9d4000   2044K ----- libnss_files-2.23.so
00007fc5fbbd3000      4K r---- libnss_files-2.23.so
00007fc5fbbd4000      4K rw--- libnss_files-2.23.so
00007fc5fbbd5000     24K rw---   [ anon ]
00007fc5fbbdb000     44K r-x-- libnss_nis-2.23.so
00007fc5fbbe6000   2044K ----- libnss_nis-2.23.so
00007fc5fbde5000      4K r---- libnss_nis-2.23.so
00007fc5fbde6000      4K rw--- libnss_nis-2.23.so
00007fc5fbde7000     88K r-x-- libnsl-2.23.so
00007fc5fbdfd000   2044K ----- libnsl-2.23.so
00007fc5fbffc000      4K r---- libnsl-2.23.so
00007fc5fbffd000      4K rw--- libnsl-2.23.so
00007fc5fbffe000      8K rw---   [ anon ]
00007fc5fc000000    136K rw---   [ anon ]
00007fc5fc022000  65400K -----   [ anon ]
00007fc600072000     32K r-x-- libnss_compat-2.23.so
00007fc60007a000   2044K ----- libnss_compat-2.23.so
00007fc600279000      4K r---- libnss_compat-2.23.so
00007fc60027a000      4K rw--- libnss_compat-2.23.so
00007fc60027b000   4096K rw-s- card0
00007fc60067b000     68K r-x-- synaptics_drv.so
00007fc60068c000   2044K ----- synaptics_drv.so
00007fc60088b000      4K r---- synaptics_drv.so
00007fc60088c000      4K rw--- synaptics_drv.so
00007fc60088d000     76K r-x-- libevdev.so.2.1.12
00007fc6008a0000   2044K ----- libevdev.so.2.1.12
00007fc600a9f000     24K r---- libevdev.so.2.1.12
00007fc600aa5000      4K rw--- libevdev.so.2.1.12
00007fc600aa6000     20K r-x-- libmtdev.so.1.0.0
00007fc600aab000   2044K ----- libmtdev.so.1.0.0
00007fc600caa000      4K r---- libmtdev.so.1.0.0
00007fc600cab000      4K rw--- libmtdev.so.1.0.0
00007fc600cac000     56K r-x-- evdev_drv.so
00007fc600cba000   2044K ----- evdev_drv.so
00007fc600eb9000      4K r---- evdev_drv.so
00007fc600eba000      4K rw--- evdev_drv.so
00007fc600ebb000   4224K rw-s- card0
00007fc6012db000   1868K r-x-- libstdc++.so.6.0.28
00007fc6014ae000   2044K ----- libstdc++.so.6.0.28
00007fc6016ad000     44K r---- libstdc++.so.6.0.28
00007fc6016b8000     12K rw--- libstdc++.so.6.0.28
00007fc6016bb000     12K rw---   [ anon ]
00007fc6016be000   9088K r-x-- i965_dri.so
00007fc601f9e000   2048K ----- i965_dri.so
00007fc60219e000    320K r---- i965_dri.so
00007fc6021ee000     44K rw--- i965_dri.so
00007fc6021f9000    660K rw---   [ anon ]
00007fc60229e000      4K -----   [ anon ]
00007fc60229f000   8192K rw---   [ anon ]
00007fc602add000     64K rw-s- drm mm object (deleted)
00007fc602aed000     60K rw-s- drm mm object (deleted)
00007fc602afc000     60K rw-s- drm mm object (deleted)
00007fc602b4b000    256K rw-s- drm mm object (deleted)
00007fc602b8b000    512K rw-s-   [ shmid=0x90002 ]
00007fc602c0b000    524K rw---   [ anon ]
00007fc602c8e000     44K r-x-- libdrm_radeon.so.1.0.1
00007fc602c99000   2044K ----- libdrm_radeon.so.1.0.1
00007fc602e98000      4K r---- libdrm_radeon.so.1.0.1
00007fc602e99000      4K rw--- libdrm_radeon.so.1.0.1
00007fc602e9a000     28K r-x-- libdrm_nouveau.so.2.0.0
00007fc602ea1000   2044K ----- libdrm_nouveau.so.2.0.0
00007fc6030a0000      4K r---- libdrm_nouveau.so.2.0.0
00007fc6030a1000      4K rw--- libdrm_nouveau.so.2.0.0
00007fc6030a2000      4K rw-s- drm mm object (deleted)
00007fc6030a3000      4K rw-s- drm mm object (deleted)
00007fc6030a4000      4K rw-s- drm mm object (deleted)
00007fc6030a5000     12K rw-s- drm mm object (deleted)
00007fc6030a8000     12K rw-s- drm mm object (deleted)
00007fc6030bb000     16K rw-s- drm mm object (deleted)
00007fc6030bf000    136K r-x-- libdrm_intel.so.1.0.0
00007fc6030e1000   2048K ----- libdrm_intel.so.1.0.0
00007fc6032e1000      4K r---- libdrm_intel.so.1.0.0
00007fc6032e2000      4K rw--- libdrm_intel.so.1.0.0
00007fc6032e3000   1620K r-x-- intel_drv.so
00007fc603478000   2048K ----- intel_drv.so
00007fc603678000     20K r---- intel_drv.so
00007fc60367d000     16K rw--- intel_drv.so
00007fc603681000     20K r-x-- libXxf86vm.so.1.0.0
00007fc603686000   2044K ----- libXxf86vm.so.1.0.0
00007fc603885000      4K r---- libXxf86vm.so.1.0.0
00007fc603886000      4K rw--- libXxf86vm.so.1.0.0
00007fc603887000    132K r-x-- libxcb.so.1.1.0
00007fc6038a8000   2044K ----- libxcb.so.1.1.0
00007fc603aa7000      4K r---- libxcb.so.1.1.0
00007fc603aa8000      4K rw--- libxcb.so.1.1.0
00007fc603aa9000     16K r-x-- libxcb-dri2.so.0.0.0
00007fc603aad000   2044K ----- libxcb-dri2.so.0.0.0
00007fc603cac000      4K r---- libxcb-dri2.so.0.0.0
00007fc603cad000      4K rw--- libxcb-dri2.so.0.0.0
00007fc603cae000     92K r-x-- libxcb-glx.so.0.0.0
00007fc603cc5000   2044K ----- libxcb-glx.so.0.0.0
00007fc603ec4000      8K r---- libxcb-glx.so.0.0.0
00007fc603ec6000      4K rw--- libxcb-glx.so.0.0.0
00007fc603ec7000   1236K r-x-- libX11.so.6.3.0
00007fc603ffc000   2048K ----- libX11.so.6.3.0
00007fc6041fc000      4K r---- libX11.so.6.3.0
00007fc6041fd000     16K rw--- libX11.so.6.3.0
00007fc604201000      4K r-x-- libX11-xcb.so.1.0.0
00007fc604202000   2044K ----- libX11-xcb.so.1.0.0
00007fc604401000      4K r---- libX11-xcb.so.1.0.0
00007fc604402000      4K rw--- libX11-xcb.so.1.0.0
00007fc604403000     20K r-x-- libXfixes.so.3.1.0
00007fc604408000   2044K ----- libXfixes.so.3.1.0
00007fc604607000      4K r---- libXfixes.so.3.1.0
00007fc604608000      4K rw--- libXfixes.so.3.1.0
00007fc604609000      8K r-x-- libXdamage.so.1.1.0
00007fc60460b000   2044K ----- libXdamage.so.1.1.0
00007fc60480a000      4K r---- libXdamage.so.1.1.0
00007fc60480b000      4K rw--- libXdamage.so.1.1.0
00007fc60480c000     68K r-x-- libXext.so.6.4.0
00007fc60481d000   2044K ----- libXext.so.6.4.0
00007fc604a1c000      4K r---- libXext.so.6.4.0
00007fc604a1d000      4K rw--- libXext.so.6.4.0
00007fc604a1e000    176K r-x-- libglapi.so.0.0.0
00007fc604a4a000   2044K ----- libglapi.so.0.0.0
00007fc604c49000     16K r---- libglapi.so.0.0.0
00007fc604c4d000      4K rw--- libglapi.so.0.0.0
00007fc604c4e000      4K rw---   [ anon ]
00007fc604c4f000     20K r-x-- libxcb-sync.so.1.0.0
00007fc604c54000   2048K ----- libxcb-sync.so.1.0.0
00007fc604e54000      4K r---- libxcb-sync.so.1.0.0
00007fc604e55000      4K rw--- libxcb-sync.so.1.0.0
00007fc604e56000      8K r-x-- libxcb-present.so.0.0.0
00007fc604e58000   2044K ----- libxcb-present.so.0.0.0
00007fc605057000      4K r---- libxcb-present.so.0.0.0
00007fc605058000      4K rw--- libxcb-present.so.0.0.0
00007fc605059000      8K r-x-- libxcb-dri3.so.0.0.0
00007fc60505b000   2044K ----- libxcb-dri3.so.0.0.0
00007fc60525a000      4K r---- libxcb-dri3.so.0.0.0
00007fc60525b000      4K rw--- libxcb-dri3.so.0.0.0
00007fc60525c000    152K r-x-- libexpat.so.1.6.0
00007fc605282000   2048K ----- libexpat.so.1.6.0
00007fc605482000      8K r---- libexpat.so.1.6.0
00007fc605484000      4K rw--- libexpat.so.1.6.0
00007fc605485000    448K r-x-- libGL.so.1.2.0
00007fc6054f5000   2044K ----- libGL.so.1.2.0
00007fc6056f4000     12K r---- libGL.so.1.2.0
00007fc6056f7000      4K rw--- libGL.so.1.2.0
00007fc6056f8000      4K rw---   [ anon ]
00007fc6056f9000    264K r-x-- libglx.so
00007fc60573b000   2048K ----- libglx.so
00007fc60593b000      4K r---- libglx.so
00007fc60593c000     16K rw--- libglx.so
00007fc605940000     92K r-x-- libgcc_s.so.1
00007fc605957000   2044K ----- libgcc_s.so.1
00007fc605b56000      4K r---- libgcc_s.so.1
00007fc605b57000      4K rw--- libgcc_s.so.1
00007fc605b58000    144K r-x-- libpng12.so.0.54.0
00007fc605b7c000   2044K ----- libpng12.so.0.54.0
00007fc605d7b000      4K r---- libpng12.so.0.54.0
00007fc605d7c000      4K rw--- libpng12.so.0.54.0
00007fc605d7d000    132K r-x-- liblzma.so.5.0.0
00007fc605d9e000   2044K ----- liblzma.so.5.0.0
00007fc605f9d000      4K r---- liblzma.so.5.0.0
00007fc605f9e000      4K rw--- liblzma.so.5.0.0
00007fc605f9f000     24K r-x-- libfontenc.so.1.0.0
00007fc605fa5000   2044K ----- libfontenc.so.1.0.0
00007fc6061a4000      4K r---- libfontenc.so.1.0.0
00007fc6061a5000      4K rw--- libfontenc.so.1.0.0
00007fc6061a6000      4K rw---   [ anon ]
00007fc6061a7000     60K r-x-- libbz2.so.1.0.4
00007fc6061b6000   2044K ----- libbz2.so.1.0.4
00007fc6063b5000      4K r---- libbz2.so.1.0.4
00007fc6063b6000      4K rw--- libbz2.so.1.0.4
00007fc6063b7000    656K r-x-- libfreetype.so.6.12.1
00007fc60645b000   2044K ----- libfreetype.so.6.12.1
00007fc60665a000     24K r---- libfreetype.so.6.12.1
00007fc606660000      4K rw--- libfreetype.so.6.12.1
00007fc606661000    100K r-x-- libz.so.1.2.8
00007fc60667a000   2044K ----- libz.so.1.2.8
00007fc606879000      4K r---- libz.so.1.2.8
00007fc60687a000      4K rw--- libz.so.1.2.8
00007fc60687b000     72K r-x-- libgpg-error.so.0.17.0
00007fc60688d000   2048K ----- libgpg-error.so.0.17.0
00007fc606a8d000      4K r---- libgpg-error.so.0.17.0
00007fc606a8e000      4K rw--- libgpg-error.so.0.17.0
00007fc606a8f000    440K r-x-- libpcre.so.3.13.2
00007fc606afd000   2048K ----- libpcre.so.3.13.2
00007fc606cfd000      4K r---- libpcre.so.3.13.2
00007fc606cfe000      4K rw--- libpcre.so.3.13.2
00007fc606cff000     28K r-x-- librt-2.23.so
00007fc606d06000   2044K ----- librt-2.23.so
00007fc606f05000      4K r---- librt-2.23.so
00007fc606f06000      4K rw--- librt-2.23.so
00007fc606f07000     96K r-x-- libpthread-2.23.so
00007fc606f1f000   2044K ----- libpthread-2.23.so
00007fc60711e000      4K r---- libpthread-2.23.so
00007fc60711f000      4K rw--- libpthread-2.23.so
00007fc607120000     16K rw---   [ anon ]
00007fc607124000   1792K r-x-- libc-2.23.so
00007fc6072e4000   2048K ----- libc-2.23.so
00007fc6074e4000     16K r---- libc-2.23.so
00007fc6074e8000      8K rw--- libc-2.23.so
00007fc6074ea000     16K rw---   [ anon ]
00007fc6074ee000   1056K r-x-- libm-2.23.so
00007fc6075f6000   2044K ----- libm-2.23.so
00007fc6077f5000      4K r---- libm-2.23.so
00007fc6077f6000      4K rw--- libm-2.23.so
00007fc6077f7000    112K r-x-- libaudit.so.1.0.0
00007fc607813000   2044K ----- libaudit.so.1.0.0
00007fc607a12000      4K r---- libaudit.so.1.0.0
00007fc607a13000      4K rw--- libaudit.so.1.0.0
00007fc607a14000     40K rw---   [ anon ]
00007fc607a1e000     20K r-x-- libXdmcp.so.6.0.0
00007fc607a23000   2044K ----- libXdmcp.so.6.0.0
00007fc607c22000      4K r---- libXdmcp.so.6.0.0
00007fc607c23000      4K rw--- libXdmcp.so.6.0.0
00007fc607c24000      4K r-x-- libxshmfence.so.1.0.0
00007fc607c25000   2048K ----- libxshmfence.so.1.0.0
00007fc607e25000      4K r---- libxshmfence.so.1.0.0
00007fc607e26000      4K rw--- libxshmfence.so.1.0.0
00007fc607e27000      8K r-x-- libXau.so.6.0.0
00007fc607e29000   2048K ----- libXau.so.6.0.0
00007fc608029000      4K r---- libXau.so.6.0.0
00007fc60802a000      4K rw--- libXau.so.6.0.0
00007fc60802b000    184K r-x-- libXfont.so.1.4.1
00007fc608059000   2048K ----- libXfont.so.1.4.1
00007fc608259000      4K r---- libXfont.so.1.4.1
00007fc60825a000      8K rw--- libXfont.so.1.4.1
00007fc60825c000    636K r-x-- libpixman-1.so.0.33.6
00007fc6082fb000   2048K ----- libpixman-1.so.0.33.6
00007fc6084fb000     32K r---- libpixman-1.so.0.33.6
00007fc608503000      4K rw--- libpixman-1.so.0.33.6
00007fc608504000     64K r-x-- libdrm.so.2.4.0
00007fc608514000   2048K ----- libdrm.so.2.4.0
00007fc608714000      4K r---- libdrm.so.2.4.0
00007fc608715000      4K rw--- libdrm.so.2.4.0
00007fc608716000     32K r-x-- libpciaccess.so.0.11.1
00007fc60871e000   2048K ----- libpciaccess.so.0.11.1
00007fc60891e000      4K r---- libpciaccess.so.0.11.1
00007fc60891f000      4K rw--- libpciaccess.so.0.11.1
00007fc608920000     12K r-x-- libdl-2.23.so
00007fc608923000   2044K ----- libdl-2.23.so
00007fc608b22000      4K r---- libdl-2.23.so
00007fc608b23000      4K rw--- libdl-2.23.so
00007fc608b24000    860K r-x-- libgcrypt.so.20.0.5
00007fc608bfb000   2048K ----- libgcrypt.so.20.0.5
00007fc608dfb000      4K r---- libgcrypt.so.20.0.5
00007fc608dfc000     32K rw--- libgcrypt.so.20.0.5
00007fc608e04000      4K rw---   [ anon ]
00007fc608e05000    124K r-x-- libselinux.so.1
00007fc608e24000   2044K ----- libselinux.so.1
00007fc609023000      4K r---- libselinux.so.1
00007fc609024000      4K rw--- libselinux.so.1
00007fc609025000      8K rw---   [ anon ]
00007fc609027000    300K r-x-- libdbus-1.so.3.14.6
00007fc609072000   2044K ----- libdbus-1.so.3.14.6
00007fc609271000      4K r---- libdbus-1.so.3.14.6
00007fc609272000      4K rw--- libdbus-1.so.3.14.6
00007fc609273000    152K r-x-- ld-2.23.so
00007fc609299000      4K rw-s- drm mm object (deleted)
00007fc60929a000      8K rw-s- drm mm object (deleted)
00007fc60929c000      4K rw-s- drm mm object (deleted)
00007fc60929d000     16K rw-s- card0
00007fc6092a1000   1220K rw---   [ anon ]
00007fc6093d2000    512K r-x-- libsystemd.so.0.14.0
00007fc609452000     12K r---- libsystemd.so.0.14.0
00007fc609455000      4K rw--- libsystemd.so.0.14.0
00007fc609456000     16K rw---   [ anon ]
00007fc60945a000    120K r-x-- libudev.so.1.6.4
00007fc609478000      4K r---- libudev.so.1.6.4
00007fc609479000      4K rw--- libudev.so.1.6.4
00007fc60947a000      4K rw---   [ anon ]
00007fc60947b000      4K rw-s- drm mm object (deleted)
00007fc60947c000      4K rw-s- drm mm object (deleted)
00007fc60947d000      4K rw-s- drm mm object (deleted)
00007fc60947e000     36K rw-s- drm mm object (deleted)
00007fc609487000     64K rw-s- drm mm object (deleted)
00007fc609497000      4K rw-s- drm mm object (deleted)
00007fc609498000      4K r---- ld-2.23.so
00007fc609499000      4K rw--- ld-2.23.so
00007fc60949a000      4K rw---   [ anon ]
00007fff8a794000    132K rw---   [ stack ]
00007fff8a7f8000      8K r----   [ anon ]
00007fff8a7fa000      8K r-x--   [ anon ]
ffffffffff600000      4K r-x--   [ anon ]

```

## Zadanie 4
COMMAND - 9 pierwszych liter nazwy polecenia unixowego powiązanego z procesem
PID - pid
USER - użytkownik
FD - file descriptor
```
cwd current working directory;
Lnn library references (AIX);
err FD information error (see NAME column);
jld jail directory (FreeBSD);
ltx shared library text (code and data);
Mxx hex memory-mapped type number xx. m86 DOS Merge mapped file;
mem memory-mapped file; mmap memory-mapped device;
pd parent directory;
rtd root directory;
tr kernel trace file (OpenBSD);
txt program text (code and data);
v86 VP/ix mapped file;
```
TYPE - określa co jest powiązane z zasobem, np plik, gniazdo, folder
DEVICE - oddzielone przecinkami numery urządzeń właściwe dla zasobu
SIZE/OFF - rozmiar/offset. Cokolwiek jest właściwe dla danego zasobu
NODE - numer węzła (?) pliku
NAME - nazwa i ścieżka do pliku 

plik zwykły - standardowy plik unixowy
katalog - plik który zawiera odnośniki do innych plików
urządzenie - plik urządzenia - plik reprezentujący sterownik urządzenia, służy do uproszczenia komunikacji z urządzeniami
gniazdo - specjalny plik używany do komunikacji między procesami. Może wysyłać i przyjmować dane i deskryptory plików
potok - mechanizm umożliwiający wymianę danych między procesami. Łączy standardowe wejście jednego procesu ze standardowym wyjściem drugiego

### *nie wklejać*
DIR - folder
REG - regular file
CHR - character special file (dostęp do I/O) - urządzenie?
unix - gniazdo someny unixowej
a_inode - anonymous inode
FIFO - potok
netlink - gniazda netlink
sock - gniazdo 

## Zadanie 5
Real is wall clock time - time from start to finish of the call. This is all elapsed time including time slices used by other processes and time the process spends blocked (for example if it is waiting for I/O to complete).

User is the amount of CPU time spent in user-mode code (outside the kernel) within the process. This is only actual CPU time used in executing the process. Other processes and time the process spends blocked do not count towards this figure.

Sys is the amount of CPU time spent in the kernel within the process. This means executing CPU time spent in system calls within the kernel, as opposed to library code, which is still running in user-space. Like 'user', this is only CPU time used by the process. See below for a brief description of kernel mode (also known as 'supervisor' mode) and the system call mechanism.

User+Sys will tell you how much actual CPU time your process used. Note that this is across all CPUs, so if the process has multiple threads (and this process is running on a computer with more than one processor) it could potentially exceed the wall clock time reported by Real (which usually occurs).














