variable "whatsapp_input_role" {
  default = "input_iam_role"
}

variable "whatsapp_output_role" {
  default = "output_iam_role"
}

variable "cloud_auth_role" {
  default = "auth_iam_role"
}

variable "process_stream_role" {
  default = "process_iam_role"
}


variable "lambda_iam_policy_name" {
  default = "lambda_iam_policy"
}

variable "whatsapp_input" {
  default = "whatsapp_input"
  description = "lambda function for whatsapp input"
  type        = string
}

variable "whatsapp_output" {
  default = "whatsapp_output"
  description = "lambda function for whatsapp output"
  type        = string
}

variable "cloud_auth" {
  default = "cloud_auth"
  description = "lambda function for cloud auth"
  type        = string
}

variable "process_stream" {
  default = "process_stream"
  description = "lambda function for process stream"
  type        = string
}

variable "Lruntime" {
  default = "python3.9"
}

variable "Ltimeout" {
  default = "900"
}
