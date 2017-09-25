resource "aws_key_pair" "ssh_keypairs" {
    key_name = "${var.users[count.index]}"
    public_key = "${lookup(var.publickeys, var.users[count.index]
}
