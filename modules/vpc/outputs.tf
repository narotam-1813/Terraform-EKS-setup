output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = [for az, subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_id" {
  value = [for az, subnet in aws_subnet.private_subnets : subnet.id]
}