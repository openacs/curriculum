<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="curriculum::element::delete.delete_element">
        <querytext>
		 declare begin
		     cu_element.del(:element_id);
		 end;
        </querytext>
    </fullquery>

</queryset>
