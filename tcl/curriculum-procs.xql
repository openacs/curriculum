<?xml version="1.0"?>
<queryset>

    <fullquery name="curriculum::edit.update_curriculum">
        <querytext>
            update cu_curriculums
            set    name = :name,
                   description = :description,
                   desc_format = :desc_format
		 where  curriculum_id = :curriculum_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::get.get_curriculum_data">
        <querytext>
	    select *
	    from   cu_curriculums
	    where  curriculum_id = :curriculum_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::default_editor::get_assignees.select_default_editor">
        <querytext>
	    select default_editor
	    from   cu_default_assignees
	    where  package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::default_publisher::get_assignees.select_default_publisher">
        <querytext>
	    select default_publisher
	    from   cu_default_assignees
	    where  package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::users_get_options.users">
        <querytext>

        select first_names || ' ' || last_name || ' (' || email || ')'  as name, 
               user_id
        from   cc_users
        where  user_id in (
                      select default_editor
                      from   cu_default_assignees
                      where  package_id = :package_id
                      
                      union
                      
                      select default_publisher
                      from   cu_default_assignees
                      where  package_id = :package_id
                )
        or     user_id = :user_id
        order  by name

        </querytext>
    </fullquery>

 </queryset>
