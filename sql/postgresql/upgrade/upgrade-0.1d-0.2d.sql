-- Upgrade script: Do the right thing when no context_id is provided
-- with the curriculum and element *new* functions, by using coalesce().
-- The Oracle equivalent was already using nvl().
--
-- Since we are using *create or replace* everywhere, it is perfectly
-- alright to simply rerun the two scripts involved.

\i curriculum-curriculum-package-create.sql
\i curriculum-element-package-create.sql
