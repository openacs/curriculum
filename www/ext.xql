<?xml version="1.0"?>
<queryset>

    <fullquery name="get_destination_url">
        <querytext>
    select url
    from   cu_elements
    where  element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="insert_into_map_table">
        <querytext>
        insert into cu_user_element_map
               (user_id, element_id, curriculum_id, package_id, completion_date)
               select :user_id,
                      :element_id,
                      :curriculum_id,
                      :package_id,
                      current_timestamp
        where not exists
       (select 1 from cu_user_element_map 
	 where user_id = :user_id
	 and   element_id = :element_id)
        </querytext>
    </fullquery>
 
</queryset>
