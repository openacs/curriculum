<?xml version="1.0"?>
<queryset>

    <fullquery name="curriculum::element::edit.update_curriculum_element">
        <querytext>
	    update cu_elements
	    set    name = :name,
	           description = :description,
	           desc_format = :desc_format,
	           url = :url,
			external_p = :external_p
	    where  element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::element::enable.update_element_enabled_p">
        <querytext>
	    update cu_elements
	    set    enabled_p = 't'
	    where  element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::element::disable.update_element_disabled_p">
        <querytext>
	    update cu_elements
	    set    enabled_p = 'f'
	    where  element_id = :element_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::element::get.get_element_data">
        <querytext>
          select *
          from   cu_elements
          where  element_id = :element_id
        </querytext>
    </fullquery>

</queryset>
