-- packages/curriculum/sql/oracle/curriculum-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

@ curriculum-curriculum-create.sql
@ curriculum-element-create.sql
@ curriculum-element-package-create.sql
@ curriculum-curriculum-package-create.sql


-- Keep track of which elements a particular user has seen.
create table cu_user_element_map (
    user_id		integer
				constraint cu_user_element_map_user_id_nn
				not null
				constraint cu_user_element_map_user_id_fk
				references users
				on delete cascade,
    element_id	   	integer
				constraint cu_user_element_map_elem_id_nn
				not null
				constraint cu_user_element_map_elem_id_fk
				references cu_elements
				on delete cascade,
    curriculum_id	integer
				constraint cu_user_element_map_curr_id_nn
				not null
				constraint cu_user_element_map_curr_id_fk
				references cu_curriculums
				on delete cascade,
    package_id		integer
				constraint cu_user_element_map_pack_id_nn
				not null
				constraint cu_user_element_map_pack_id_fk
				references apm_packages
				on delete cascade,
    completion_date	date
				default sysdate
				constraint cu_user_element_map_comp_da_nn
				not null,
    constraint cu_user_element_map_pk	
    primary key (user_id, element_id)
);
