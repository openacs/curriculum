ad_page_contract {

    Curriculum admin page tabbed.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-11
    @cvs-id $Id$

} {
} -properties {
    title:onevalue
    context:onevalue
}

set title "Curriculum"
set context {}

set package_id [curriculum::conn package_id]

# Workflow.
set workflow_id [curriculum::get_instance_workflow_id -package_id $package_id]    

if { [set tabs_p [parameter::get -package_id $package_id -parameter StateTabsP -default 1]] } {

    # Create the tab strip that filters curriculums by workflow state.
    template::tabstrip create states -base_url [ad_conn url]
    
    array set state_data [workflow::state::fsm::get_all_info -workflow_id $workflow_id]
    
    foreach state_id $state_data(state_ids) {
	array set state $state_data($state_id)
	template::tabstrip add_tab states $state(state_id) [lang::util::localize $state(pretty_name)] $state(short_name)
    }
    template::tabstrip add_tab states any "[_ curriculum.Any]" any
    
}

ad_return_template
