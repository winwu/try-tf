README.md

## Prepare in advance ##

1. install terraform
2. install aws cli (required for `try-aws` folder)

## [AWS] prepare "default" profile

For `try-aws` practice, we need a aws "default" profile in local env.

0. install aws cli tool
1. touch and edit ~/.aws/credentials
2. fill in these configs

```
[default]
  # aws_access_key_id=
  # aws_secret_access_
  # and run command: "aws configure" in terminal
```

3. exec `aws credentials`

### create key pair for aws instance

**AWS only supports RSA keypairs, it does not support DSA, ECDSA or Ed25519 keypairs.**

* output_keyfile is just like the value in variable.tf (variable aws_intance_public_key)


```
ssh-keygen -f <output_keyfile>
```

## Common commands ##

[offical website](https://developer.hashicorp.com/terraform/cli/commands)

- `terraform init` donwload providers and modules listed in configuration file.
- `terraform fmt` help you format .tf files.
- `terraform validate` help you validate .tf file (not includes validate values is valid or not).
- `terraform plan` preview execution plan.
- `terraform apply` execute plan.
- `terraform apply -auto-approve` execute plan without answer yes or no.
- `terraform show` view current state in remote.
- `terraform apply -destroy` destroy all remove objects.


## Diagrams ##

1. diagram of try-aws practice

![try_aws](./diagrams/try-aws.png)

### Troubleshooting

1. issue1

    ```
    Error: creating EC2 Instance: MissingInput: No subnets found for the default VPC 'vpc-xxxxx'. Please specify a subnet.
    ```

    Resolve:

    ```
    aws ec2 create-default-subnet --availability-zone <Region: e.g us-west-1b>
    ```
