-- packages/curriculum/sql/postgresql/curriculum-privileges-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

begin;
    select acs_privilege__create_privilege('curriculum_create',null,null);
    select acs_privilege__create_privilege('curriculum_write',null,null);
    select acs_privilege__create_privilege('curriculum_delete',null,null);
    select acs_privilege__create_privilege('curriculum_read',null,null);
    select acs_privilege__create_privilege('curriculum_admin',null,null);

    -- add children
    select acs_privilege__add_child('create','curriculum_create');
    select acs_privilege__add_child('write','curriculum_write');
    select acs_privilege__add_child('delete','curriculum_delete');
    select acs_privilege__add_child('read','curriculum_read');
    select acs_privilege__add_child('admin','curriculum_admin');
    select acs_privilege__add_child('curriculum_admin','curriculum_read');
    select acs_privilege__add_child('curriculum_write','curriculum_read');
end;
