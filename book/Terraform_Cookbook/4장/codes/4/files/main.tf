resource "local_file" "myfile" {
  content  = "This is my text"
  filename = "../mytextfile.txt"
}

resource "null_resource" "readcontentfile" {
  provisioner "local-exec" {
    command = "cat ../mytextfile.txt"
    interpreter = ["/bin/bash", "-c"]
  }
}