# =============================================================================
# Oracle Autonomous Database 26ai — Always Free Tier
# OCI Resource Manager compatible stack
# =============================================================================

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

# -----------------------------------------------------------------------------
# Provider — uses OCI Resource Manager instance principal automatically
# when deployed via the Deploy to Oracle Cloud button.
# For local runs, set TF_VAR_* env vars or fill terraform.tfvars.
# -----------------------------------------------------------------------------
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# -----------------------------------------------------------------------------
# Data sources
# -----------------------------------------------------------------------------

# Resolve the target compartment (defaults to tenancy root if not supplied)
data "oci_identity_compartment" "target" {
  id = var.compartment_ocid
}

# Pull the list of available ADB versions so we can validate the chosen one
data "oci_database_autonomous_db_versions" "available" {
  compartment_id = var.compartment_ocid
  db_workload    = var.db_workload
}

# -----------------------------------------------------------------------------
# Random suffix — keeps the DB name unique on re-deploys
# -----------------------------------------------------------------------------
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# -----------------------------------------------------------------------------
# Autonomous Database — Always Free, Oracle Database 26ai
# -----------------------------------------------------------------------------
resource "oci_database_autonomous_database" "adb_26ai_free" {
  # Identity
  compartment_id = var.compartment_ocid
  display_name   = "${var.adb_display_name}-${random_string.suffix.result}"
  db_name        = "${var.adb_db_name}${random_string.suffix.result}"

  # ---- Always Free settings ------------------------------------------------
  # is_free_tier = true locks you to 1 OCPU and 20 GB storage at no cost.
  # These values MUST match the Always Free constraints — do not change them.
  is_free_tier           = true
  cpu_core_count         = 1           # Always Free: 1 ECPU (shown as 1 OCPU in TF)
  data_storage_size_in_gbs = 20        # Always Free cap: 20 GB

  # ---- Oracle Database version ---------------------------------------------
  # "26ai" targets Oracle Database 26ai (AI Vector Search, Property Graph,
  # JSON Duality, ONNX inference all built-in).
  # If 26ai is not yet available in your region OCI will automatically
  # provision the latest supported version — use var.db_version to override.
  db_version   = var.db_version        # default: "26ai" (see variables.tf)
  db_workload  = var.db_workload       # OLTP | DW | AJD | APEX

  # ---- Licensing & compute -------------------------------------------------
  license_model                    = "LICENSE_INCLUDED"
  is_auto_scaling_enabled          = false   # not supported on Always Free
  is_auto_scaling_for_storage_enabled = false

  # ---- Credentials ---------------------------------------------------------
  admin_password = var.adb_admin_password

  # ---- Network -------------------------------------------------------------
  # PUBLIC endpoint by default (suitable for demos & quick starts).
  # Set is_mtls_connection_required = true and configure a private endpoint
  # for production workloads.
  is_mtls_connection_required = var.require_mtls

  # ---- Character sets ------------------------------------------------------
  character_set    = "AL32UTF8"
  ncharacter_set   = "AL16UTF16"

  # ---- Maintenance & backup ------------------------------------------------
  # Always Free DBs are automatically backed up by Oracle.
  is_local_data_guard_enabled = false

  # ---- Tagging -------------------------------------------------------------
  freeform_tags = {
    "DeployedBy"  = "Terraform"
    "Stack"       = "ADB-26ai-Free"
    "Environment" = var.environment_tag
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "30m"
  }
}
