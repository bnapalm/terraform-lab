output "public-subnet-ids" {
  value = aws_subnet.main-public.*.id
}
