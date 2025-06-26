---
tags:
  - component/tgw/attachment
  - layer/network
  - provider/aws
---

# Component: `tgw/attachment`

This component is responsible for provisioning an AWS Transit Gateway VPC attachment and managing its route table associations. It enables VPCs to connect to a Transit Gateway for inter-VPC communication.

## Usage

**Stack Level**: Regional

This component is deployed to each region where VPCs need to be attached to a Transit Gateway.

### Basic Example

Here's a simple example using physical IDs:

```yaml
components:
  terraform:
    tgw/attachment:
      vars:
        transit_gateway_id: "tgw-0123456789abcdef0"
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef0"
        create_transit_gateway_route_table_association: false
```

The same configuration using terraform outputs:

```yaml
components:
  terraform:
    tgw/attachment:
      vars:
        transit_gateway_id: !terraform.output tgw/hub transit_gateway_id
        transit_gateway_route_table_id: !terraform.output tgw/hub transit_gateway_route_table_id
        create_transit_gateway_route_table_association: false
```

### Network Account Configuration

Example using physical IDs:

```yaml
components:
  terraform:
    tgw/attachment:
      vars:
        transit_gateway_id: "tgw-0123456789abcdef0"
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef0"
        create_transit_gateway_route_table_association: true

        # Additional associations are required for peered connections
        additional_associations:
          - attachment_id: "tgw-attach-0123456789abcdef1"
            route_table_id: "tgw-rtb-0123456789abcdef0"
```

The same configuration using terraform outputs:

```yaml
components:
  terraform:
    tgw/attachment:
      vars:
        transit_gateway_id: !terraform.output tgw/hub transit_gateway_id
        transit_gateway_route_table_id: !terraform.output tgw/hub transit_gateway_route_table_id
        create_transit_gateway_route_table_association: true

        # Additional associations are required for peered connections
        additional_associations:
          - attachment_id: !terraform.output tgw/attachment edge-vpc transit_gateway_attachment_id
            route_table_id: !terraform.output tgw/hub transit_gateway_route_table_id
```

### Multiple Transit Gateway Support

Example using physical IDs:

```yaml
components:
  terraform:
    tgw/attachment/nonprod:
      metadata:
        component: tgw/attachment
      vars:
        transit_gateway_id: "tgw-0123456789abcdef1"
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef1"
        create_transit_gateway_route_table_association: false

    tgw/attachment/prod:
      metadata:
        component: tgw/attachment
      vars:
        transit_gateway_id: "tgw-0123456789abcdef2"
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef2"
        create_transit_gateway_route_table_association: false
```

The same configuration using terraform outputs:

```yaml
components:
  terraform:
    tgw/attachment/nonprod:
      metadata:
        component: tgw/attachment
      vars:
        transit_gateway_id: !terraform.output tgw/hub transit-use1-nonprod transit_gateway_id
        transit_gateway_route_table_id: !terraform.output tgw/hub transit-use1-nonprod transit_gateway_route_table_id
        create_transit_gateway_route_table_association: false

    tgw/attachment/prod:
      metadata:
        component: tgw/attachment
      vars:
        transit_gateway_id: !terraform.output tgw/hub transit-use1-prod transit_gateway_id
        transit_gateway_route_table_id: !terraform.output tgw/hub transit-use1-prod transit_gateway_route_table_id
        create_transit_gateway_route_table_association: false
```

## Important Notes

1. Route table associations (`create_transit_gateway_route_table_association`) should only be enabled in the network account where the Transit Gateway exists.

2. When connecting to multiple Transit Gateways:
   - Use clear naming conventions (e.g., `tgw/attachment/prod`, `tgw/attachment/nonprod`)
   - Configure appropriate VPC routes to direct traffic through the correct Transit Gateway

3. After creating attachments, configure VPC routes using the `vpc-routes` component to enable traffic flow.

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | < 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | < 7.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../../account-map/modules/iam-roles | n/a |
| <a name="module_standard_vpc_attachment"></a> [standard\_vpc\_attachment](#module\_standard\_vpc\_attachment) | cloudposse/transit-gateway/aws | 0.11.3 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/stack-config/yaml//modules/remote-state | 1.8.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the Transit Gateway to attach to | `string` | n/a | yes |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | ID of the Transit Gateway Route Table | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_vpc_attachment_id"></a> [transit\_gateway\_vpc\_attachment\_id](#output\_transit\_gateway\_vpc\_attachment\_id) | ID of the Transit Gateway VPC Attachment |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- prettier-ignore-end -->

## References

- [AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)
- [cloudposse/terraform-aws-components](TODO) - Cloud Posse's upstream component

[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
