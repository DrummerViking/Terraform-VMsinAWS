variable "domain_name" {
    default = "domain.lab"
}
variable "netbios_domainname" {
    default = "domain"
}
variable dc_name {
    default = "DC"
}
variable admin_name {
    default = "LabAdmin"
}
variable admin_pass {
    default = "S3cr37P455"
}

variable pubkey_filename {
    description = "The name of the public key file to use for SSH access."
    default     = "awskey_id_rsa.pub" # Replace with your public key filename
}

variable "machines_name_list" {
  description = "List of machine names to create dynamically."
  type        = list(string)
  default     = ["srv1", "ex1", "AADCsvr", "ADFSsvr"]
}