-- packages/curriculum/sql/oracle/curriculum-element-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

create table cu_elements (
    element_id                     integer
                                   constraint cu_elements_element_id_fk
                                   references acs_objects (object_id)
                                   on delete cascade						
                                   constraint cu_elements_element_id_pk
                                   primary key,
    curriculum_id                  integer
                                   constraint cu_elements_curriculum_id_fk
                                   references cu_curriculums (curriculum_id)
                                   on delete cascade
                                   constraint cu_elements_curriculum_id_nn
                                   not null,
    name                           varchar(200)
                                   constraint cu_elements_name_nn
                                   not null,
    description                    clob,
    desc_format                    varchar(200),
    url                            varchar(400)
                                   constraint cu_elements_url_nn
                                   not null,
    external_p                     char(1)
                                   default 'f'
                                   constraint cu_elements_external_p_nn
                                   not null
                                   constraint cu_elements_external_p_ck
                                   check (external_p in ('t','f')),
    enabled_p                      char(1)
                                   default 't'
                                   constraint cu_elements_enabled_p_nn
                                   not null
                                   constraint cu_elements_enabled_p_ck
                                   check (enabled_p in ('t','f')),
    sort_key                       integer
                                   constraint cu_elements_sort_key_nn
                                   not null
);

comment on table cu_elements is '
An element is a pointer to a piece of content, local or external, that is part of a certain curriculum.
';

comment on column cu_elements.sort_key is '
The relative position the element has within the curriculum.
';

create index cu_elements_curriculum_id_idx on cu_elements(curriculum_id);

create view cu_elements_enabled
as
    select ce.*, cc.package_id
    from   cu_elements ce,
		cu_curriculums cc
    where  ce.curriculum_id = cc.curriculum_id
    and    ce.enabled_p = 't';

declare
begin
    acs_object_type.create_type (
        supertype 	=> 'acs_object',
        object_type 	=> 'cu_element',
        pretty_name 	=> 'Curriculum Element',
        pretty_plural	=> 'Curriculum Elements',
        table_name 	=> 'cu_elements',
        id_column 	=> 'element_id',
        package_name 	=> 'cu_element',
        name_method 	=> 'cu_element.name'
    );
end;
/
show errors
