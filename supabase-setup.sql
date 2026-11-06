-- Ejecutar una sola vez en Supabase > SQL Editor.
create table if not exists public.libraries (
  user_id uuid primary key references auth.users(id) on delete cascade,
  books jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.libraries enable row level security;
revoke all on table public.libraries from anon, authenticated;
grant select, insert, update on table public.libraries to authenticated;
drop policy if exists "Each user can read own library" on public.libraries;
create policy "Each user can read own library" on public.libraries
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Each user can insert own library" on public.libraries;
create policy "Each user can insert own library" on public.libraries
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Each user can update own library" on public.libraries;
create policy "Each user can update own library" on public.libraries
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- Habilita avisos en vivo para que los otros dispositivos reciban cambios al instante.
alter publication supabase_realtime add table public.libraries;


