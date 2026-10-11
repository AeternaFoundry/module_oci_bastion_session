resource "oci_bastion_session" "bastion_sessions" {
  for_each = var.bastion_sessions

  bastion_id             = each.value.bastion_id
  display_name           = each.value.display_name
  key_type               = each.value.key_type
  session_ttl_in_seconds = each.value.session_ttl_in_seconds

  key_details {
    public_key_content = each.value.key_details.public_key_content
  }

  target_resource_details {
    session_type                               = each.value.target_resource_details.session_type
    target_resource_fqdn                       = each.value.target_resource_details.target_resource_fqdn
    target_resource_id                         = each.value.target_resource_details.target_resource_id
    target_resource_operating_system_user_name = each.value.target_resource_details.target_resource_operating_system_user_name
    target_resource_port                       = each.value.target_resource_details.target_resource_port
    target_resource_private_ip_address         = each.value.target_resource_details.target_resource_private_ip_address
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

