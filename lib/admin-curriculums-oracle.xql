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
             ce.url as element_url,
             ce.enabled_p as element_enabled_p,
             ce.sort_key as element_sort_order,
             author.first_names as author_first_names,
             author.last_name as author_last_name,
             author.email as author_email,
             st.pretty_name as pretty_state,
             st.short_name as state_short_name,
             st.state_id,
             st.hide_fields,
             assignee.party_id as assignee_party_id,
             assignee.email as assignee_email,
             assignee.name as assignee_name
    from     cu_curriculums cc,
             cu_elements ce,
             cc_users author,
             (select rpm.case_id,
                     p.party_id,
                     p.email,
                     acs_object.name(p.party_id) as name
              from   workflow_case_role_party_map rpm,
                     parties p
              where  rpm.role_id = :action_role
              and    p.party_id = rpm.party_id
             ) assignee,
             workflow_cases cas,
             workflow_case_fsm cfsm,
             workflow_fsm_states st 
    where    cc.curriculum_id = ce.curriculum_id(+)
    and      cc.package_id = :package_id
    and      author.user_id = cc.owner_id
    and      cfsm.case_id = cas.case_id
    and      st.state_id = cfsm.current_state
    and      cas.workflow_id = :workflow_id
    and      cas.object_id = cc.curriculum_id
    and      cas.case_id = assignee.case_id(+)
    $where_clauses
    order by cc.sort_key,
             ce.sort_key
        </querytext>
    </fullquery>

</queryset>
