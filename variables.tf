# =============================================================================
# Variables — Oracle Autonomous Database 26ai Free
# =============================================================================

# -----------------------------------------------------------------------------
# OCI Authentication
# Not required when running inside OCI Resource Manager (instance principal).
# Fill these for local terraform apply, or set as TF_VAR_* env variables.
# -----------------------------------------------------------------------------
variable "tenancy_ocid" {
  description = "OCID of your OCI tenancy."
  type        = string
  default     = ""
}

variable "user_ocid" {
  description = "OCID of the OCI user running Terraform (not required in Resource Manager)."
  type        = string
  default     = ""
}

variable "fingerprint" {
  description = "Fingerprint for the user's API signing key (not required in Resource Manager)."
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "Path to the user's PEM private key file (not required in Resource Manager)."
  type        = string
  default     = ""
}

variable "region" {
  description = "OCI region where the ADB will be created (e.g. uk-london-1)."
  type        = string
  default     = "uk-london-1"
}

# -----------------------------------------------------------------------------
# Compartment
# -----------------------------------------------------------------------------
variable "compartment_ocid" {
  description = "OCID of the compartment in which to create the Autonomous Database."
  type        = string
}

# -----------------------------------------------------------------------------
# Database Identity
# -----------------------------------------------------------------------------
variable "adb_display_name" {
  description = "Human-readable display name for the Autonomous Database (shown in Console)."
  type        = string
  default     = "ADB26aiFree"
}

variable "adb_db_name" {
  description = <<-EOT
    Short database name (alphanumeric, max 14 chars, no hyphens).
    A 4-character random suffix is appended automatically to ensure uniqueness.
  EOT
  type        = string
  default     = "ADB26AI"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9]{0,9}$", var.adb_db_name))
    error_message = "adb_db_name must start with a letter, be alphanumeric only, and be 10 characters or fewer (suffix will be appended)."
  }
}

# -----------------------------------------------------------------------------
# Oracle Database Version
# -----------------------------------------------------------------------------
variable "db_version" {
  description = <<-EOT
    Oracle Database version for the Autonomous Database.
    Use "26ai" for Oracle Database 26ai (latest AI-native release).
    Fall back to "23ai" if 26ai is not yet available in your region.
  EOT
  type    = string
  default = "26ai"

  validation {
    condition     = contains(["26ai", "23ai", "19c", "21c"], var.db_version)
    error_message = "db_version must be one of: 26ai, 23ai, 19c, 21c."
  }
}

# -----------------------------------------------------------------------------
# Workload Type
# -----------------------------------------------------------------------------
variable "db_workload" {
  description = <<-EOT
    Workload type for the Autonomous Database:
      OLTP  — Autonomous Transaction Processing (ATP)
      DW    — Autonomous Data Warehouse (ADW)
      AJD   — Autonomous JSON Database
      APEX  — Oracle APEX Application Development
    Always Free supports OLTP, DW, and AJD.
  EOT
  type    = string
  default = "OLTP"

  validation {
    condition     = contains(["OLTP", "DW", "AJD", "APEX"], var.db_workload)
    error_message = "db_workload must be one of: OLTP, DW, AJD, APEX."
  }
}

# -----------------------------------------------------------------------------
# Admin Credentials
# -----------------------------------------------------------------------------
variable "adb_admin_password" {
  description = <<-EOT
    Password for the ADMIN database user.
    Requirements:
      - 12–30 characters
      - At least one uppercase letter
      - At least one lowercase letter
      - At least one digit
      - At least one special character (#, _, -)
      - Must NOT contain the word "admin" (case-insensitive)
  EOT
  type      = string
  sensitive = true

  validation {
    condition = (
      length(var.adb_admin_password) >= 12 &&
      length(var.adb_admin_password) <= 30 &&
      can(regex("[A-Z]", var.adb_admin_password)) &&
      can(regex("[a-z]", var.adb_admin_password)) &&
      can(regex("[0-9]", var.adb_admin_password)) &&
      can(regex("[#_\\-]", var.adb_admin_password))
    )
    error_message = "Password must be 12-30 chars and contain uppercase, lowercase, a digit, and one of #, _, -."
  }
}

# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------
variable "require_mtls" {
  description = <<-EOT
    When true, only mutual TLS (mTLS) connections are accepted.
    Set to false to allow TLS-only connections from any client
    (handy for quick-start demos without wallet download).
  EOT
  type    = bool
  default = false
}

# -----------------------------------------------------------------------------
# Tagging
# -----------------------------------------------------------------------------
variable "environment_tag" {
  description = "Value for the 'Environment' freeform tag applied to the ADB."
  type        = string
  default     = "Demo"
}
