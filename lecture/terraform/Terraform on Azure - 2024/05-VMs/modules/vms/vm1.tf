resource "azurerm_virtual_machine" "web1" {
    name                  = "${var.prefix}-web1"
    location              = "${var.region}"
    resource_group_name   = "${var.prefix}-RG"
    availability_set_id   = azurerm_availability_set.this.id
    delete_os_disk_on_termination    = true
    network_interface_ids = [azurerm_network_interface.nic1.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

 os_profile {
        computer_name  = "${var.prefix}-web1"
        admin_username = "azureuser"    ## 아래 33번 라인의 계정이름과 동일해야 함
        admin_password = "${var.password}"     ## 12자리이상, 특수문자, 숫자, 대문자 조합으로 생성 필요
        custom_data= file("web1.sh")     ## Terraform 실행하는 서버에 존재해야 함, 실행은 만들어지는 VM에서
    }

 os_profile_linux_config {
        disable_password_authentication = false
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = file("~/.ssh/id_rsa.pub")
        }
    }
    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.this.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}
