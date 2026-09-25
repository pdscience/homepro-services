-- Approve a professional application into the public directory.
-- Steps: 1) run the PENDING query, 2) paste the id below, 3) run the APPROVE block.

-- 1) List pending applications -------------------------------------------
select id, name, profession, city, zip_code, phone, email, created_at
from public.professional_applications
where status = 'pending'
order by created_at desc;

-- 2) Approve (replace THE_APPLICATION_ID) --------------------------------
-- Copies the application into public.professionals with safe defaults,
-- then marks the application as approved. Safe to re-run: slug is unique
-- per application (name + first 8 chars of the application id).

-- \set app_id 'THE_APPLICATION_ID'

with app as (
  select * from public.professional_applications
  where id = '9423ba2a-9df4-4b44-84d7-098fc653c64b'  -- << paste the id here
)
insert into public.professionals
  (slug, name, profession, city, county, zip_codes, phone, phone_display,
   email, photo, rating, reviews, years_experience, license, languages,
   emergency_24h, about, is_active)
select
  trim(both '-' from regexp_replace(lower(a.name), '[^a-z0-9]+', '-', 'g'))
    || '-' || substr(a.id::text, 1, 8),
  a.name,
  a.profession,
  nullif(a.city, ''),
  case a.city
    when 'Fort Lauderdale' then 'Broward'
    when 'Orlando' then 'Orange'
    when 'Tampa' then 'Hillsborough'
    when 'Key West' then 'Monroe'
    else 'Miami-Dade'  -- Miami, Hialeah, Homestead, Florida City + unknown
  end,
  case when a.zip_code <> '' then array[a.zip_code] else '{}' end,
  a.phone,
  a.phone,
  a.email,
  coalesce(nullif(a.photo_url, ''),
    'https://ui-avatars.com/api/?name=' || replace(a.name, ' ', '+')
    || '&size=400&background=e3062f&color=fff'),
  5.0,
  0,
  coalesce(a.years_experience, 0),
  a.license,
  '{EN}',
  false,
  a.about,
  true
from app a
on conflict (slug) do nothing;

update public.professional_applications
set status = 'approved'
where id = '9423ba2a-9df4-4b44-84d7-098fc653c64b';  -- << same id here

-- 3) Confirm ---------------------------------------------------------------
-- select slug, name, profession, city from public.professionals
-- order by created_at desc limit 5;
--
-- Then refresh /profissionais (dev) or rebuild (npm run build) to publish.
-- Tip: edit photo, languages, rating and about_pt/about_es directly in the
-- Table Editor on public.professionals afterwards.
