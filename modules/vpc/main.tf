terraform {
    required_version = ">= 0.11.7"
}

/**
 * The VPC.
 * Three subnets (one public, two private) will be created in each specified availability
 * zone. This will be done in the following way:
 * - Let n be the number of availability zones. The number of subnets is then:
 *   n * 3
 * - For simplicity, the CIDR block is divided into equal subdivisions:
 *   log((n * 3), 2)
 * - As it is possible to specify any number of AZs, round up:
 *   ceil(log((n * 3), 2))
 */
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"

    tags {
        Name = "vpc-${var.namespace}"
    }
}

/**
 * Web layer public subnets. One subnet will be created in each specified
 * availability zone.
 */
resource "aws_subnet" "web" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr, ceil(log(length(var.availability_zones) * 3, 2)), count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "web-${element(var.availability_zones, count.index)}"
    }
}

/**
 * App layer private subnets. One subnet will be created in each specified
 * availability zone.
 */
resource "aws_subnet" "app" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr, ceil(log(length(var.availability_zones) * 3, 2)), length(var.availability_zones) + count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "app-${element(var.availability_zones, count.index)}"
    }
}

/**
 * Data layer private subnets. One subnet will be created in each specified
 * availability zone.
 */
resource "aws_subnet" "data" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.main.id}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr, ceil(log(length(var.availability_zones) * 3, 2)), (length(var.availability_zones) * 2) + count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "data-${element(var.availability_zones, count.index)}"
    }
}

/**
 * Web-layer routing components. In order to allow the web subnets to be truly public,
 * the following resources must be deployed:
 * - Internet Gateway
 * - Route Table
 * - Route
 * - Route Table Association
 * - Network ACL
 */
resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "igw-${var.namespace}"
    }
}

resource "aws_route_table" "web" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "web-${var.namespace}"
    }
}

resource "aws_route" "web" {
    route_table_id         = "${aws_route_table.web.id}"
    gateway_id             = "${aws_internet_gateway.main.id}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "web" {
    count = "${length(var.availability_zones)}"

    subnet_id      = "${element(aws_subnet.web.*.id, count.index)}"
    route_table_id = "${aws_route_table.web.id}"
}

resource "aws_network_acl" "web" {
    vpc_id     = "${aws_vpc.main.id}"
    subnet_ids = ["${aws_subnet.web.*.id}"]

    egress {
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
    }

    ingress {
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
    }

    tags {
        Name = "web-${var.namespace}"
    }
}


/**
 * App-layer routing components. App subnets are private, but should be allowed to
 * egress to the internet. Ingress should be limited to requests originating from within
 * the web layer. The following resources must be deployed:
 * - NAT Gateway
 * - NAT Elastic IP Address
 * - Route Table
 * - Route
 * - Route Table Association
 * - Network ACL
 */
resource "aws_eip" "nat" {
    count = "${length(var.availability_zones)}"

    vpc = true

    tags {
        Name = "nat-${var.namespace}"
    }
}

resource "aws_nat_gateway" "main" {
    count = "${length(var.availability_zones)}"

    allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
    subnet_id     = "${element(aws_subnet.web.*.id, count.index)}"

    tags {
        Name = "nat-${element(var.availability_zones, count.index)}"
    }
}

resource "aws_route_table" "app" {
    count = "${length(var.availability_zones)}"

    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "app-${var.namespace}"
    }
}

resource "aws_route" "app" {
    count = "${length(var.availability_zones)}"

    route_table_id         = "${element(aws_route_table.app.*.id, count.index)}"
    nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "app" {
    count = "${length(var.availability_zones)}"

    subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.app.*.id, count.index)}"
}

resource "aws_network_acl" "app" {
    vpc_id     = "${aws_vpc.main.id}"
    subnet_ids = ["${aws_subnet.app.*.id}"]

    egress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        cidr_block = "0.0.0.0/0"
    }

    ingress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        cidr_block = "${element(aws_subnet.web.*.cidr_block, count.index)}"
    }

    tags {
        Name = "app-${var.namespace}"
    }
}

/**
 * Data-layer routing components. Data subnets are private and must only allow access to the
 * underlying database from traffic originating within the app layer. The following resources
 * must be deployed:
 * - Route Table Association
 * - Network ACL
 */
resource "aws_route_table_association" "data" {
    count = "${length(var.availability_zones)}"

    subnet_id      = "${element(aws_subnet.data.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.app.*.id, count.index)}"
}

resource "aws_network_acl" "data" {
    vpc_id     = "${aws_vpc.main.id}"
    subnet_ids = ["${aws_subnet.data.*.id}"]

    egress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        cidr_block = "0.0.0.0/0"
    }

    ingress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        from_port  = 0
        to_port    = 0
        cidr_block = "${element(aws_subnet.app.*.cidr_block, count.index)}"
    }

    tags {
        Name = "data-${var.namespace}"
    }
}