<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="curriculum::curriculum_filter_internal.map_insert">
        <querytext>
         insert into cu_user_element_map
         (user_id, element_id, curriculum_id, package_id, completion_date)
         select :user_id,
                :element_id,
                :curriculum_id,
                :package_id,
                current_timestamp
         where  not exists (select 1
                            from   cu_user_element_map
                            where  user_id = :user_id
                            and    element_id = :element_id)
        </querytext>
    </fullquery>

    <fullquery name="curriculum::enabled_elements.element_ns_set_list">
        <querytext>

--
-- Rewrite this query to look more like the Oracle version.
--

            (select   cee.element_id,
                     cee.curriculum_id,
                     cee.url,
                     cee.name
            from     cu_curriculums cc left outer join
                     cu_elements_enabled cee using (curriculum_id),
                     workflow_cases cas,
                     workflow_case_fsm cfsm
            where    cc.package_id = :package_id
            and      cas.object_id = cc.curriculum_id
            and      cfsm.case_id = cas.case_id
            and      cfsm.current_state = :state_id
            order by cc.sort_key,
                     cee.sort_key)

            EXCEPT

            (select   cee.element_id,
                     cee.curriculum_id,
                     cee.url,
                     cee.name
            from     (cu_user_curriculum_map ucm inner join
                     cu_curriculums cc using (curriculum_id)) left outer join
                     cu_elements_enabled cee using (curriculum_id),
                     workflow_cases cas,
                     workflow_case_fsm cfsm
            where    cc.package_id = :package_id
            and      cas.object_id = cc.curriculum_id
            and      cfsm.case_id = cas.case_id
            and      cfsm.current_state = :state_id
            and      ucm.user_id = :user_id
            order by cc.sort_key,
                     cee.sort_key)

        </querytext>
    </fullquery>

    <fullquery name="curriculum::user_elements.user_element_ns_set_list">
        <querytext>

    select   published.curriculum_id,
             published.name as curriculum_name,
             substring(published.description from 1 for :truncation_length) as curriculum_desc,
             case when length(published.description) > :truncation_length
                  then 1 else 0 end as curr_desc_trunc_p,
             case when ucm.curriculum_id is null
                  then 0 else 1 end as undesired_p,
             cee.element_id,
             cee.name as element_name,
             substring(cee.description from 1 for :truncation_length) as element_desc,
             case when length(cee.description) > :truncation_length
                  then 1 else 0 end as elem_desc_trunc_p,
             cee.url
    from     (select   cc.*
              from     cu_curriculums cc,
                       workflow_cases cas,
                       workflow_case_fsm cfsm
              where    cc.package_id = :package_id
              and      cas.object_id = cc.curriculum_id
              and      cfsm.case_id = cas.case_id
              and      cfsm.current_state = :state_id
             ) published left outer join
             cu_user_curriculum_map ucm
             on  published.package_id = ucm.package_id
             and published.curriculum_id = ucm.curriculum_id
             and ucm.user_id = :user_id,
             cu_elements_enabled cee
    where    published.curriculum_id = cee.curriculum_id
    order by published.sort_key,
             cee.sort_key

        </querytext>
    </fullquery>

</queryset>
