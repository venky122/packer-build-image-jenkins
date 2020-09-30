 resource "aws_instance" "mytest-server-1" {
     ami = "${data.aws_ami.my_ami.id}"
    #ami = "${var.amis}" 
    availability_zone = "${var.azs}"
    instance_type = "t2.micro"
    key_name = "venkat"
    subnet_id = "${aws_subnet.subnet1-public.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    tags = {
        Name = "${var.instance_name}-server"
        
    }
}