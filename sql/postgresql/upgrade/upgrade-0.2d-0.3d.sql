-- Upgrade script: Add columns external_p and subsite_external_p to cu_elements.

ALTER TABLE cu_elements ADD COLUMN external_p char(1) constraint cu_elements_external_p_ck CHECK (external_p in ('t','f'));

ALTER TABLE cu_elements ALTER COLUMN external_p SET DEFAULT 'f';

UPDATE cu_elements
SET    external_p = case when substring(url from 1 for 7) = 'http://'
                    then 't' else 'f' end;

ALTER TABLE cu_elements ALTER COLUMN external_p SET NOT NULL;

\i curriculum-element-package-create.sql
