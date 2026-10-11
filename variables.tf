variable "bastion_sessions" {
  description = <<EOT
Map of bastion_sessions, attributes below
Required:
    - bastion_id
    - key_details (block):
        - public_key_content (required)
    - target_resource_details (block):
        - session_type (required)
        - target_resource_fqdn (optional)
        - target_resource_id (optional)
        - target_resource_operating_system_user_name (optional)
        - target_resource_port (optional)
        - target_resource_private_ip_address (optional)
Optional:
    - display_name
    - key_type
    - session_ttl_in_seconds
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    bastion_id             = string
    display_name           = optional(string)
    key_type               = optional(string)
    session_ttl_in_seconds = optional(number)
    key_details = object({
      public_key_content = string
    })
    target_resource_details = object({
      session_type                               = string
      target_resource_fqdn                       = optional(string)
      target_resource_id                         = optional(string)
      target_resource_operating_system_user_name = optional(string)
      target_resource_port                       = optional(number)
      target_resource_private_ip_address         = optional(string)
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.bastion_sessions : (
        contains([for v in ["DYNAMIC_PORT_FORWARDING", "MANAGED_SSH", "PORT_FORWARDING"] : lower(v)], lower(v.target_resource_details.session_type))
      )
    ])
    error_message = "must be one of: \"DYNAMIC_PORT_FORWARDING\", \"MANAGED_SSH\", \"PORT_FORWARDING\""
  }
}

