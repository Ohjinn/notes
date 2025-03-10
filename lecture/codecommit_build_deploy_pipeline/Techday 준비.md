Spring boot web module만 넣었다.
여기선 2.1.4썼다.

1. git repo 만들고 견본으로 만든 hello controller push


aws code commit은 deprecated되었기 때문에 다른 CI툴 필요.

회사에서 사용하는 gitlab을 사용하려 했으나, 무료버전에선 token 발급이 제한되는 이슈로 github - github webhook - aws api gateway - aws lambda - aws sns - email 발송 순으로 제작 가능