# Sieci warsztaty 3
###### tags: `SK`

## Przed zajęciami
V1:
sudo ip link set enp0s3 name enp-rem1
sudo ip link set enp0s8 name enp-rem4

V2:
sudo ip link set enp0s3 name enp-rem1
sudo ip link set enp0s8 name enp-rem2

V3:
sudo ip link set enp0s3 name enp-rem2
sudo ip link set enp0s8 name enp-rem3

V4:
sudo ip link set enp0s3 name enp-rem3
sudo ip link set enp0s8 name enp-rem4


V1:
sudo ip link set up dev enp-rem1
sudo ip addr add 192.168.1.1/24 dev enp-rem1

V2:
sudo ip link set up dev enp-rem1
sudo ip addr add 192.168.1.2/24 dev enp-rem1
sudo ip link set up dev enp-rem2
sudo ip addr add 192.168.2.2/24 dev enp-rem2

V3:
sudo ip link set up dev enp-rem2
sudo ip addr add 192.168.2.3/24 dev enp-rem2
sudo ip link set up dev enp-rem3
sudo ip addr add 192.168.3.3/24 dev enp-rem3

V4:
sudo ip link set up dev enp-rem3
sudo ip addr add 192.168.3.4/24 dev enp-rem3

Wireshark

V1:
sudo ip route add default via 192.168.1.2
ping -c 4 192.168.1.2
ping -c 4 192.168.2.2

V4: 
sudo ip route add default via 192.168.3.3
ping -c 4 192.168.3.3
ping -c 4 192.168.2.3

V2:
ping -c 4 192.168.2.3

V1:
ping -c 4 192.168.2.3

## Tutorial 1
V2:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd

sudo vtysh

show interface
show ip route

configure terminal
router rip
version 2
network 192.168.1.0/24
network 192.168.2.0/24

exit
exit

show running-config

V3:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd

sudo vtysh

show interface
show ip route

configure terminal
router rip
version 2
network 192.168.2.0/24
network 192.168.3.0/24

exit
exit

show running-config

V2 i V3: show ip rip

Jakieś pingi i tracerouty

## Tutorial 2
V1:
sudo ip link set up dev enp-rem4
sudo ip addr add 192.168.4.1/24 dev enp-rem4

V4: 
sudo ip link set up dev enp-rem4
sudo ip addr add 192.168.4.4/24 dev enp-rem4

V1 i V4: 
sudo ip route del default

V1:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd

sudo vtysh

show interface
show ip route

configure terminal

router rip
version 2
network 192.168.1.0/24
network 192.168.4.0/24

exit
exit

show running-config
show ip rip


V4:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd

sudo vtysh

show interface
show ip route

configure terminal
router rip
version 2
network 192.168.3.0/24
network 192.168.4.0/24

exit
exit

show running-config
show ip rip


Pingi i tracerouty

V2: sudo ip link set down dev enp-rem2

## Wyzwanie
V1:
sudo ip link set enp0s3 name enp-loc0
sudo ip link set up dev enp-loc0
sudo ip addr add 192.168.0.1/24 dev enp-loc0

V2:
sudo ip link set enp0s3 name enp-loc0
sudo ip link set up dev enp-loc0
sudo ip addr add 192.168.0.2/24 dev enp-loc0

sudo ip link set enp0s8 name enp-loc1
sudo ip link set up dev enp-loc1
sudo ip addr add 192.168.1.2/24 dev enp-loc1

sudo ip link set enp0s9 name enp-loc2
sudo ip link set up dev enp-loc2
sudo ip addr add 192.168.2.2/24 dev enp-loc2

V3: 
sudo ip link set enp0s3 name enp-loc1
sudo ip link set up dev enp-loc1
sudo ip addr add 192.168.1.3/24 dev enp-loc1

sudo ip link set enp0s8 name enp-loc3
sudo ip link set up dev enp-loc3
sudo ip addr add 192.168.3.3/24 dev enp-loc3

V4:
sudo ip link set enp0s3 name enp-loc2
sudo ip link set up dev enp-loc2
sudo ip addr add 192.168.2.4/24 dev enp-loc2

sudo ip link set enp0s8 name enp-loc3
sudo ip link set up dev enp-loc3
sudo ip addr add 192.168.3.4/24 dev enp-loc3

sudo ip link set enp0s9 name enp-loc4
sudo ip link set up dev enp-loc4
sudo ip addr add 192.168.4.4/24 dev enp-loc4

V5:
sudo ip link set enp0s3 name enp-loc4
sudo ip link set up dev enp-loc4
sudo ip addr add 192.168.4.5/24 dev enp-loc4

V1:
sudo ip route add default via 192.168.0.2

V5:
sudo ip route add default via 192.168.4.4

V2:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd
sudo vtysh

configure terminal

router rip
version 2
network 192.168.0.0/24
network 192.168.1.0/24
network 192.168.2.0/24

exit
exit

show running-config
show ip rip

V3:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd
sudo vtysh

configure terminal

router rip
version 2
network 192.168.1.0/24
network 192.168.3.0/24

exit
exit

show running-config
show ip rip

V4:
sudo touch /etc/quagga/ripd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ripd
sudo vtysh

configure terminal

router rip
version 2
network 192.168.2.0/24
network 192.168.3.0/24
network 192.168.4.0/24

exit
exit

show running-config
show ip rip


