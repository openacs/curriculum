-- packages/curriculum/sql/postgresql/curriculum-curriculum-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$


create table cu_curriculums (
    curriculum_id		integer
                            constraint cu_curriculums_curriculum_id_fk
                            references acs_objects (object_id)
					on delete cascade
                            constraint cu_curriculums_curriculum_id_pk
                            primary key,
    name                    varchar(200)
                            constraint cu_curriculums_name_nn
                            not null,
    description             text,
    desc_format             varchar(200),
    owner_id                integer
                            constraint cu_curriculums_owner_id_nn
                            not null
				      -- owner can be any party, e.g., a group
					constraint cu_curriculums_owner_id_fk
					references parties (party_id),
    package_id              integer
                            constraint cu_curriculums_package_id_nn
                            not null
					constraint cu_curriculums_package_id_fk
					references apm_packages (package_id)
					on delete cascade,
    sort_key                integer
                            constraint cu_curriculums_sort_key_nn
                            not null
);

comment on table cu_curriculums is '
A package instance of Curriculum may contain any number of curriculums. However, only one package instance may be mounted per subsite (This limitation is less of a problem in dotLRN where every class, club, department, etc., is a subsite).
';

comment on column cu_curriculums.desc_format is '
Stores the format of the contents in the description column. The possible formats are defined in the richtext datatype in the form builder and may grow in number over time or change, which is why we do not bother to add a check constraint ...
';

create index cu_curriculums_package_id_idx on cu_curriculums(package_id);

select acs_object_type__create_type ( 
    'cu_curriculum',             -- object_type 
    'Curriculum',                -- pretty_name
    'Curriculums',               -- pretty_plural
    'acs_object',                -- supertype
    'cu_curriculums',            -- table_name
    'curriculum_id',             -- id_column
    'cu_curriculum',             -- package_name
    'f',                         -- abstract_p
    null,                        -- type_extension_table
    'cu_curriculum__name'        -- name_method
);
