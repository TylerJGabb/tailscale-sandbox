This is a tailscale sandbox. Right now its just github actions and terraform

# Running Terraform

Right now I am using an auth key, the final solution will use oauth in the startup script of the subnet router

When you run `terraform apply` it will ask for the value of `AUTH_KEY`
```
$ terraform plan
var.AUTH_KEY
  Enter a value: 
```

The value can be found in the `dev1` project secret manager, its named `tailscale-auth-key`
