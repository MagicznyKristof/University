# Sieci warsztaty 2
###### tags: `SK`

V0: sudo ip link set enp0s3 name enp-ext
V0: sudo ip link set enp0s8 name enp-loc0

V1: sudo ip link set enp0s3 name enp-loc0
V1: sudo ip link set enp0s8 name enp-loc1

V2: sudo ip link set enp0s3 name enp-loc1

V0: sudo dhclient -v enp-ext
V0: sudo ip link set up dev enp-loc0
V0: sudo ip addr add 192.168.0.1/24 dev enp-loc0

V1: sudo ip link set up dev enp-loc0
V1: sudo ip addr add 192.168.0.2/24 dev enp-loc0
V1: sudo ip link set up dev enp-loc1
V1: sudo ip addr add 192.168.1.1/24 dev enp-loc1

V2: sudo ip link set up dev enp-loc1
V2: sudo ip addr add 192.168.1.2/24 dev enp-loc1

V0: sudo ip route add 192.168.1.0/24 via 192.168.0.2
V1: sudo ip route add default via 192.168.0.1
V2: sudo ip route add default via 192.168.1.1

jakieś pingi

V2: traceroute 192.168.0.1

V0: ping -c 4 8.8.8.8

V2: ping -c 4 8.8.8.8 (obejrzeć w wiresharku)

Nie dochodzi, ponieważ adresat pinga nie wie kto go pinguje (V2 jest "schowany"). Żeby ping dochodził, należałoby poinformować chociaż sąsiada do którego V0 ext wysyła informacje

sudo ip addr flush dev enp-
sudo ip link set down dev enp-

