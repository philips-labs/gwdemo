module "api_gateway" {
  source        = "github.com/philips-labs/terraform-cloudfoundry-gwdemo//src"
  cf_username   = var.cf_username
  cf_org_name   = var.cf_org_name
  cf_app_domain = "us-east.philips-healthsuite.com"
}
