This is a tailscale sandbox. Right now its just github actions and terraform

# This infrastructure has been torn down. Re-run the terraform to stand it back up

# What does this project do?
1. creates a VPC in GCP, with firewalls and cloud NAt
2. installs a tailscale subnet router as a VM
3. creates a private VM instance running NGINX on the same subnetwork
4. whenever a commit is pushed to this branch the GHA connect to the tailnet and ping the nginx VM, to prove that things are setup correctly
5. tailscale settings can be found at https://login.tailscale.com/admin/acls/file

# Gotchas
- The way that tags are managed for the subnet router are not well known by me. I think its handled via the auth key.
- I'm using an auth key right now, which is not ideal. Should be using oauth.

# Running Terraform

Right now I am using an auth key, the final solution will use oauth in the startup script of the subnet router

When you run `terraform apply` it will ask for the value of `AUTH_KEY`
```
$ terraform plan
var.AUTH_KEY
  Enter a value: 
```

~The value can be found in the `dev1` project secret manager, its named `tailscale-auth-key`~
Since the project has been torn down this no longer exists. You'll have to generate a new auth key in TS

