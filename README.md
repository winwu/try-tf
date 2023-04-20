README.md

## prepare in advance ##

1. install terraform
2. install aws cli
3. config aws credentials file
    
    ```
    vi ~/.aws/credentials
    ```

    ```
    [default]
    aws_access_key_id=
    aws_secret_access_key=
    ```

4. execute `aws configure`

## Common commands ##

[offical website](https://developer.hashicorp.com/terraform/cli/commands)

- `terraform init` donwload providers and modules listed in configuration file.
- `terraform fmt` help you format .tf files.
- `terraform validate` help you validate .tf file (not includes validate values is valid or not).
- `terraform plan` preview execution plan.
- `terraform apply` execute plan.
- `terraform show` view current state in remote.
- `terraform apply -destroy` destroy all remove objects.