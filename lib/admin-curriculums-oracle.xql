<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_curriculums">
        <querytext>
    select   cc.curriculum_id,
             cc.name as curriculum_name,
             dbms_lob.substr(cc.description,:truncation_length,1) as curriculum_desc,
             case when dbms_lob.getlength(cc.description) > :truncation_length
                  then 1 else 0 end as curr_desc_trunc_p,
             cc.sort_key as curriculum_sort_order,
             ce.element_id,
             ce.name as element_name,
             dbms_lob.substr(ce.description,:truncation_length,1) as element_desc,
             case when dbms_lob.getlength(ce.description) > :truncation_length
                  then 1 else 0 end as elem_desc_trunc_p,
             ce.enabled_p as element_enabled_p,
             ce.sort_key as element_sort_order,
             st.pretty_name as pretty_state
    from     cu_curriculums cc,
             cu_elements ce,
             workflow_cases cas,
             workflow_case_fsm cfsm,
             workflow_fsm_states st 
    where    cc.curriculum_id = ce.curriculum_id(+)
    and      cc.package_id = :package_id
    and      cfsm.case_id = cas.case_id
    and      st.state_id = cfsm.current_state
    and      cas.object_id = cc.curriculum_id
    $where_clauses
    order by cc.sort_key,
             ce.sort_key
        </querytext>
    </fullquery>

</queryset>
