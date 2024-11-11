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

variable "delay_message_role" {
  default = "delay_iam_role"
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

variable "delay_message" {
  default = "delay_message"
  description = "lambda function for delay_message"
  type        = string
}

variable "process_stream" {
  default = "process_stream"
  description = "lambda function for process stream"
  type        = string
}

variable "Lruntime" {
  default = "python3.10"
}

variable "Ltimeout" {
  default = "900"
}

variable "knowledege_base_evn" {
  description = "this is the evn of the knowledge base id that would be passed to the handler"
}

# Create a variable for access token and phone number id in the variable.tf file
variable "access_token_evn" {
  default = "ADD_ACCESS_TOKEN_HERE_XXXXX"
  description = "this is the evn of the access token that would be passed to the whatsapp output handler"
}

variable "phone_number_id_env" {
  default = "ADD-PHONE-NUMBER-ID-HERE-XXXX"
  description = "the evn var of the Phone number ID for WhatsApp output handler"
  type        = string
}
