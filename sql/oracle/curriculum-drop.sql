-- packages/curriculum/sql/oracle/curriculum-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

-- Drop the mapping table.
drop table cu_user_element_map;

-- Drop the cu_element object.
@ curriculum-element-drop.sql
@ curriculum-element-package-drop.sql

-- Drop the cu_curriculum object.
@ curriculum-curriculum-drop.sql
@ curriculum-curriculum-package-drop.sql
