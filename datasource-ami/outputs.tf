output "latest_ubuntu_ami-id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_ami-name" {
  value = data.aws_ami.latest_ubuntu.name
}
output "latest_amazon-linux_ami-id" {
  value = data.aws_ami.latest_amazon-linux.id
}
output "latest_amazon-linux-name" {
  value = data.aws_ami.latest_amazon-linux.name
}
output "latest_windows_ami-id" {
  value = data.aws_ami.latest_windows.id
}
output "latest_windows-name" {
  value = data.aws_ami.latest_windows.name
}
