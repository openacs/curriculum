-- packages/curriculum/sql/postgresql/curriculum-element-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

drop view cu_elements_enabled;
drop table cu_elements;

-- Had to add this in order to cleanly drop the package when
-- there were elements created in the db.
delete from acs_objects where object_type = 'cu_element';

select acs_object_type__drop_type (
    'cu_element', 'f'
);
