# Terraform Practice Repo

## Env ##

1. install [Terraform](https://developer.hashicorp.com/terraform/downloads)
2. install aws cli (required for `try-aws` folder)

### Others

For aws related practices, we need a aws "default" profile in local env.

1.  prepare "default" profile
2. touch and edit ~/.aws/credentials
3. fill in these configs, like:

```
[default]
  # aws_access_key_id=
  # aws_secret_access_
  # and run command: "aws configure" in terminal
```

4. exec `aws credentials`

5. create key pair for aws instance (**AWS only supports RSA keypairs, it does not support DSA, ECDSA or Ed25519 keypairs**)

  ```bash
  ssh-keygen -f <output_keyfile>
  # output_keyfile is just like the value in variable.tf (variable aws_intance_public_key)
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

1. Diagram of try-aws practice

  * Serve a web page in ec2
  * allow public access (IGW + Security group: 80 port and 22 port)
  * 1 VPC, 1 public subnet, 1 custom routing table.

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
