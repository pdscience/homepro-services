-- Admin access control for the /admin panel.
-- Run in Supabase Dashboard > SQL Editor.
--
-- Afterwards:
--   1) Dashboard > Authentication > Users > "Add user" (email + password)
--   2) Copy the new user's UUID and run:
--        insert into public.admins (user_id) values ('USER_UUID_HERE');
--   3) Recommended: Authentication > Sign In / Providers > Email >
--      turn OFF "Allow new users to sign up".

create table if not exists public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;
-- No policies on admins on purpose: only service_role (SQL editor)
-- manages it. Admin checks go through the function below.

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

grant execute on function public.is_admin() to anon, authenticated;

-- Applications: admins can read + update (approve/reject)
drop policy if exists "Admin read applications" on public.professional_applications;
create policy "Admin read applications"
  on public.professional_applications for select
  to authenticated
  using (public.is_admin());

drop policy if exists "Admin update applications" on public.professional_applications;
create policy "Admin update applications"
  on public.professional_applications for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Directory: admins can insert + update professionals
drop policy if exists "Admin insert professionals" on public.professionals;
create policy "Admin insert professionals"
  on public.professionals for insert
  to authenticated
  with check (public.is_admin());

drop policy if exists "Admin update professionals" on public.professionals;
create policy "Admin update professionals"
  on public.professionals for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());
