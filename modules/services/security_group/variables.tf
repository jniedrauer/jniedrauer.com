variable "name" { type = "string" }
variable "description" { type = "string" }
variable "vpc" { type = "string" }
variable "config" { type = "map" }
variable "ports" { type = "map" }
variable "ssh_cidrs" { type = "list" }
