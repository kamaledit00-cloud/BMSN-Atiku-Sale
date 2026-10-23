create table lgas(id bigserial primary key,name text not null unique,state text not null default 'Zamfara State',official_reference_code text);
create table wards(id bigserial primary key,lga_id bigint not null references lgas(id),name text not null,official_reference_code text,unique(lga_id,name));
create table polling_units(id bigserial primary key,ward_id bigint not null references wards(id),name text not null,official_reference_code text unique,location_reference text);
create index on wards(lga_id);create index on polling_units(ward_id);
create table admins(id bigserial primary key,name text not null,email text not null unique,password_hash text not null,role text not null default 'registration_admin' check(role in('super_admin','registration_admin','read_only_auditor')),is_active boolean not null default true,created_at timestamptz not null default now());
create sequence membership_seq;
create function next_membership_number() returns text language sql as $$ select 'BMSN-ZM-'||extract(year from now())::int||'-'||lpad(nextval('membership_seq')::text,6,'0') $$;
create table members(id bigserial primary key,membership_number text not null unique default next_membership_number(),full_name text not null,gender text not null check(gender in('Male','Female')),state text not null default 'Zamfara State' check(state='Zamfara State'),
lga_id bigint not null references lgas(id),ward_id bigint not null references wards(id),polling_unit_id bigint not null references polling_units(id),
primary_phone text not null unique,alternative_phone text,membership_status text not null default 'Pending' check(membership_status in('Pending','Approved','Rejected','Suspended','Revoked')),
consent_timestamp timestamptz not null,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),reviewed_at timestamptz,reviewed_by bigint references admins(id),check(alternative_phone is distinct from primary_phone));
create index on members(lga_id);create index on members(ward_id);create index on members(polling_unit_id);create index on members(membership_status);create index on members(full_name);
create table registration_consents(id bigserial primary key,member_id bigint not null references members(id),privacy_notice_version text not null,consent_timestamp timestamptz not null);
create table audit_logs(id bigserial primary key,admin_id bigint references admins(id),action text not null,affected_record_id text,timestamp timestamptz not null default now(),relevant_change_summary text);
-- All access goes through the server with the service-role key. Deny everything to anon/browser clients:
alter table lgas enable row level security;alter table wards enable row level security;alter table polling_units enable row level security;alter table admins enable row level security;alter table members enable row level security;alter table registration_consents enable row level security;alter table audit_logs enable row level security;
