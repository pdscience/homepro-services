-- Professional photo uploads: column + public storage bucket.
-- Run in Supabase Dashboard > SQL Editor.

alter table public.professional_applications
  add column if not exists photo_url text;

insert into storage.buckets (id, name, public)
values ('professional-photos', 'professional-photos', true)
on conflict (id) do update set public = true;

drop policy if exists "Public read professional photos" on storage.objects;
create policy "Public read professional photos"
  on storage.objects for select
  using (bucket_id = 'professional-photos');

drop policy if exists "Public upload professional photos" on storage.objects;
create policy "Public upload professional photos"
  on storage.objects for insert
  with check (bucket_id = 'professional-photos');
