ad_page_contract {

    Curriculum admin index page.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-28
    @cvs-id $Id$

} {
} -properties {
    title:onevalue
    context:onevalue
}

set title "Curriculum"
set context {}

# Create the tab strip that filters curriculums by workflow state.
set url [ad_conn url]

template::tabstrip create states -base_url $url

set workflow_id [curriculum::get_instance_workflow_id]
array set state_data [workflow::state::fsm::get_all_info -workflow_id $workflow_id]

foreach state_id $state_data(state_ids) {
    array set state $state_data($state_id)
    template::tabstrip add_tab states $state(state_id) $state(pretty_name) $state(short_name)
}

template::tabstrip add_tab states any "Any" any

ad_return_template
