-- ============================================================
-- add-travel-columns.sql — أعمدة قائمة متابعة المبتعثين
-- شغّله بالـ Supabase SQL Editor إذا قاعدة بياناتك ما فيها هذي الأعمدة بعد
-- ============================================================
ALTER TABLE study_nominations ADD COLUMN IF NOT EXISTS travel_date DATE;
ALTER TABLE study_nominations ADD COLUMN IF NOT EXISTS return_date DATE;
ALTER TABLE study_nominations ADD COLUMN IF NOT EXISTS extension_date DATE;
