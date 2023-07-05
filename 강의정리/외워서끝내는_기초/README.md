
Network: 관계
Networking: 상호작용


식별자

L2 -> MAC 주소: NIC(Network Interface Card)를 식별하는 식별자
L3 -> IP 주소: Internet을 사용하는 host의 식별자
L4 -> PORT 번호: process

Host


End-point
client, Server, Peer -> 이용주체

Switch
Router, IPS, Tab -> 네트워크 자체를 이루는 요소


Switch가 하는 일
Network가 도로망이라고 친다면 각각의 교차로에서 패킷은 경로를 정해야 하는데 그게 이정표, Switching
만약 이 때 IP 주소를 근거로 스위칭 했다면 L3 스위칭

L3 스위치는 인터넷에서 라우터라고 부르고 라우터는 라우팅 테이블이라는 이정표를 가지고 있다.

그게 Matric. 실제로 route PRINT 명령을 쓰면 해당 컴퓨터 라우터의 매트릭, 각 루트별 비용 값을 볼 수 있다.


LAN(Locl Area Network) card보다는 NIC(Network Interface Card)라고 불리는게 정확한데 유무선을 굳이 분리해서 이야기하지는 않는다. 
각 NIC 카드는 MAC 주소를 갖는다

규모는 WAN -> MAN -> LAN 순으로 작아진다.

Packet은 L3 수준에서의 단위
Frame은 L2 수준에서의 단위

L2 Access switch

End-point와 직접 연결되는 스위치로 MAC 주소를 근거로 스위칭

PC와 L2 Access와의 연결에서 연결이 올바르면 Link-up, 올바르지 않으면 Link-down이라 표현, switch와 router가 연결되어 있는 선은 uplink라고 부름

L2 Distribution switch: L2 Access 스위치를 위한 스위치로 VLAN(Virtual LAN) 기능을 제공하는 것이 일반적이다. L2 Access 스위치가 각 방에 존재한다면 L2 Distribution switch는 한 층을 담당한다.

LAN과 WAN의 경계 그리고 Broadcast

Broadcast <=> Unicast

Braodcast는 효율과는 상관 없다. 다만 속도를 위해서는 Broadcast의 범위를 최소화해야한다.

NIC는 MAC address를 갖는데 이는 48비트 주소로
FF-FF-FF-FF-FF-FF의 16진수 주소다.

위의 예는 1111-1111-1111-1111-1111-1111의 2진수 주소로 변환될 수 있는데 송신자가 수신자를 다음과 같이 설정하면
모두가 메시지를 받으라는 뜻이고 Braodcast라고 불린다.


IPv4 주소의 구조
IPv4는 32bit 주소체계를 사용 8bit * 4 -> 

192.168.0.10이라고 치면

앞의 세 개는 NetworkID, 뒤의 하나는 HostID로 구성되어 있다.

L3 Packet

Packt이라는 말은 L3 IP Packet으로 Header와 Payload로 나뉘며 최대 크기는 MTU다(Maximum Transmition Unit) default는 1500 byte. 

Encapsulation, Decapsulation