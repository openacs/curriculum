-- packages/curriculum/sql/postgresql/curriculum-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

-- Drop default assignees table.
drop table cu_default_assignees;

-- Drop the mapping tables.
drop table cu_user_curriculum_map;
drop table cu_user_element_map;

-- Drop the cu_element object.
\i curriculum-element-drop.sql
\i curriculum-element-package-drop.sql

-- Drop the cu_curriculum object.
\i curriculum-curriculum-drop.sql
\i curriculum-curriculum-package-drop.sql
