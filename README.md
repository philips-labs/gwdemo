# gwdemo

This repo demonstrates how it's possible to implement an application on HSDP using an API gateway. Several new features of HSDP are used to make this a fully functional demo. The most important new feature is container to container networking with internal DNS for service discovery. This allows for the deployment of completely private services in Cloud Foundry. Each environment also has a special internal DNS domain that private apps are deployed into: apps.internal. When applications are deployed to this domain they will be unreachable externally or internally. It's not possible to make these apps reachable from outside the environment. Policies can be defined and applied that allow for internal traffic between applications.

When communicating via the overlay network internal traffic bypasses the gorouter which is typically responsible for load-balancing traffic across multiple application instances. Round Robin DNS is used for load balancing traffic internally between applications. This is effectively the same (albeit less sophisticated) function as the gorouter serves for external traffic.

Internal services are also not restricted to HTTP only. Any TCP/UDP port can be defined as allowed in the networking policies.

# requirements

In order to use this demo you need to be onboarded to use HSDP Cloud foundry services an have `OrgAdmin` privileges. 
Future versions of this demo will be `SpaceDeveloper` friendly. See the [hsdp.io](https://hsdp.io) portal for details. 
The following information is required:

- `cf_api_url` -- Cloud foundry API URL of the region
- `cf_username` -- Cloud foundry username
- `cf_password` -- Cloud foundry password
- `cf_org_name` -- Cloud foundry ORG name. Usually starts with `client-...`

There are severals ways let Terraform know about these values. You can create `terraform.tfvar` (any `.tfvar`) that looks like this:

```hcl
cf_api_url  = "https://api.cloud.pcftest.com"
cf_username = "alastname"
cf_password = "@PassW0rd"
cf_org_name = "client-cf-org"
```

Or you can pas them as environment variables:

```bash
$ export TF_VAR_cf_api_url=https://api.cloud.pcftest.com
$ export TF_VAR_cf_username=alastname
...
$ terraform init
$ terraform plan
```

## terraform-cloudfoudry-gwdemo

All of the details are captured in a [Terraform module](https://www.terraform.io/docs/modules/index.html). We want to dive into using modules immediately as that unlocks one of the more powerful aspects of using Terraform: reusable components. Head over to the [terraform-cloudfoudry-gwdemo](https://github.com/philips-labs/terraform-cloudfoundry-gwdemo) repository to examine the module.
