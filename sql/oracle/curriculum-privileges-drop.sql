-- packages/curriculum/sql/oracle/curriculum-privileges-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

declare
begin
    -- remove children
    acs_privilege.remove_child('read','curriculum_read');
    acs_privilege.remove_child('create','curriculum_create');
    acs_privilege.remove_child('write','curriculum_write');
    acs_privilege.remove_child('delete','curriculum_delete');
    acs_privilege.remove_child('admin','curriculum_admin');
    acs_privilege.remove_child('curriculum_admin','curriculum_read');
    acs_privilege.remove_child('curriculum_write','curriculum_read');
    
    acs_privilege.drop_privilege('curriculum_admin');
    acs_privilege.drop_privilege('curriculum_read');
    acs_privilege.drop_privilege('curriculum_create');
    acs_privilege.drop_privilege('curriculum_write');
    acs_privilege.drop_privilege('curriculum_delete');
end;
/
show errors
