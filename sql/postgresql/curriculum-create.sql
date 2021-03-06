-- packages/curriculum/sql/postgresql/curriculum-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

\i curriculum-curriculum-create.sql
\i curriculum-element-create.sql
\i curriculum-element-package-create.sql
\i curriculum-curriculum-package-create.sql


create table cu_user_element_map (
    user_id           integer
                      constraint cu_user_element_map_user_id_nn
                      not null
                      constraint cu_user_element_map_user_id_fk
                      references users
                      on delete cascade,
    element_id        integer
                      constraint cu_user_element_map_element_id_nn
                      not null
                      constraint cu_user_element_map_elemen_id_fk
                      references cu_elements
                      on delete cascade,
    curriculum_id     integer
                      constraint cu_user_element_map_curriculum_id_nn
                      not null
                      constraint cu_user_element_map_curriculum_id_fk
                      references cu_curriculums
                      on delete cascade,
    package_id        integer
                      constraint cu_user_element_map_package_id_nn
                      not null
                      constraint cu_user_element_map_package_id_fk
                      references apm_packages
                      on delete cascade,
    completion_date   timestamptz
                      default current_timestamp
                      constraint cu_user_element_map_completion_date_nn
                      not null,
    constraint cu_user_element_map_pk	
    primary key (user_id, element_id)
);

comment on table cu_user_element_map is '
Keep track of which elements a particular user has seen so that we can check the element in the curriculum bar and mark it visited.
';

comment on column cu_user_element_map.curriculum_id is '
We use this column mainly to be able to clear/uncheck a single curriculum bar in a package instance.
';

comment on column cu_user_element_map.package_id is '
We use this column mainly to be able to clear/uncheck all the curriculum bars in a package instance.
';


create table cu_user_curriculum_map (
    user_id           integer
                      constraint cu_user_curriculum_map_user_id_nn
                      not null
                      constraint cu_user_curriculum_map_user_id_fk
                      references users
                      on delete cascade,
    curriculum_id     integer
                      constraint cu_user_curriculum_map_curriculum_id_nn
                      not null
                      constraint cu_user_curriculum_map_curriculum_id_fk
                      references cu_curriculums
                      on delete cascade,
    package_id        integer
                      constraint cu_user_curriculum_map_package_id_nn
                      not null
                      constraint cu_user_curriculum_map_package_id_fk
                      references apm_packages
                      on delete cascade,
    constraint cu_user_curriculum_map_pk	
    primary key (user_id, curriculum_id)
);

comment on table cu_user_curriculum_map is '
Tracks the curriculums the user does NOT want in his/her personal curriculum bar (if activated). When the user is newly registered (and no rows exist for the user in the map), all published curriculums will be dispayed.
';

comment on column cu_user_curriculum_map.package_id is '
We use this column mainly to be able to add all the curriculums in a package instance to the user''s personalized bar (delete from cu_user_curriculum_map where user_id = :user_id and package_id = :package_id).
';


create table cu_default_assignees (
    package_id        integer
                      constraint cu_default_assignees_package_id_fk
                      references apm_packages (package_id)
                      on delete cascade
                      constraint cu_default_assignees_package_id_pk
                      primary key,
    default_editor    integer
                      constraint cu_default_assignees_default_editor_fk
                      references parties (party_id),
    default_publisher integer
                      constraint cu_default_assignees_default_publisher_fk
                      references parties (party_id)
 );
