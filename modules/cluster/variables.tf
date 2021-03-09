variable "name" {
  type = string
  description = "A prefix used for all resources in this project (incl. dashes). Required."

  validation {
    condition     = length(var.name) < 20
    error_message = "Name must be less than 20 characters."
  }
}

variable "suffix" {
  type = string
  description = "Suffix to avoid automation errors on Azure resources that require globally unique names. Defaults to empty string."
  default = ""
}

variable "location" {
  type = string
  description = "Location used for all resources in this project. Defaults to 'Central US'"
  default = "Central US"
}

variable "default_tags" {
  type = map(string)
  default = {
    demo 	   = "true"
    env 	 	 = "prod"
    public   = "true"
  }
}

# Calculated Values
# -----------------

locals {
	name 				 = lower("${var.name}%{ if var.suffix != "" }-${var.suffix}%{ endif }")
  name_squished = replace(local.name, "-", "")
}