# implement-pii-mask-iceberg-using-risingwave

A practical guide and demo project for masking Personally Identifiable Information (PII) data in PostgreSQL, then streaming it securely into Apache Iceberg using RisingWave. This repo showcases a modern approach to real-time data transformation and compliance in data lake architectures.

---

## Overview

This project demonstrates:
- How to mask PII data using a custom Python UDF.
- Streaming data from PostgreSQL to Apache Iceberg via RisingWave.
- Real-time data masking and compliance for data lakes.

## Architecture

1. **PostgreSQL**: Source database containing sensitive user data.
2. **RisingWave**: Stream processing engine for ingesting, masking, and transforming data.
3. **Python UDF**: Custom masking logic for various PII types (see `udf/udf.py`).
4. **Apache Iceberg**: Data lake storage for masked data.
5. **MinIO**: S3-compatible storage backend.
6. **Amoro**: Iceberg catalog service.
7. **StarRocks**: Analytics engine for querying Iceberg tables.

## Prerequisites

- Docker & Docker Compose installed
- Python 3.8+ (for UDF server)
- Ports 4566, 5432, 8091, 1630, 9000, 9001, 8030, 8040, 9030, 9500 available

## Step-by-Step Guide

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/implement-pii-mask-iceberg-using-risingwave.git
cd implement-pii-mask-iceberg-using-risingwave
```

### 2. Start All Services

```bash
docker-compose up -d
```

This will start PostgreSQL, RisingWave, MinIO, Amoro, StarRocks, and other required services.

### 3. Prepare the Python UDF Server

1. Install dependencies:

   ```bash
   pip install arrow-udf
   ```

2. Run the UDF server:

   ```bash
   python udf/udf.py
   ```

   > The UDF server exposes the masking function on port 8815.

### 4. Initialize PostgreSQL Data

- Insert sample data into the `users_sensitive_data` table in PostgreSQL (you can use a SQL client or script).

### 5. Create RisingWave Source, Table, and Masking Logic

1. Connect to RisingWave SQL shell:

   ```bash
   docker exec -it frontend-node-0 psql -h localhost -p 4566 -U root
   ```

2. Run the SQL scripts in `sql/pii.sql` to:
   - Create a source from PostgreSQL (CDC)
   - Create the `users_sensitive_data` table
   - Register the `mask_pii` UDF (update `<net-host>` to your host IP)
   - Create a materialized view with masked data
   - Create a sink to Iceberg

### 6. Query Masked Data in Iceberg

1. Connect to StarRocks:

   ```bash
   mysql -h 127.0.0.1 -P9030 -uroot
   ```

2. Run the SQL in `sql/starrocks.sql` to:
   - Register the Iceberg catalog
   - Query the masked data in the `users_sensitive_data_masking` table

## Example: Masking Function

The masking logic supports types like email, phone, address, name, passport, national_id, credit_card, ssn, and dob.

Example usage in Python:

```python
mask_pii("johndoe@example.com", "email")  # j*****e@example.com
mask_pii("+62 812-3456-7890", "phone")    # **********7890
```

## Notes

- Update the UDF server link in `sql/pii.sql` to match your host IP and port.
- Ensure the UDF server is running before creating the function in RisingWave.

## Cleanup

To stop and remove all containers:

```bash
docker-compose down -v
```

---

Feel free to adjust this README for your GitHub project!
