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

    <fullquery name="curriculum::change_owner.update_curriculum_owner">
        <querytext>
	    update cu_curriculums
	    set    owner_id = :owner_id
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

    <fullquery name="curriculum::owner::get_assignees.select_curriculum_owner">
        <querytext>
	    select owner_id
	    from   cu_curriculums
	    where  curriculum_id = :object_id
        </querytext>
    </fullquery>

 </queryset>
