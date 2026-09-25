-- Migration: professionals directory
-- Run in Supabase Dashboard > SQL Editor (or via service_role)

create table if not exists public.professionals (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  profession text not null check (profession in (
    'hvac','plumbing','electrical','roofing','impact-windows','pools',
    'pest-control','generators','landscaping','pressure-washing',
    'handyman','home-cleaning'
  )),
  city text not null,
  county text not null,
  zip_codes text[] not null default '{}',
  phone text not null,
  phone_display text not null,
  email text not null,
  photo text not null default '',
  rating numeric(2,1) not null default 5.0,
  reviews integer not null default 0,
  years_experience integer not null default 0,
  license text not null default '',
  languages text[] not null default '{EN}',
  emergency_24h boolean not null default false,
  about text not null default '',
  about_pt text,
  about_es text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists professionals_profession_idx on public.professionals (profession);
create index if not exists professionals_city_idx on public.professionals (city);
create index if not exists professionals_active_idx on public.professionals (is_active) where is_active = true;

alter table public.professionals enable row level security;

drop policy if exists "Public read active professionals" on public.professionals;
create policy "Public read active professionals"
  on public.professionals for select
  using (is_active = true);

-- Seed: the 12 mock professionals (re-runnable)
insert into public.professionals
  (slug, name, profession, city, county, zip_codes, phone, phone_display, email, photo, rating, reviews, years_experience, license, languages, emergency_24h, about, about_pt, about_es)
values
  ('carlos-mendoza','Carlos Mendoza','hvac','Miami','Miami-Dade','{33130,33132,33135}','13055550101','+1 (305) 555-0101','carlos.mendoza@homepro-services.com','https://i.pravatar.cc/400?img=12',4.9,214,12,'FL HVAC #CAC1823456','{EN,ES}',true,
   'Certified HVAC specialist with 12 years in South Florida heat and humidity. Install, repair and preventive maintenance.',
   'Especialista em HVAC com 12 anos no calor e umidade do Sul da Flórida. Instalação, reparo e manutenção preventiva.',
   'Especialista en HVAC con 12 años en el calor y la humedad del Sur de Florida. Instalación, reparación y mantenimiento.'),
  ('ana-paula-souza','Ana Paula Souza','plumbing','Homestead','Miami-Dade','{33030,33033,33034}','13055550102','+1 (305) 555-0102','ana.souza@homepro-services.com','https://i.pravatar.cc/400?img=47',5.0,186,9,'FL Plumber #CFC1432098','{EN,PT,ES}',true,
   'Licensed plumber serving Homestead and Florida City. Repairs, repipes and full installs with upfront pricing.',
   'Encanadora licenciada em Homestead e Florida City. Reparos, repipes e instalações completas com preço fechado.',
   'Plomera licenciada en Homestead y Florida City. Reparaciones, repipes e instalaciones completas con precio cerrado.'),
  ('james-carter','James Carter','electrical','Fort Lauderdale','Broward','{33301,33304,33308}','19545550103','+1 (954) 555-0103','j.carter@homepro-services.com','https://i.pravatar.cc/400?img=13',4.8,243,15,'FL Electrical #EC13009988','{EN}',true,
   'Certified electrician for panels, wiring, lighting and generator hookups. Code-compliant work, permitted and inspected.',
   'Eletricista certificado para quadros, fiação, iluminação e geradores. Trabalho dentro da norma, com permissão e inspeção.',
   'Electricista certificado para paneles, cableado, iluminación y generadores. Trabajo según norma, con permiso e inspección.'),
  ('rafael-torres','Rafael Torres','roofing','Hialeah','Miami-Dade','{33010,33012,33016}','13055550104','+1 (305) 555-0104','rafael.torres@homepro-services.com','https://i.pravatar.cc/400?img=59',4.9,178,14,'FL Roofing #CCC1334455','{EN,ES}',true,
   'Storm-ready roofing: repair and replacement with HVHZ-compliant materials and Miami-Dade NOA products.',
   'Telhados contra tempestades: reparo e substituição com materiais HVHZ e produtos com NOA Miami-Dade.',
   'Techos contra tormentas: reparación y reemplazo con materiales HVHZ y productos con NOA de Miami-Dade.'),
  ('lucia-fernandez','Lucía Fernández','impact-windows','Miami','Miami-Dade','{33128,33130,33142}','13055550105','+1 (305) 555-0105','lucia.fernandez@homepro-services.com','https://i.pravatar.cc/400?img=45',4.9,159,8,'FL Glazing #SCC1317788','{EN,ES}',false,
   'Impact windows and shutters supply and install. Hurricane protection with Florida Product Approval.',
   'Fornecimento e instalação de janelas de impacto e shutters. Proteção contra furacões com Florida Product Approval.',
   'Suministro e instalación de ventanas de impacto y shutters. Protección contra huracanes con Florida Product Approval.'),
  ('mike-thompson','Mike Thompson','pools','Orlando','Orange','{32801,32803,32806}','14075550106','+1 (407) 555-0106','mike.thompson@homepro-services.com','https://i.pravatar.cc/400?img=15',4.7,132,10,'FL Pool #CPC1462233','{EN}',false,
   'Pool install, remodel and weekly maintenance plans. Equipment repair, resurfacing and green-to-clean.',
   'Instalação, reforma e planos semanais de manutenção de piscinas. Reparo de equipamentos e green-to-clean.',
   'Instalación, remodelación y planes semanales de mantenimiento de piscinas. Reparación de equipos y green-to-clean.'),
  ('diego-ramirez','Diego Ramírez','pest-control','Florida City','Miami-Dade','{33034,33030,33170}','13055550107','+1 (305) 555-0107','diego.ramirez@homepro-services.com','https://i.pravatar.cc/400?img=53',4.8,201,7,'FL Pest #JF229911','{EN,ES}',false,
   'Safe, scheduled pest control for Florida climate. Pet-friendly treatments with quarterly plans.',
   'Controle de pragas seguro e programado para o clima da Flórida. Tratamentos pet-friendly com planos trimestrais.',
   'Control de plagas seguro y programado para el clima de Florida. Tratamientos pet-friendly con planes trimestrales.'),
  ('robert-wilson','Robert Wilson','generators','Tampa','Hillsborough','{33602,33605,33607}','18135550108','+1 (813) 555-0108','robert.wilson@homepro-services.com','https://i.pravatar.cc/400?img=51',4.9,147,11,'FL Electrical #EC13007744','{EN}',true,
   'Standby generator sales and install. Never without power during storm season — maintenance included.',
   'Venda e instalação de geradores standby. Nunca sem energia na temporada de tempestades — com manutenção.',
   'Venta e instalación de generadores standby. Nunca sin energía en temporada de tormentas — con mantenimiento.'),
  ('marcos-oliveira','Marcos Oliveira','landscaping','Homestead','Miami-Dade','{33030,33031,33034}','13055550109','+1 (305) 555-0109','marcos.oliveira@homepro-services.com','https://i.pravatar.cc/400?img=60',4.8,119,6,'FL Landscape #L18005522','{PT,ES,EN}',false,
   'Garden design and grounds maintenance. Mowing, trimming, mulch and native Florida landscaping.',
   'Design de jardins e manutenção de áreas. Corte, poda, mulch e paisagismo nativo da Flórida.',
   'Diseño de jardines y mantenimiento de áreas. Corte, poda, mulch y paisajismo nativo de Florida.'),
  ('sarah-johnson','Sarah Johnson','pressure-washing','Key West','Monroe','{33040,33041}','13055550110','+1 (305) 555-0110','sarah.johnson@homepro-services.com','https://i.pravatar.cc/400?img=44',4.9,98,5,'FL Insured Pro #PW883311','{EN}',false,
   'Exterior deep cleaning: driveways, roofs, siding and fences. Soft-wash safe for every surface.',
   'Limpeza externa profunda: calçadas, telhados, siding e cercas. Soft-wash seguro para cada superfície.',
   'Limpieza exterior profunda: calzadas, techos, siding y cercas. Soft-wash seguro para cada superficie.'),
  ('jose-santos','José Santos','handyman','Hialeah','Miami-Dade','{33010,33013,33018}','13055550111','+1 (305) 555-0111','jose.santos@homepro-services.com','https://i.pravatar.cc/400?img=61',4.8,167,13,'FL Handyman #HM774422','{ES,EN,PT}',false,
   'General repairs and fixes: drywall, painting touch-ups, doors, fixtures and small remodels.',
   'Reparos gerais: drywall, retoques de pintura, portas, louças e pequenas reformas.',
   'Reparaciones generales: drywall, retoques de pintura, puertas, accesorios y pequeñas remodelaciones.'),
  ('camila-rocha','Camila Rocha','home-cleaning','Miami','Miami-Dade','{33125,33130,33135}','13055550112','+1 (305) 555-0112','camila.rocha@homepro-services.com','https://i.pravatar.cc/400?img=48',5.0,229,6,'FL Insured Pro #CL665544','{PT,EN,ES}',false,
   'Recurring residential cleaning with background-checked team. Deep cleans, move-in/out and Airbnb turnover.',
   'Limpeza residencial recorrente com equipe verificada. Limpeza profunda, pré/pós-mudança e turnover de Airbnb.',
   'Limpieza residencial recurrente con equipo verificado. Limpieza profunda, mudanzas y recambio de Airbnb.')
on conflict (slug) do nothing;
