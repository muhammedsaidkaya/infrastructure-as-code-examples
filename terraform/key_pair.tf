resource "aws_key_pair" "key_pair" {
    key_name = "packer-test-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}