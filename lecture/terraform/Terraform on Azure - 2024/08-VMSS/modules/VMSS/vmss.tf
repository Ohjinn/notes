resource "azurerm_virtual_machine_scale_set" "user01vmss" {
    name = "${var.prefix}-1vmss"
    location              = "${var.region}"
    resource_group_name   = "${var.prefix}-RG"
    upgrade_policy_mode = "Manual"


sku {
    name = "Standard_D2_v3"
    tier = "Standard"
    capacity = 2
}
storage_profile_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
}

storage_profile_os_disk {
    name = ""
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
}
storage_profile_data_disk {
    lun = 0
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 10
}
os_profile {
    computer_name_prefix = "${var.prefix}-vmss-vm"
    admin_username = "azureuser"    ## 아래 33번 라인의 계정이름과 동일해야 함
    admin_password = "${var.password}"     ## 12자리이상, 특수문자, 숫자, 대문자 조합으로 생성 필요
    custom_data= file("web1.sh")     ## Terraform 실행하는 서버에 존재해야 함, 실행은 만들어지는 VM에서
}

#서버 80포트 접속안되시는 분들은 실제 서버 접속하셔서 아파치 데몬이 정상 동작하는지
#확인해 보시면됩니다. 아래는 접속 방법이에요.  
#LB 인바운드 NAT 규칙에 설정된 것처럼 공인IP 50001 번 포트로 접속을 해서 실제서버
#22번 포트에 접속하는 NAT 구조입니다. why? 실제 서버는 공인 IP없이 동작하기때문에
#외부에서 접속하려면 공인IP를 가진 LB가 접속을 도와주어야 하는거죠. 
#아래 104.40.10.17은 예를 든 IP
#계정은 위와 같이 설정하셨으면 azureuser 이 되겠죠?

#ssh -i ~/.ssh/id_rsa 계정@104.40.10.17 -p 50001  (첫번째 서버 접속)
#ssh -i ~/.ssh/id_rsa 계정@104.40.10.17 -p 50003  (두번째 서버 접속)

os_profile_linux_config {
disable_password_authentication = true
ssh_keys {
    path = "/home/azureuser/.ssh/authorized_keys"   ## VMSS 로 생성되는 VM에서 생성되는 계정 .ssh/ 폴더에  id_rsa.pub 파일이 authorized_keys 파일로 복사됨 
    key_data = file("./id_rsa.pub")  ## Public Key는 VMSS 실행 전에 미리 터미널에서 ssh-keygen 으로 생성 (엔터 3번) 
    }
}
    


network_profile {
        name = "${var.prefix}-terraformnetworkprofile"
        primary = true
        ip_configuration {
        name = "${var.prefix}-TestIPConfiguration"
        primary = true
        subnet_id = azurerm_subnet.subnet1.id
        load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bep.id]
        load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.lbnatpool.id]
    }
        network_security_group_id = azurerm_network_security_group.this.id
}
tags = {
    environment = "staging"
    }
}


