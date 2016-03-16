provider "aws" {
  access_key = "testacess"
  secret_key = "testsecret"
  region     = "us-west-test"
}

resource "aws_instance" "test.test.edu" {
  ami                         = ""
  associate_public_ip_address = true
  iam_instance_profile        = "webserver"
  instance_type               = "m4.large"
  subnet_id                   = ""
  vpc_security_group_ids      = [""]
  tags {
    Name = "test.test.edu"
    "Product Name" = ""
  }
}

resource "aws_route53_record" "test.test.edu-dns" {
  zone_id = ""
  name    = "sub.domain.com"
  type    = "A"
  ttl     = "60"
  records = [ "${aws_instance.test.test.edu.public_ip}" ]
}
