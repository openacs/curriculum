<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_curriculums">
        <querytext>
    select    cc.curriculum_id,
              cc.name as curriculum_name,
              substring(cc.description from 1 for :truncation_length) as curriculum_desc,
              case when length(cc.description) > :truncation_length
                   then 1 else 0 end as curr_desc_trunc_p,
              cc.sort_key as curriculum_sort_order,
              ce.element_id,
              ce.name as element_name,
              substring(ce.description from 1 for :truncation_length) as element_desc,
              case when length(ce.description) > :truncation_length
                   then 1 else 0 end as elem_desc_trunc_p,
              ce.enabled_p as element_enabled_p,
              ce.sort_key as element_sort_order,
              st.pretty_name as pretty_state
    from      cu_curriculums cc left outer join
              cu_elements ce using (curriculum_id),
              workflow_cases cas,
              workflow_case_fsm cfsm,
              workflow_fsm_states st 
    where     cc.package_id = :package_id
    and       cfsm.case_id = cas.case_id
    and       st.state_id = cfsm.current_state
    and       cas.object_id = cc.curriculum_id
    $where_clauses
    order by  cc.sort_key,
              ce.sort_key
        </querytext>
    </fullquery>

</queryset>
