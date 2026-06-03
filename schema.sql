-- ============================================================
-- RupeeRadar - Supabase Schema
-- Run this in the Supabase SQL Editor to set up all tables
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================
-- TABLES
-- ============================================================

-- Users table (extends auth.users)
create table public.users (
  id uuid references auth.users(id) on delete cascade primary key,
  email text,
  name text,
  user_type text check (user_type in ('student', 'professional', 'adult', 'senior')),
  phone text,
  dob date,
  monthly_income numeric default 0,
  profile_data jsonb default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Assets table
create table public.assets (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  name text not null,
  category text not null,
  quantity numeric default 1,
  purchase_price numeric default 0,
  current_value numeric default 0,
  currency text default 'INR',
  purchase_date date,
  notes text,
  created_at timestamptz default now()
);

-- Liabilities table
create table public.liabilities (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  type text not null,
  lender text,
  principal numeric default 0,
  outstanding numeric default 0,
  emi numeric default 0,
  interest_rate numeric default 0,
  start_date date,
  end_date date,
  created_at timestamptz default now()
);

-- Goals table
create table public.goals (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  name text not null,
  target_amount numeric default 0,
  current_amount numeric default 0,
  target_date date,
  status text default 'on-track',
  linked_assets uuid[] default '{}',
  created_at timestamptz default now()
);

-- Income table
create table public.income (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  source text,
  category text not null,
  amount numeric default 0,
  date date default current_date,
  currency text default 'INR',
  notes text,
  created_at timestamptz default now()
);

-- Expenses table
create table public.expenses (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  category text not null,
  amount numeric default 0,
  date date default current_date,
  notes text,
  created_at timestamptz default now()
);

-- Snapshots table
create table public.snapshots (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  date timestamptz default now(),
  net_worth numeric default 0,
  assets_json jsonb default '[]',
  liabilities_json jsonb default '[]',
  created_at timestamptz default now()
);

-- Essentials table
create table public.essentials (
  id uuid default uuid_generate_v4() primary key,
  profile_id uuid references public.users(id) on delete cascade not null,
  name text not null,
  rule text,
  status text default 'not-set' check (status in ('good', 'review', 'not-set')),
  detail text,
  progress numeric default 0,
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Enable RLS on ALL tables
alter table public.users enable row level security;
alter table public.assets enable row level security;
alter table public.liabilities enable row level security;
alter table public.goals enable row level security;
alter table public.income enable row level security;
alter table public.expenses enable row level security;
alter table public.snapshots enable row level security;
alter table public.essentials enable row level security;

-- ============================================================
-- RLS POLICIES
-- ============================================================

-- Users table
create policy "Users can view own profile" on public.users
  for select using (auth.uid() = id);
create policy "Users can update own profile" on public.users
  for update using (auth.uid() = id);
create policy "Users can insert own profile" on public.users
  for insert with check (auth.uid() = id);

-- Assets table
create policy "Users can view own assets" on public.assets
  for select using (auth.uid() = profile_id);
create policy "Users can insert own assets" on public.assets
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own assets" on public.assets
  for update using (auth.uid() = profile_id);
create policy "Users can delete own assets" on public.assets
  for delete using (auth.uid() = profile_id);

-- Liabilities table
create policy "Users can view own liabilities" on public.liabilities
  for select using (auth.uid() = profile_id);
create policy "Users can insert own liabilities" on public.liabilities
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own liabilities" on public.liabilities
  for update using (auth.uid() = profile_id);
create policy "Users can delete own liabilities" on public.liabilities
  for delete using (auth.uid() = profile_id);

-- Goals table
create policy "Users can view own goals" on public.goals
  for select using (auth.uid() = profile_id);
create policy "Users can insert own goals" on public.goals
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own goals" on public.goals
  for update using (auth.uid() = profile_id);
create policy "Users can delete own goals" on public.goals
  for delete using (auth.uid() = profile_id);

-- Income table
create policy "Users can view own income" on public.income
  for select using (auth.uid() = profile_id);
create policy "Users can insert own income" on public.income
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own income" on public.income
  for update using (auth.uid() = profile_id);
create policy "Users can delete own income" on public.income
  for delete using (auth.uid() = profile_id);

-- Expenses table
create policy "Users can view own expenses" on public.expenses
  for select using (auth.uid() = profile_id);
create policy "Users can insert own expenses" on public.expenses
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own expenses" on public.expenses
  for update using (auth.uid() = profile_id);
create policy "Users can delete own expenses" on public.expenses
  for delete using (auth.uid() = profile_id);

-- Snapshots table
create policy "Users can view own snapshots" on public.snapshots
  for select using (auth.uid() = profile_id);
create policy "Users can insert own snapshots" on public.snapshots
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own snapshots" on public.snapshots
  for update using (auth.uid() = profile_id);
create policy "Users can delete own snapshots" on public.snapshots
  for delete using (auth.uid() = profile_id);

-- Essentials table
create policy "Users can view own essentials" on public.essentials
  for select using (auth.uid() = profile_id);
create policy "Users can insert own essentials" on public.essentials
  for insert with check (auth.uid() = profile_id);
create policy "Users can update own essentials" on public.essentials
  for update using (auth.uid() = profile_id);
create policy "Users can delete own essentials" on public.essentials
  for delete using (auth.uid() = profile_id);

-- ============================================================
-- TRIGGER: Auto-create user profile on sign up
-- ============================================================

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
