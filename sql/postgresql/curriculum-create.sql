-- packages/curriculum/sql/postgresql/curriculum-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

\i curriculum-curriculum-create.sql
\i curriculum-element-create.sql
\i curriculum-element-package-create.sql
\i curriculum-curriculum-package-create.sql


-- Keep track of which elements a particular user has seen.
create table cu_user_element_map (
    user_id		integer
				constraint cu_user_element_map_user_id_nn
				not null
				constraint cu_user_element_map_user_id_fk
				references users
				on delete cascade,
    element_id	   	integer
				constraint cu_user_element_map_element_id_nn
				not null
				constraint cu_user_element_map_elemen_id_fk
				references cu_elements
				on delete cascade,
    curriculum_id	integer
				constraint cu_user_element_map_curriculum_id_nn
				not null
				constraint cu_user_element_map_curriculum_id_fk
				references cu_curriculums
				on delete cascade,
    package_id		integer
				constraint cu_user_element_map_package_id_nn
				not null
				constraint cu_user_element_map_package_id_fk
				references apm_packages
				on delete cascade,
    completion_date	timestamptz
				default current_timestamp
				constraint cu_user_element_map_completion_date_nn
				not null,
    constraint cu_user_element_map_pk	
    primary key (user_id, element_id)
);
