<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="curriculum::delete.delete_curriculum">
        <querytext>
	      select cu_curriculum__del(:curriculum_id);
        </querytext>
    </fullquery>

    <fullquery name="curriculum::delete.delete_workflow_case">
        <querytext>
		select workflow_case__delete(:case_id);
        </querytext>
    </fullquery>

</queryset>
