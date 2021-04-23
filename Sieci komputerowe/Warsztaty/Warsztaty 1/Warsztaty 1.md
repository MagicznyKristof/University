# Sieci warsztaty 1

###### tags: `SK`

## Wyzwanie 1

### Punkt 2
Vi: ip link
Vi: ip addr
Vi: ethtool enp0s8 <- może się zmienić

### Punkt 3
V1: sudo ip link set up dev enp0s8
V1: sudo ip addr add 192.168.100.1/24 dev enp0s8
V2: sudo ip link set up dev enp0s8
V2: sudo ip addr add 192.168.100.2/24 dev enp0s8

### Punkt 4
V1: ping -c 8 192.168.100.2
V2: ping -c 8 192.168.100.1
Wireshark -> any
![](https://i.imgur.com/BkPZEyl.png)

### Punkt 5
V2: iperf3 -s
V1: iperf3 -c 192.168.100.2

### Punkt 6
Vi: netstat -l46
Vi: netstat -l46n

V1: telnet 192.168.100.2 7 <- echo z tego wyżej
V2: telnet 192.168.100.1 7 <- echo z tego wyżej

CTRL ]
quit

### Punkt 7
Vi: sudo ip addr flush dev enp0s8
Vi: sudo ip link set down dev enp0s8
