## 
variable "allocated_storage" {
  description = "How much storage for RDS instance"
}

variable "engine" {
  description = "What engine to use"
}

variable "engine_version" {
  description = "Version of the engine"
}

variable "instance_class" {
  description = "Size the instance"
}

variable "name" {
  description = "Name of the RDS instance"
}

variable "username" {
  description = "User name"
}

variable "password" {
  description = "Password"
}

variable "db_subnet_group_name" {
  description = "my_database_subnet_group"
}

/* 
variable "parameter_group_name" {
  description = "Define the parameter group to use"
}
*/
