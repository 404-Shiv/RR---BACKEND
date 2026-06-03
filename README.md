# RupeeRadar - Backend

This repository contains the backend database schema and security rules for the **RupeeRadar** application. 

Since RupeeRadar uses **Supabase** as its Backend-as-a-Service (BaaS), the entire backend configuration is written in SQL.

## Getting Started

To deploy this backend to your own Supabase instance:

1. Create a new project on [Supabase](https://supabase.com).
2. Navigate to the **SQL Editor** in your Supabase dashboard.
3. Open the `schema.sql` file from this repository.
4. Copy all the contents and run it in the SQL Editor.

## What's Included in `schema.sql`

- **Tables**: `users`, `assets`, `liabilities`, `goals`, `income`, `expenses`, `snapshots`, `essentials`.
- **Row Level Security (RLS)**: Enforces data isolation so users can only access their own data.
- **Triggers**: Auto-creates a `users` table profile whenever a new user signs up via Supabase Auth.
