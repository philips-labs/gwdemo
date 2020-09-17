# gwdemo

This repo demonstrates how it's possible to implement an application on HSDP using an API gateway. Several new features of HSDP are used to make this a fully functional demo. The most important new feature is container to container networking with internal DNS for service discovery. This allows for the deployment of completely private services in Cloud Foundry. Each environment also has a special internal DNS domain that private apps are deployed into: apps.internal. When applications are deployed to this domain they will be unreachable externally or internally. It's not possible to make these apps reachable from outside the environment. Policies can be defined and applied that allow for internal traffic between applications.

When communicating via the overlay network internal traffic bypasses the gorouter which is typically responsible for load-balancing traffic across multiple application instances. Round Robin DNS is used for load balancing traffic internally between applications. This is effectively the same (albeit less sophisticated) function as the gorouter serves for external traffic.

Internal services are also not restricted to HTTP only. Any TCP/UDP port can be defined as allowed in the networking policies.

# terraform-cloudfoudry-gwdemo

The bulk of the resources we need to provision are declared in a [Terraform module](https://www.terraform.io/docs/modules/index.html). Introducing Terraform modules unlocks one of the more powerful aspects of using Terraform: reusable components. 

You may want to head over to the [terraform-cloudfoudry-gwdemo](https://github.com/philips-labs/terraform-cloudfoundry-gwdemo) repository first to dive into the details. Alternatively, you can follow the rest of this README and deploy the gwdemo environment first and afterwards examine the module contents.

# requirements

In order to deploy this demo you need to be onboarded onto HSDP Cloud foundry services an have `OrgAdmin` privileges.
Future versions of this demo will be `SpaceDeveloper` friendly. See the [hsdp.io](https://hsdp.io) portal for details. 
The following information is required:

- `cf_api_url` -- Cloud foundry API URL of the region e.g. https://api.eu1.phsdp.com
- `cf_username` -- Your Cloud foundry username
- `cf_password` -- Your Cloud foundry password
- `cf_org_name` -- Your Cloud foundry ORG name. Usually starts with `client-...`

There are severals ways to let Terraform know about these values. You can create `terraform.tfvar` (any `.tfvar` file really) that looks like this:

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
```

# init
This step initializes Terraform and downloads providers and modules

```bash
$ terraform init
Initializing modules...
Downloading github.com/philips-labs/terraform-cloudfoundry-gwdemo for api_gateway...
- api_gateway in .terraform/modules/api_gateway/src

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/local...
...
...
Terraform has been successfully initialized!
...
```

# plan
This step plans out what terraform will do

```bash
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.api_gateway.data.archive_file.users_api: Refreshing state...
module.api_gateway.data.archive_file.devices_api: Refreshing state...
...
...
Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cf_org   = "hsdp-demo-org"
  + cf_space = (known after apply)
  + gw_url   = (known after apply)
...
```

# apply
The apply step will actually create resources and deploy your applications

```bash
$ terraform apply -auto-approve
...
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

cf_org = client-cf-org
cf_space = gwdemo-0305fc1e2e423ecd
gw_url = https://api-gateway-0305fc1e2e423ecd.us-east.philips-healthsuite.com
```

The `apply` step should take about a minute to complete.
