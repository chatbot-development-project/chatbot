variable "api_name" {
  description = "Name of the API Gateway REST API"
  default     = "api_gateway"
}

variable "resource_name" {
  description = "Name of the API Gateway resource"
  default     = "cloudapi"
}

variable "api_stage_name" {
  description = "Name of the API Gateway deployment stage"
  default     = "prod"
}


variable "get_invoke_arn" {
  description = "cloud_auth_invoke_arn"
}

variable "post_invoke_arn" {
  description = "whatsapp_input_invoke_arn"
}

variable "whatsapp_input_function_name" {
  description = "whatsapp_input_function name"
}


variable "cloud_auth_function_name" {
 description = "cloud auth function name"
}

variable "region" {
  default = "us-east-1"
}
