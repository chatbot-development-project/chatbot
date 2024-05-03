<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloud_auth_lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.input_lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.output_lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.process_lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cloud_auth_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.input_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.output_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.process_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloud_auth_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.input_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.output_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.process_stream_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.cloud_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.process_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.whatsapp_input](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.whatsapp_output](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.my_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [archive_file.cloud_auth_python_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.input_python_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.output_python_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.process_stream_python_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Lruntime"></a> [Lruntime](#input\_Lruntime) | n/a | `string` | `"python3.9"` | no |
| <a name="input_Ltimeout"></a> [Ltimeout](#input\_Ltimeout) | n/a | `string` | `"900"` | no |
| <a name="input_cloud_auth"></a> [cloud\_auth](#input\_cloud\_auth) | lambda function for cloud auth | `string` | `"cloud_auth"` | no |
| <a name="input_cloud_auth_role"></a> [cloud\_auth\_role](#input\_cloud\_auth\_role) | n/a | `string` | `"auth_iam_role"` | no |
| <a name="input_lambda_iam_policy_name"></a> [lambda\_iam\_policy\_name](#input\_lambda\_iam\_policy\_name) | n/a | `string` | `"lambda_iam_policy"` | no |
| <a name="input_process_stream"></a> [process\_stream](#input\_process\_stream) | lambda function for process stream | `string` | `"process_stream"` | no |
| <a name="input_process_stream_role"></a> [process\_stream\_role](#input\_process\_stream\_role) | n/a | `string` | `"process_iam_role"` | no |
| <a name="input_whatsapp_input"></a> [whatsapp\_input](#input\_whatsapp\_input) | lambda function for whatsapp input | `string` | `"whatsapp_input"` | no |
| <a name="input_whatsapp_input_role"></a> [whatsapp\_input\_role](#input\_whatsapp\_input\_role) | n/a | `string` | `"input_iam_role"` | no |
| <a name="input_whatsapp_output"></a> [whatsapp\_output](#input\_whatsapp\_output) | lambda function for whatsapp output | `string` | `"whatsapp_output"` | no |
| <a name="input_whatsapp_output_role"></a> [whatsapp\_output\_role](#input\_whatsapp\_output\_role) | n/a | `string` | `"output_iam_role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_auth_function_name"></a> [cloud\_auth\_function\_name](#output\_cloud\_auth\_function\_name) | n/a |
| <a name="output_cloud_auth_invoke_arn"></a> [cloud\_auth\_invoke\_arn](#output\_cloud\_auth\_invoke\_arn) | n/a |
| <a name="output_cloud_auth_lambda_arn"></a> [cloud\_auth\_lambda\_arn](#output\_cloud\_auth\_lambda\_arn) | ARN of the Cloud API authentication Lambda function |
| <a name="output_process_stream_lambda_arn"></a> [process\_stream\_lambda\_arn](#output\_process\_stream\_lambda\_arn) | ARN of the Process Stream Lambda function |
| <a name="output_whatsapp_input_function_name"></a> [whatsapp\_input\_function\_name](#output\_whatsapp\_input\_function\_name) | n/a |
| <a name="output_whatsapp_input_invoke_arn"></a> [whatsapp\_input\_invoke\_arn](#output\_whatsapp\_input\_invoke\_arn) | n/a |
| <a name="output_whatsapp_input_lambda_arn"></a> [whatsapp\_input\_lambda\_arn](#output\_whatsapp\_input\_lambda\_arn) | ARN of the WhatsApp input Lambda function |
| <a name="output_whatsapp_output_lambda_arn"></a> [whatsapp\_output\_lambda\_arn](#output\_whatsapp\_output\_lambda\_arn) | ARN of the WhatsApp output Lambda function |
<!-- END_TF_DOCS -->