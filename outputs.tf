# =============================================================================
# Outputs — Oracle Autonomous Database 26ai Free
# =============================================================================

output "adb_id" {
  description = "OCID of the provisioned Autonomous Database."
  value       = oci_database_autonomous_database.adb_26ai_free.id
}

output "adb_display_name" {
  description = "Display name of the Autonomous Database."
  value       = oci_database_autonomous_database.adb_26ai_free.display_name
}

output "adb_db_name" {
  description = "Short database name (used in connection strings)."
  value       = oci_database_autonomous_database.adb_26ai_free.db_name
}

output "adb_db_version" {
  description = "Oracle Database version running on the ADB."
  value       = oci_database_autonomous_database.adb_26ai_free.db_version
}

output "adb_workload_type" {
  description = "Workload type (OLTP / DW / AJD / APEX)."
  value       = oci_database_autonomous_database.adb_26ai_free.db_workload
}

output "adb_is_free_tier" {
  description = "Confirms this is an Always Free database."
  value       = oci_database_autonomous_database.adb_26ai_free.is_free_tier
}

output "adb_lifecycle_state" {
  description = "Current lifecycle state of the ADB."
  value       = oci_database_autonomous_database.adb_26ai_free.state
}

output "adb_service_console_url" {
  description = "URL of the Autonomous Database Service Console (SQL Developer Web, APEX, etc.)."
  value       = oci_database_autonomous_database.adb_26ai_free.service_console_url
}

output "adb_connection_strings" {
  description = "Map of connection string profiles (HIGH / MEDIUM / LOW / TP / TPURGENT)."
  value       = oci_database_autonomous_database.adb_26ai_free.connection_strings
  sensitive   = false
}

output "adb_connection_urls" {
  description = "ORDS / SQL Developer Web / APEX / Graph Studio / Machine Learning Studio URLs."
  value       = oci_database_autonomous_database.adb_26ai_free.connection_urls
}

output "wallet_download_hint" {
  description = "Reminder: download the client credentials wallet from the OCI Console if mTLS is enabled."
  value = var.require_mtls ? (
    "mTLS is ON — download the wallet from Console → Autonomous Database → DB Connections → Download Wallet."
  ) : (
    "mTLS is OFF — connect using TLS with any JDBC/ODBC/Python-oracledb client without a wallet."
  )
}
