<?xml version="1.0"?>
<queryset>

    <fullquery name="start_over">
        <querytext>
	delete from cu_user_element_map
      where user_id = :user_id
      and package_id = :package_id
	$extra_where_clause
        </querytext>
    </fullquery>

</queryset>
