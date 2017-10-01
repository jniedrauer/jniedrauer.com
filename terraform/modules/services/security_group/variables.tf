variable "name" { type = "string" }
variable "description" { type = "string" }
variable "vpc" { type = "string" }
variable "ssh" { default = false }
variable "ports" { default = [] }
