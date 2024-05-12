resource "azurerm_role_assignment" "current_role_assignment_key_vault_secrets_operator" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Operator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# User Assigned Identity
resource "azurerm_role_assignment" "uai_role_assignment_key_vault_secrets_user" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}
