ad_page_contract {

    Curriculum listing widget.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
} -properties {
    state_id:onevalue
    workflow_id:onevalue
}
# state_id is an integer or the string "any", provided as an <include> property.
# workflow_id. Get this from an <include> property, also.

# Scoping.
set package_id [curriculum::conn package_id]

permission::require_permission -object_id $package_id -privilege admin

# We might need this if we want to present statistics, see bug-tracker (we need it for this page, too).
set initial_state_id [workflow::fsm::get_initial_state -workflow_id $workflow_id]

set action_role [db_string select_resolve_role {*SQL*}]

####
# Filters.
####

# Filter by workflow state.
if { [string equal "any" $state_id] } {
    set where_clauses {}
} else {
    set where_clauses {{cfsm.current_state = :state_id}}
}

# Construct a nicely formatted string to use in the query file.
set where_clauses [ad_decode $where_clauses {} {} "    and    [join $where_clauses "\n    and    "]"]

set truncation_length [parameter::get -package_id $package_id \
			   -parameter DescTruncLength -default 200]

# List of curriculums and their elements.
db_multirow -extend {
    curriculum_id_export
    element_id_export
} curriculums select_curriculums {*SQL*} {

    set curriculum_id_export [export_vars -url curriculum_id]
    set element_id_export [export_vars -url element_id]

}

set curriculum_count [curriculum::conn -nocache curriculum_count]

ad_return_template
