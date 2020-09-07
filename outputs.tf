output "gw_url" {
  value = module.api_gateway.url
}

output "cf_space" {
  value = module.api_gateway.space
}

output "cf_org" {
  value = var.cf_org_name
}
