-- packages/curriculum/sql/oracle/curriculum-privileges-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

declare
begin
    acs_privilege.create_privilege('curriculum_create',null,null);
    acs_privilege.create_privilege('curriculum_write',null,null);
    acs_privilege.create_privilege('curriculum_delete',null,null);
    acs_privilege.create_privilege('curriculum_read',null,null);
    acs_privilege.create_privilege('curriculum_admin',null,null);

    -- add children
    acs_privilege.add_child('create','curriculum_create');
    acs_privilege.add_child('write','curriculum_write');
    acs_privilege.add_child('delete','curriculum_delete');
    acs_privilege.add_child('read','curriculum_read');
    acs_privilege.add_child('admin','curriculum_admin');
    acs_privilege.add_child('curriculum_admin','curriculum_read');
    acs_privilege.add_child('curriculum_write','curriculum_read');
end;
/
show errors
