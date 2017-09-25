variable "ami" { type = "string" }
variable "number" { type = "string" }
variable "type" { type = "string" }
variable "security_group" { type = "string" }
variable "subnets" { type = "list" }
variable "group" { type = "string" }
variable "users" {
    default = [
        {
            name = "jniedrauer"
            pubkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6f1ZqTK05R4lgpwt2onWEJnGa2kISsGxIbdy2fCbK4w0llerFzLzkiTdcmGS2OppC+i93IAEeah62MHy1whHk5odDqsB7jN5UBMbKo1NYZ/s//PpJIzoZ34eayrH50Is+uiFbYJg0fQNhGw9SM/wEZyItT4fV5zwxe076GyhkbNB9GSlonQEBSRSMZXvLLdLVkHBZiZqx3FQ+N7QIhMN5C2iyv1ZJXkuBaUE+KrQCNNFeeaPpZooeNfvyTHVhDBoqn51K2iaPVODf/hoOiO0reAr7NphslT58nZHsiVJWZTz0AdYXwhIgAJvmlHbz7HiZCx+4nSwrqbq4kRgmiuivJzqcyRrleDdBk34ua8EI2BrkcaF/sxarKJ+o6LhzG6ix/mUEibDRoCVi3brN9YQcG6fWebre8Tk5DcYavqJJcRmB0irl5x9Ng3kbZVkc8g8opE0DCqlcBadfyr7MLbofKqjgyDv3OvRy47tv13D/9ndeFUFebtNhhWad/aiPDG6F/Y/tjtZHNqyOuLDienZpjMi3fGmpbziKzQngfs+VanW4sSUm8GBEP9NlTYbcDIyn84tx7/rGCcJvovczABYuuEsqD1DApfvoipLXwsBRS+duT9kJXed1/LOJMOxSxtjhJxHcTVMaP1RCiZL9lA04lcXeYoaDF/PznmmBMU8OFQ== jniedrauer@lappy,ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvwpXnf+xD8vz+BfkVQ5qql7BnXL0mViM7eWMI4X8PsWhuGTCRsQXlkQcM84XBZT8z6EoAEUzqE89awpdz8giWoBsLIZuNHPX1kAjV3s03HpskbBU6RS5NK6Spe7gF1MjbLjwukTJR6JJU70QdrWiwXL7VQiakALcogSWHJ/s8Ja0KOeUiDlKAp2bltgUEJ+NWm32hz2H5LHKOH6JgvkEUly/J6hXuKRodbCyT2B4Y4gJ2nhamOk1f3QDk8mZg3xEukSfTYfMqRWLs20AepplKRhnSb4EOaH83IRk1uLKfxPoBNv9Yypor1IQfIzSU5iHLP49FR7v1FBtQa0LA8hMv2R1A5105iMpvIg0VyhPDZ9418TsbqZMTZwdnxBvwFnFMYzoKPMdU8MIII7+NZ6bQkFjgzRsIqy9Wyqq+RTw6HUwFqFwxpT/RfjibhMg/x+xCRPj6hdfFCm0bME31aFmcwBRnQa6Hiuwp4JIr1AzX4qNujjxUbK47JgtVqmPhlmGgOlO1Fc/eGPYy+VwrmMFfQgEJGlfwoHmeI8zzgjDLggnNAJXK4/DCGbJ7OBz0VdYbmpSMSsIf6l5MxXTKAUk6mHwS7gdxxM5JYasQm1x/3JKZZ2p+IfYS/Mka9NgRkMQP2ykBkGsujW/Ny+4pisIAmgV9VzfKdQukRsXNueFwSQ== jniedrauer@homeserver"
        }
    ]
}
