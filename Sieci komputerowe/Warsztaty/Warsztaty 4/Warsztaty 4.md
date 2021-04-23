# Sieci warsztaty 4
###### tags: `SK`

## Przed zajęciami
V1:
sudo ip link set enp0s3 name enp-rem1
sudo ip link set enp0s8 name enp-rem4
sudo ip link set enp0s9 name enp-all
sudo ip link set up dev enp-rem1
sudo ip addr add 192.168.1.1/24 dev enp-rem1
sudo ip link set up dev enp-rem4
sudo ip addr add 192.168.4.1/24 dev enp-rem4
ip route
ping -c 1 192.168.1.2
ping -c 1 192.168.4.4

V2:
sudo ip link set enp0s3 name enp-rem1
sudo ip link set enp0s8 name enp-rem2
sudo ip link set enp0s9 name enp-all
sudo ip link set up dev enp-rem1
sudo ip addr add 192.168.1.2/24 dev enp-rem1
sudo ip link set up dev enp-rem2
sudo ip addr add 192.168.2.2/24 dev enp-rem2
ip route
ping -c 1 192.168.1.1
ping -c 1 192.168.2.3

V3:
sudo ip link set enp0s3 name enp-rem2
sudo ip link set enp0s8 name enp-rem3
sudo ip link set enp0s9 name enp-all
sudo ip link set up dev enp-rem2
sudo ip addr add 192.168.2.3/24 dev enp-rem2
sudo ip link set up dev enp-rem3
sudo ip addr add 192.168.3.3/24 dev enp-rem3
ip route
ping -c 1 192.168.2.2
ping -c 1 192.168.3.4

V4:
sudo ip link set enp0s3 name enp-rem3
sudo ip link set enp0s8 name enp-rem4
sudo ip link set enp0s9 name enp-all
sudo ip link set up dev enp-rem3
sudo ip addr add 192.168.3.4/24 dev enp-rem3
sudo ip link set up dev enp-rem4
sudo ip addr add 192.168.4.4/24 dev enp-rem4
ip route
ping -c 1 192.168.3.3
ping -c 1 192.168.4.1

## Tutorial 1
Uruchomić wiresharka

V1:
sudo ip route add default via 192.168.1.2
ip route

V2:
sudo ip route add default via 192.168.2.3
ip route

V3:
sudo ip route add default via 192.168.3.4
ip route

V4:
sudo ip route add default via 192.168.4.1
ip route

V1:
ping -c 4 192.168.3.3
ping -c 4 192.168.3.4

traceroute 192.168.3.3
traceroute 192.168.3.4

V1-4:
sudo ip route delete default

## Tutorial 2

V1-4:
sudo touch /etc/quagga/ospfd.conf
sudo touch /etc/quagga/zebra.conf
sudo touch /etc/quagga/vtysh.conf
sudo systemctl start ospfd

sudo vtysh
show ip route

V1:
configure terminal
router ospf
network 192.168.1.0/24 area 0
network 192.168.4.0/24 area 0

V2:
configure terminal
router ospf
network 192.168.1.0/24 area 0
network 192.168.2.0/24 area 0

V3:
configure terminal
router ospf
network 192.168.2.0/24 area 0
network 192.168.3.0/24 area 0

V4:
configure terminal
router ospf
network 192.168.3.0/24 area 0
network 192.168.4.0/24 area 0

V1-4:
end
show running-config

OSFP nie używa warstwy transportowej (po czym to poznać?)

pingi i tracerouty

V1:
sudo ip link set up dev enp-all
sudo ip addr add 172.16.16.1/16 dev enp-all

V2:
sudo ip link set up dev enp-all
sudo ip addr add 172.16.16.2/16 dev enp-all

V3:
sudo ip link set up dev enp-all
sudo ip addr add 172.16.16.3/16 dev enp-all

V4:
sudo ip link set up dev enp-all
sudo ip addr add 172.16.16.4/16 dev enp-all

V1-4:
sudo vtysh
configure terminal
router ospf
network 172.16.0.0/16 area 0


V1-4:
sudo systemctl stop ospfd


## Wyzwanie

V1:
sudo ip link set enp0s3 name enp0
sudo ip link set up dev enp0
sudo ip addr add 192.168.1.1/24 dev enp0
sudo ip route add default via 192.168.1.2


V2:
sudo ip link set enp0s3 name enp0
sudo ip link set up dev enp0
sudo ip addr add 192.168.1.2/24 dev enp0
sudo ip route add default via 192.168.1.3

V3:
sudo ip link set enp0s3 name enp0
sudo ip link set enp0s8 name enp1
sudo ip link set up dev enp0
sudo ip addr add 192.168.1.3/24 dev enp0
sudo ip link set up dev enp1
sudo ip addr add 192.168.2.1/24 dev enp1

V4:
sudo ip link set enp0s3 name enp1
sudo ip link set up dev enp1
sudo ip addr add 192.168.2.2/24 dev enp1
sudo ip route add default via 192.168.2.1

V1:
ping -c 4 192.168.2.2

> Jaka jest sugerowana przez maszynę Virbian2 modyfikacja tablicy routingu na maszynie Virbian1 ?

Zmiana defaulta na 1.3

> Dlaczego taka zmiana ma sens?

Wszystkie maszyny są w tej samej sieci i połączone ze sobą bezpośrednio a tylko w V3 jest inna sieć

> W jaki sposób maszyna Virbian2 mogła wykryć powyższy problem?

Zauważyła, że otrzymała pakiet i wysłała go w tej samej "chmurze"

