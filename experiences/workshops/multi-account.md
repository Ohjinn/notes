# multi account

hjin9445@gmail.com이라는 AWS 계정을 만드는 것은 실제 계정이 아닌 접속 ID일 뿐이다. 실제 ID는 12자리 숫자로 생성된다.

하나의 계정이 생성되면 root, payer, billing 등이 생성된다.

이렇게 되면 기업에서 AWS를 사용하면 계산을 어떻게 할 것인가? 그래서 나온게 multi account strategy planning이다.

돈을 지불하는 계정을 하나 만들고 컨트롤 타워를 만든다. 여기서 계정을 만들어 뿌리면 우리가 현재 사용하고 있는 형태가 된다.


랜딩존을 만들면 Audit, Log Archive 등의 계정들이 생기게 된다. 각각의 사용자는 member account라고 불린다.

OU(Organization Unit): 여러 계정을 묶어서 만드는 계정 그룹

SSO(Single Sign On): 임시 출입증


