resource "azurerm_virtual_machine" "dp-vm" {
    name                  = "${var.prefix}-dp-vm"
    location              = "${var.region}"
    resource_group_name   = "${var.prefix}-RG"
    availability_set_id   = azurerm_availability_set.this.id
    delete_os_disk_on_termination    = true
    network_interface_ids = [azurerm_network_interface.nic2.id]
    vm_size               = "Standard_DS2_v2"

    storage_os_disk {
        name              = "myOsDisk2"
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
        computer_name  = "${var.prefix}-dp-vm"
        admin_username = "azureuser"    ## 아래 33번 라인의 계정이름과 동일해야 함
        admin_password = "${var.password}"     ## 12자리이상, 특수문자, 숫자, 대문자 조합으로 생성 필요
        custom_data= file("k8s_install.sh")     ## Terraform 실행하는 서버에 존재해야 함, 실행은 만들어지는 VM에서
    }

 os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = file("./id_rsa.pub")
        }
 
 #       ssh_keys {
 #           path     = "/home/azureuser/.ssh/authorized_keys"
 #           key_data = azurerm_ssh_public_key.this.ssh_public_key
 #   }
 }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.this.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}
