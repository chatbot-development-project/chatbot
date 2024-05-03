<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.prod_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.get_lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.post_lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.get_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.post_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.cloudapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.grisapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_cloudwatch_log_group.api_gateway_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.api_gateway_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.api_gateway_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_permission.apigw_cloudauth_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.apigw_input_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Name of the API Gateway REST API | `string` | `"api_gateway"` | no |
| <a name="input_api_stage_name"></a> [api\_stage\_name](#input\_api\_stage\_name) | Name of the API Gateway deployment stage | `string` | `"prod"` | no |
| <a name="input_cloud_auth_function_name"></a> [cloud\_auth\_function\_name](#input\_cloud\_auth\_function\_name) | cloud auth function name | `any` | n/a | yes |
| <a name="input_get_invoke_arn"></a> [get\_invoke\_arn](#input\_get\_invoke\_arn) | cloud\_auth\_invoke\_arn | `any` | n/a | yes |
| <a name="input_post_invoke_arn"></a> [post\_invoke\_arn](#input\_post\_invoke\_arn) | whatsapp\_input\_invoke\_arn | `any` | n/a | yes |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | Name of the API Gateway resource | `string` | `"cloudapi"` | no |
| <a name="input_whatsapp_input_function_name"></a> [whatsapp\_input\_function\_name](#input\_whatsapp\_input\_function\_name) | whatsapp\_input\_function name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_url"></a> [api\_gateway\_url](#output\_api\_gateway\_url) | URL of the deployed API Gateway |
| <a name="output_cloud_auth_function_name"></a> [cloud\_auth\_function\_name](#output\_cloud\_auth\_function\_name) | n/a |
| <a name="output_get_method_url"></a> [get\_method\_url](#output\_get\_method\_url) | n/a |
| <a name="output_post_method_url"></a> [post\_method\_url](#output\_post\_method\_url) | n/a |
| <a name="output_whatsapp_input_function_name"></a> [whatsapp\_input\_function\_name](#output\_whatsapp\_input\_function\_name) | n/a |
<!-- END_TF_DOCS -->