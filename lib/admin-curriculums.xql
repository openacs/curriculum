<?xml version="1.0"?>
<queryset>

<fullquery name="select_resolve_role">      
      <querytext>
      
    select a.assigned_role
    from   workflow_actions a,
           workflow_fsm_action_en_in_st aeis
    where  a.action_id = aeis.action_id
    and    aeis.state_id = :initial_state_id
    and    a.workflow_id = :workflow_id
    and    a.assigned_role is not null

      </querytext>
</fullquery>

</queryset>
