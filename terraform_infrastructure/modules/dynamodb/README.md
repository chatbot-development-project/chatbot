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
| [aws_dynamodb_table.dynamodb-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_lambda_event_source_mapping.trg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | Name of the DynamoDB table | `string` | `"user_metadata"` | no |
| <a name="input_process_stream_function_name"></a> [process\_stream\_function\_name](#input\_process\_stream\_function\_name) | function name for the process stream | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_name_output"></a> [dynamodb\_table\_name\_output](#output\_dynamodb\_table\_name\_output) | Name of the DynamoDB table |
<!-- END_TF_DOCS -->