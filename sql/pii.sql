CREATE SOURCE pg_source WITH (
    connector='postgres-cdc',
    hostname='postgres-vendor-0',
    port='5432',
    username='postgres',
    password='postgres',
    database.name='postgres',
    schema.name='public',
    slot.name = 'rising_wave',
    publication.name ='rw_publication'
);

CREATE TABLE users_sensitive_data (
    id INT PRIMARY KEY,
    email VARCHAR,
    phone VARCHAR,
    full_name VARCHAR,
    address VARCHAR,
    passport_number VARCHAR,
    national_id VARCHAR,
    credit_card_number VARCHAR,
    ssn VARCHAR,
    date_of_birth DATE,
    created_at TIMESTAMP 
) FROM pg_source TABLE 'public.users_sensitive_data';

-- Create a function to mask PII data
CREATE FUNCTION mask_pii(VARCHAR, VARCHAR) RETURNS VARCHAR
AS mask_pii USING LINK 'http://<net-host>:8815';

-- Create a materialized view to mask PII data
create materialized view users_sensitive_data_masking as 
select 
	id,
	mask_pii(email, 'email') as "email",
	mask_pii(phone, 'phone') as "phone",
	mask_pii(full_name, 'name') as "full_name",
	mask_pii(address, 'address') as "address",
	mask_pii(passport_number, 'passport') as "passport_number",
	mask_pii(national_id, 'national_id') as "national_id",
	mask_pii(credit_card_number, 'credit_card') as "credit_card_number",
	mask_pii(ssn, 'ssn') as "ssn",
	mask_pii(cast(date_of_birth as VARCHAR), 'dob') as "date_of_birth"
from users_sensitive_data

select * from users_sensitive_data_masking

-- Create Iceberg Sink
CREATE SINK sink_users_sensitive_data_masking FROM users_sensitive_data_masking
WITH (
    connector = 'iceberg',
    type = 'upsert',
    primary_key = 'id',
    s3.endpoint = 'http://minio:9000',
    s3.region = 'us-east-1',
    s3.access.key = 'admin',
    s3.secret.key = 'password',
    s3.path.style.access = 'true',
    catalog.type = 'rest',
    catalog.uri = 'http://amoro:1630/api/iceberg/rest',
    catalag.name = 'icelake',
    warehouse.path = 'icelake',
    database.name = 'warehouse',
    table.name = 'users_sensitive_data_masking',
    create_table_if_not_exists = TRUE
);