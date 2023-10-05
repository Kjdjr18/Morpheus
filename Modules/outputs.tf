#Outputs  have to change the ip decimal to a dash -
output "ec2-public-ip" {
  value       = "ssh -i 'metsilabs_us-east-1_nvirginia.pem' ec2-user@ec2-${replace(aws_instance.instance.public_ip, ".", "-")}.compute-1.amazonaws.com"
  description = "this will print out the ssh command at the bottom of the terminal when you apply. Just change the decimals in the IP address to dashes and copy paste in terminal to ssh."
}

output "link" {
  value = "https://ec2-${replace(aws_instance.instance.public_ip, ".", "-")}.compute-1.amazonaws.com"
}
