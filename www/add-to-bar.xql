<?xml version="1.0"?>
<queryset>

    <fullquery name="add_published_curriculums_to_bar">
        <querytext>
	delete from cu_user_curriculum_map
      where user_id = :user_id
      and package_id = :package_id
	$extra_where_clause
        </querytext>
    </fullquery>

</queryset>
