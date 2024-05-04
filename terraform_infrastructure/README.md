<!-- BEGIN_TF_DOCS -->

## File Structure
```
└── terraform_infrastructure/
    ├── main.tf
    ├── providers.tf
    ├── locals.tf
    ├── varibles.tf
    ├── output.tf
    ├── modules/
    │   ├── lambdas/
    │   │   ├── CODE/
    │   │   │   ├── cloudapi_auth/
    │   │   │   │   └── cloudapi_auth.py
    │   │   │   ├── process_stream/
    │   │   │   │   └── process_stream.py
    │   │   │   ├── whatsapp_input/
    │   │   │   │   └── whatsapp_input.py
    │   │   │   └── whatsapp_output/
    │   │   │       └── whatsapp_output.py
    │   │   ├── policy/
    │   │   │   ├── assume_role.json
    │   │   │   ├── cloud_auth_policy.json
    │   │   │   ├── input_policy.json
    │   │   │   ├── output_policy.json
    │   │   │   └── process_stream_policy.json
    │   │   ├── README.md
    │   │   ├── cloudapi_auth.zip
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   ├── process_stream.zip
    │   │   ├── python.zip
    │   │   ├── variables.tf
    │   │   ├── whatsapp_input.zip
    │   │   └── whatsapp_output.zip
    │   ├── apigateways/
    │   │   ├── main.tf
    │   │   ├── README.md
    │   │   ├── variables.tf
    │   │   ├── output.tf
    │   │   ├── policy/
    │   │   │   ├── api_gateway_policy.json
    │   │   │   └── api_gateway_role.json
    │   ├── bedrock/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── output.tf
    │   └── dynamodb/
    │       ├── main.tf
    │       ├── README.md
    │       ├── variables.tf
    │       └── output.tf
    ├── other_files/
    └── README.md
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.67.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ./modules/apigateways | n/a |
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ./modules/dynamodb | n/a |
| <a name="module_lambda_functions"></a> [lambda\_functions](#module\_lambda\_functions) | ./modules/lambdas | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->