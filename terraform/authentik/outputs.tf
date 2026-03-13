
output "client_ids" {
  value = {
    for name, app in module.standard_application : name => app.client_id
  }
}
