variable "vpc" {
  type = string
  default = "10.100.0.0/16"
}

variable "public-subnet-names" {
  type = list(string)
  default = [ "prod-acp-pub-subnet-1", "prod-acp-pub-subnet-2" ]
}

variable "public-subnets" {
  type = list(string)
  default = [ "10.100.1.0/24", "10.100.3.0/24" ]
}

variable "pvt-subnets-app" {
  type = list(string)
  default = [ "prod-acp-pvt-app-subnet-1", "prod-acp-pvt-app-subnet-2" ]
}

variable "private-subnets-app" {
  type = list(string)
  default = [ "10.100.5.0/24", "10.100.7.0/24" ]
}

variable "pvt-subnet-db-names" {
  type = list(string)
  default = [ "prod-acp-pvt-db-subnet-1", "prod-acp-pvt-db-subnet-2" ]
}

variable "private-subnets-db" {
  type = list(string)
  default = [ "10.100.9.0/24", "10.100.11.0/24" ]
}

variable "az" {
  type = list(string)
  default = [ "ap-south-2a", "ap-south-2b" ]
}

variable "pub-rt-name" {
  type = string
  default = "prod-acp-pub-rt"
}

variable "pvt-rt-name" {
  type = string
  default = "prod-acp-pvt-rt"
}

variable "securitygroups" {
  type = map(object({
    name = string
    protocol = string
    port = number
    cidr_blocks = list(string)
  }))
  default = {
    "jenkins-sg" = {
      name = "prod-acp-jenkins-sg"
      protocol = "TCP"
      port = 80
      cidr_blocks = ["0.0.0.0/0"]
      
    },
    "elstic-search" = {
      name = "prod-acp-elasticsearch-sg"
      protocol = "TCP"
      port = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}