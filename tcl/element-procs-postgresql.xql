<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="curriculum::element::delete.delete_element">
        <querytext>
	      select cu_element__del(:element_id);
        </querytext>
    </fullquery>

</queryset>
