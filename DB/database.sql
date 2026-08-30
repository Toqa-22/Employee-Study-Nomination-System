-- ============================================================
-- database.sql — Supabase Complete Setup
-- نظام ترشيح الدراسات العليا والبعثات
-- ============================================================
-- HOW TO RUN:
--   Supabase Dashboard -> SQL Editor -> New Query -> Paste all -> Run
--   Safe to re-run: uses IF NOT EXISTS + DELETE before INSERT
-- ============================================================


-- ============================================================
-- 1. TABLE: study_nominations
-- ============================================================
CREATE TABLE IF NOT EXISTS study_nominations (
  id                            BIGSERIAL PRIMARY KEY,
  created_at                    TIMESTAMPTZ DEFAULT NOW(),

  -- Section 1: Personal & Job Info
  full_name                     TEXT,
  job_number                    TEXT,
  job_title                     TEXT,
  hiring_date                   DATE,
  work_directorate              TEXT,
  work_department               TEXT,
  performance_rating            TEXT,
  financial_degree              TEXT,
  civil_id                      TEXT,
  passport_number               TEXT,
  birth_date                    DATE,
  marital_status                TEXT,
  permanent_address_governorate TEXT,
  address_willayat              TEXT,
  email                         TEXT,
  mobile_number                 TEXT,
  specialty_experience_date     DATE,

  -- Section 2: Previous Study
  last_qualification            TEXT,
  qualification_year            TEXT,
  study_country_prev            TEXT,
  specialization_prev           TEXT,
  funding_entity_prev           TEXT,
  study_entity_prev             TEXT,

  -- Section 3: Required Study
  qualification_req             TEXT,
  general_specialization        TEXT,
  sub_specialization            TEXT,
  study_country_req             TEXT,
  study_entity_req              TEXT,
  study_system                  TEXT,
  start_date                    DATE,
  end_date                      DATE,
  funding_entity_req            TEXT,
  admission_type                TEXT,

  -- Section 4 & 5: Long Text
  tasks_performed                TEXT,
  plan_after_return             TEXT,

  -- Attachments (Supabase Storage public URLs)
  attach_id_card                TEXT,
  attach_ielts                  TEXT,
  attach_admission              TEXT,
  attach_recommendation         TEXT,
  attach_pledge_letter          TEXT,

  -- Overall Status: 'pending' | 'accepted' | 'rejected'
  status                         TEXT DEFAULT 'pending',

  -- Nursing Admin Decision
  nursing_status                 TEXT,
  nursing_comment                TEXT,
  nursing_admin                  TEXT,
  nursing_role                   TEXT,
  nursing_reviewer_name          TEXT,

  -- Other Dept Admin Decision
  other_status                   TEXT,
  other_comment                  TEXT,
  other_admin                    TEXT,
  other_role                     TEXT,
  other_reviewer_name            TEXT,

  -- Extra Info: Excel 1 - فرز الطلبات
  extra_gpa                      NUMERIC(5,2),
  extra_admission                TEXT,
  extra_pledge1                  TEXT,
  extra_pledge                   TEXT,
  extra_istifa                   TEXT,
  extra_reason                   TEXT,
  extra_final_grade              NUMERIC(5,2),
  extra_rank                     INTEGER,

  -- Extra Info: Excel 2 - التقييم النهائي
  extra_perf_level               TEXT,
  extra_perf_pct                 NUMERIC(5,2),
  extra_int1                     NUMERIC(5,2),
  extra_int2                     NUMERIC(5,2),
  extra_int3                     NUMERIC(5,2),
  extra_int4                     NUMERIC(5,2),
  extra_notes                    TEXT,

  -- قائمة متابعة المبتعثين
  travel_date                    DATE,   -- تاريخ الذهاب
  return_date                    DATE,   -- تاريخ العودة
  extension_date                 DATE    -- تاريخ تمديد
);


-- ============================================================
-- 2. TABLE: admin_users
-- ============================================================
CREATE TABLE IF NOT EXISTS admin_users (
  id           BIGSERIAL PRIMARY KEY,
  username     TEXT UNIQUE NOT NULL,
  password     TEXT NOT NULL,
  role         TEXT NOT NULL,
  display_name TEXT
);


-- ============================================================
-- 3. DISABLE ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE study_nominations DISABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users        DISABLE ROW LEVEL SECURITY;


-- ============================================================
-- 4. SEED: Admin Accounts
--    Change passwords before going live!
-- ============================================================
DELETE FROM admin_users;

INSERT INTO admin_users (username, password, role, display_name) VALUES
  ('nr_dghs_admin',  '123456', 'nursing_dir',  'مدير التمريض - المديرية'),
  ('nr_hosp_admin',  '123456', 'nursing_hosp', 'مدير التمريض - المستشفى'),
  ('dr_dghs_admin',  '123456', 'other_dir',    'مدير الدوائر الاخرى - المديرية'),
  ('dr_hosp_admin',  '123456', 'other_hosp',   'مدير الدوائر الاخرى - المستشفى'),
  ('super_admin',    '123456', 'full',         'المشرف العام');


-- ============================================================
-- 5. STORAGE POLICIES for 'attachments' bucket
--    Run AFTER creating the bucket in Supabase Dashboard
-- ============================================================
DROP POLICY IF EXISTS "allow_anon_upload" ON storage.objects;
DROP POLICY IF EXISTS "allow_anon_select" ON storage.objects;
DROP POLICY IF EXISTS "allow_anon_delete" ON storage.objects;

CREATE POLICY "allow_anon_upload"
  ON storage.objects FOR INSERT TO anon
  WITH CHECK (bucket_id = 'attachments');

CREATE POLICY "allow_anon_select"
  ON storage.objects FOR SELECT TO anon
  USING (bucket_id = 'attachments');

CREATE POLICY "allow_anon_delete"
  ON storage.objects FOR DELETE TO anon
  USING (bucket_id = 'attachments');

-- STORAGE BUCKET: create manually in Supabase Dashboard
--   Storage -> New Bucket
--   Name          : attachments
--   Public bucket : YES (required)
--   File size     : 5 MB
--   Allowed MIME  : image/jpeg, image/png, image/webp, application/pdf


-- ============================================================
-- 6. VERIFY: run to confirm setup is correct
-- ============================================================
SELECT 'Total columns in study_nominations' AS info,
       COUNT(*) AS count
FROM information_schema.columns
WHERE table_name = 'study_nominations';

SELECT username, role, display_name FROM admin_users ORDER BY id;
