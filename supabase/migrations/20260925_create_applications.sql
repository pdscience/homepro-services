-- Migration: professional applications (signup with admin approval)
-- Run in Supabase Dashboard > SQL Editor (or via service_role)

create table if not exists public.professional_applications (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  profession text not null check (profession in (
    'hvac','plumbing','electrical','roofing','impact-windows','pools',
    'pest-control','generators','landscaping','pressure-washing',
    'handyman','home-cleaning'
  )),
  city text not null default '',
  zip_code text not null default '',
  phone text not null,
  email text not null,
  license text not null default '',
  years_experience integer,
  about text not null default '',
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

create index if not exists applications_status_idx on public.professional_applications (status);
create index if not exists applications_created_idx on public.professional_applications (created_at desc);

alter table public.professional_applications enable row level security;

-- Anyone can apply; only authenticated/service_role can read (dashboard review).
-- No public SELECT policy on purpose: applications stay private until approved.
drop policy if exists "Public insert applications" on public.professional_applications;
create policy "Public insert applications"
  on public.professional_applications for insert
  with check (true);
