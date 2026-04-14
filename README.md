Andaca-thon - Urban and Otter

Deploy an **Oracle Database 26ai** Autonomous Database on the **Always Free tier** using OCI Resource Manager.

This stack provisions a fully managed ADB with zero cost using Oracle's Always Free entitlements:

| Resource | Always Free Limit |
|---|---|
| OCPU | 1 (shared) |
| Storage | 20 GB |
| Databases | Up to 2 per tenancy |

---

## 🚀 One-Click Deploy

Deploy Oracle 26ai Database button:


# [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/abihaigh/Andackathon/blob/main/ADW_Stack/ADW_26_deploy.zip)

> **Tip:** Push this folder to a GitHub repo and use the release zip URL directly.

---

## Oracle Database 26ai Features Included

All of the following are available the moment your ADB is provisioned:

- **AI Vector Search** — Store, index, and query embedding vectors with `VECTOR` column type and similarity operators (`<=>`, `<->`, `<#>`)
- **Property Graph** — Run graph queries with `GRAPH_TABLE()` and SQL/PGQ syntax natively in SQL
- **JSON Duality Views** — Expose relational tables as updateable JSON documents without duplication
- **ONNX ML Inference** — Load `.onnx` models directly into the database and score rows with `PREDICTION()`
- **Select AI** — Natural language to SQL translation using a configured LLM provider
- **Oracle Text & Spatial** — Full-text search and SDO_GEOMETRY spatial types built-in

---

## Prerequisites

- An OCI tenancy with Always Free quota available (max 2 Always Free ADBs per tenancy)
- Sufficient IAM permissions to create Autonomous Databases in the target compartment

---

## Local Deployment (without Resource Manager)

### 1. Configure credentials

```hcl
# terraform.tfvars  (DO NOT commit this file)
tenancy_ocid     = "ocid1.tenancy.oc1..aaa..."
user_ocid        = "ocid1.user.oc1..aaa..."
fingerprint      = "xx:xx:xx:..."
private_key_path = "~/.oci/oci_api_key.pem"
region           = "uk-london-1"
compartment_ocid = "ocid1.compartment.oc1..aaa..."
adb_admin_password = "MyStr0ng#Pass"
```

### 2. Initialise and apply

```bash
terraform init
terraform plan
terraform apply
```

### 3. Connect

After apply, the outputs include:
- `adb_service_console_url` — SQL Developer Web, APEX, Graph Studio, ML Studio
- `adb_connection_strings` — JDBC/ODBC connection profiles

**Wallet-free (mTLS OFF, default):**
```python
import oracledb
conn = oracledb.connect(
    user="ADMIN",
    password="<your-password>",
    dsn="<adb_db_name>_high.adb.oraclecloud.com/...",   # from connection_strings output
)
```

**With wallet (mTLS ON):**
```python
import oracledb
conn = oracledb.connect(
    user="ADMIN",
    password="<your-password>",
    wallet_location="/path/to/wallet",
    dsn="<profile>",
)
```

---

## Quick-Start: AI Vector Search (26ai)

```sql
-- Create a table with a VECTOR column
CREATE TABLE doc_embeddings (
    id     NUMBER GENERATED ALWAYS AS IDENTITY,
    doc    VARCHAR2(4000),
    emb    VECTOR(1536, FLOAT32)   -- dimension matches your embedding model
);

-- Insert with a Python-generated embedding (example)
INSERT INTO doc_embeddings (doc, emb)
VALUES ('Oracle Database 26ai is the AI-native database.', :1);

-- Semantic similarity search (cosine distance)
SELECT doc, VECTOR_DISTANCE(emb, :query_emb, COSINE) AS score
FROM   doc_embeddings
ORDER  BY score
FETCH  FIRST 5 ROWS ONLY;
```

---

## Terraform File Reference

| File | Purpose |
|---|---|
| `main.tf` | Core ADB resource definition |
| `variables.tf` | All input variables with validation |
| `outputs.tf` | Connection strings, URLs, state |
| `schema.yaml` | OCI Resource Manager UI metadata |
| `README.md` | This file |

---

## Destroy

```bash
terraform destroy
```

> Always Free databases can also be terminated from the OCI Console.

---

## License

Apache 2.0 — see [Oracle Terraform Provider examples](https://github.com/oracle/terraform-provider-oci).
