-- packages/curriculum/sql/oracle/curriculum-curriculum-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

drop table cu_curriculums;

-- Had to add this in order to cleanly drop the package when there
-- were curriculums created in the db.
delete from acs_objects where object_type = 'cu_curriculum';

declare
begin
    acs_object_type.drop_type (
        object_type => 'cu_curriculum'
    );
end;
/
show errors
