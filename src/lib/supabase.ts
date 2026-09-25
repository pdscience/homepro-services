import { createClient } from "@supabase/supabase-js";

/** Lazily creates the client. Returns null (with a warning) when env is
 *  missing — e.g. dev server started before .env existed — so pages can
 *  fall back to local data instead of crashing. */
export function getSupabase() {
  // PUBLIC_* is inlined into browser bundles; VITE_* is available at build time.
  const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL ?? import.meta.env.VITE_SUPABASE_URL;
  const supabaseKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY ?? import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

  if (!supabaseUrl || !supabaseKey) {
    console.warn(
      "Supabase env missing (PUBLIC_SUPABASE_URL / PUBLIC_SUPABASE_ANON_KEY). Using fallback data — restart the dev server after creating .env."
    );
    return null;
  }

  return createClient(supabaseUrl, supabaseKey);
}

/** Row shape of public.professionals */
export interface ProfessionalRow {
  id: string;
  slug: string;
  name: string;
  profession: string;
  city: string;
  county: string;
  zip_codes: string[];
  phone: string;
  phone_display: string;
  email: string;
  photo: string;
  rating: number;
  reviews: number;
  years_experience: number;
  license: string;
  languages: string[];
  emergency_24h: boolean;
  about: string;
  about_pt: string | null;
  about_es: string | null;
  is_active: boolean;
}
