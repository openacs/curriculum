<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="curriculum::delete.delete_curriculum">
        <querytext>
		 declare begin
		     cu_curriculum.del(:curriculum_id);
		 end;
        </querytext>
    </fullquery>

    <fullquery name="curriculum::delete.delete_workflow_case">
        <querytext>
		declare begin
			:1 := workflow_case.delete(:case_id);
		end;
        </querytext>
    </fullquery>

</queryset>
