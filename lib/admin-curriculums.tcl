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

    # Translate the pretty_state in #package_key.message_key# syntax.
    set pretty_state [lang::util::localize $pretty_state]
}

set curriculum_count [curriculum::conn -nocache curriculum_count]

set return_url [ad_return_url]

set export_vars [export_vars -url { package_id return_url }]

# Categories.
set category_map_url [export_vars -base \
			  "[site_node::get_package_url -package_key categories]cadmin/one-object" \
			  { { object_id $package_id } }]

ad_return_template
