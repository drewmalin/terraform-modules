terraform {
    required_version = ">= 0.11.7"
}

resource "aws_dynamodb_table" "main" {
    name           = "${var.namespace}-table"
    read_capacity  = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"

    hash_key  = "${var.hash_key}"
    range_key = "${var.range_key}"

    attribute              = ["${local.attributes}"]
    global_secondary_index = ["${var.gloabl_secondary_index}"]
    local_secondary_index  = ["${var.local_secondary_index}"]
}
