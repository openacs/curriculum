-- packages/curriculum/sql/postgresql/curriculum-element-create.sql
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
    description                    text,
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
    enabled_p                      character(1)
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

select acs_object_type__create_type ( 
    'cu_element',                -- object_type 
    'Curriculum Element',        -- pretty_name
    'Curriculum Elements',       -- pretty_plural
    'acs_object',                -- supertype
    'cu_elements',               -- table_name
    'element_id',                -- id_column
    'cu_element',                -- package_name
    'f',                         -- abstract_p
    null,                        -- type_extension_table
    'cu_element__name'           -- name_method
);
