ad_library {

    Curriculum Library.

    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}


namespace eval curriculum {}
namespace eval curriculum::owner {}
namespace eval curriculum::capture_resolution_code {}
namespace eval curriculum::format_log_title {}
namespace eval curriculum::notification_info {}


ad_proc -public curriculum::workflow_short_name {} {
    Get the short name of the workflow for curriculums
} {
    return "curriculum"
}


ad_proc -public curriculum::package_key {} {
    return "curriculum"
}


ad_proc -public curriculum::new {
    {-curriculum_id ""}
    -name:required
    {-description ""}
    {-desc_format "text/html"}
    {-comment ""}
    {-comment_format "text/html"}
    {-owner_id ""}
    -package_id:required
    {-sort_key ""}
} {

    Create a new curriculum.

    @param curriculum_id  The pre-fetched object-id of the curriculum which should be created (normally not used).
    @param name           The name of the curriculum.
    @param description    Long description of the objective(s) of the curriculum.
    @param desc_format    The format of the description. Current formats are: text/enhanced text/plain text/html text/fixed-width
    @param comment        Comment on the action taken on the curriculum.
    @param comment_format The format of the comment. Current formats are: text/enhanced text/plain text/html text/fixed-width
    @param owner_id       The party-id of the party - user or group - that is responsible for this curriculum. Defaults to the creating user.
    @param package_id     Package-id makes the Curriculum package subsite-aware. Defaults to [ad_conn package_id].
    @param sort_key       The relative sort order of the curriculums in a package instance.

    @return The object-id of the newly created curriculum.

    @author Ola Hansson (ola@polyxena.net)

} {
    # If no owner_id is provided, we set it to the currently logged-in user.
    if [empty_string_p $owner_id] {
	set owner_id [ad_conn user_id]
    }

    # Prepare the variables for instantiation.
    set extra_vars [ns_set create]
    oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {curriculum_id name description desc_format owner_id package_id sort_key}
    
    db_transaction {
	
	# Instantiate the curriculum object.
	set curriculum_id [package_instantiate_object \
			       -extra_vars $extra_vars cu_curriculum]
	
	# Start a new workflow case.
	workflow::case::new \
	    -workflow_id [workflow::get_id -object_id $package_id -short_name [workflow_short_name]] \
	    -object_id $curriculum_id \
	    -comment $comment \
	    -comment_mime_type $comment_format
    }

    return $curriculum_id
}


ad_proc -public curriculum::edit {
    -curriculum_id:required
    -name:required
    {-description ""}
    {-desc_format "text/plain"}
    {-comment ""}
    {-comment_format "text/html"}
    -action_id:required
    -array:required
    {-entry_id {}}
} {

    Edit a curriculum.

    @param curriculum_id  The object-id of the curriculum which should be updated.
    @param name           The new name.
    @param description    The new description.
    @param desc_format    The format of the description. Current formats are: text/enhanced text/plain text/html text/fixed-width
    @param comment        Comment on the action taken on the curriculum.
    @param comment_format The format of the comment. Current formats are: text/enhanced text/plain text/html text/fixed-width

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    upvar $array row
    
    array set assignments [list]
    
    set role_prefix "role_"
    foreach name [array names row "${role_prefix}*"] {
        set assignments([string range $name [string length $role_prefix] end]) $row($name)
        unset row($name)
    }
    
    db_transaction {

	# Update the curriculum info.
	db_dml update_curriculum {*SQL*}

	set case_id [workflow::case::get_id \
			 -workflow_short_name [workflow_short_name] \
			 -object_id $curriculum_id]

	workflow::case::role::assign \
	    -replace \
	    -case_id $case_id \
	    -array assignments

	workflow::case::action::execute \
	    -case_id $case_id \
	    -action_id $action_id \
	    -comment $comment \
	    -comment_mime_type $comment_format \
	    -entry_id $entry_id
    }
    
    return $curriculum_id
}


ad_proc -public curriculum::change_owner {
    -curriculum_id:required
    -owner_id:required
} {

    Change the owner of a curriculum.

    @param curriculum_id The object-id of the curriculum which should change owner.
    @param owner_id      Party-id of the new owner.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    db_dml update_curriculum_owner {*SQL*}
}


ad_proc -public curriculum::get {
    -curriculum_id:required
    -array:required
    {-action_id {}}
} {

    Retrieve info about the curriculum with given id into an 
    array (using upvar) in the callers scope. The
    array will contain the keys:

    <p>curriculum_id, name, description, desc_format, owner_id, package_id, sort_key</p>
    
    @param curriculum_id The id of the curriculum to retrieve information about.
    @param array The name of the array in the callers scope where the information will
    be stored.
    
    @return The return value from db_0or1row. If more than one row is returned, throws an error.
    
    @author Ola Hansson (ola@polyxena.net)

} {
    upvar $array row

    if { ![db_0or1row get_curriculum_data {*SQL*} -column_array row] } {
	# Query did not return a row. We should probably return an error instead.
	return 0
	ad_script_abort
    }

    # Get the case ID, so we can get state information.
    set case_id [workflow::case::get_id \
		     -object_id $curriculum_id \
		     -workflow_short_name [workflow_short_name]]

    # Get state information.
    workflow::case::fsm::get -case_id $case_id -array case -action_id $action_id

    set row(pretty_state)     $case(pretty_state)
    set row(state_short_name) $case(state_short_name)
    set row(hide_fields)      $case(state_hide_fields)
    set row(entry_id)         $case(entry_id)

    return 1
}


ad_proc -public curriculum::delete {
    -curriculum_id:required
} {

    Delete a curriculum.

    @param curriculum_id The object-id of the curriculum which should be deleted.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    db_transaction {
	
	# Get the case ID.
	set case_id [workflow::case::get_id \
			 -object_id $curriculum_id \
			 -workflow_short_name [workflow_short_name]]

	# FIXME. There should be a Tcl wrapper for this in workflow but there
	# isn't yet (at least not on MAIN).
	#workflow::case::delete -case_id $case_id
	db_exec_plsql delete_workflow_case {*SQL*}

	db_exec_plsql delete_curriculum {*SQL*}

    }
}


ad_proc -private curriculum::delete_instance {
    -package_id:required
} {

    Deletes curriculums in a package instance (and their data).
    We thus avoid having orphan curriculum data in the database.

    @param package_id The package_id of the curriculum instance which should be deleted.

    @return Nothing.
    
    @author Ola Hansson (ola@polyxena.net)

} {
    # Get a list of all curriculums in this package instance.
    set curriculum_ids [conn -nocache curriculum_ids]

    db_transaction {
	
	foreach curriculum_id $curriculum_ids {
	    ns_log Notice "curriculum::delete_instance - deleting curriculum $curriculum_id in package_id $package_id"
	    delete -curriculum_id $curriculum_id
	}
	
    }
}

####
#
# Workflow procs.
#
####


ad_proc -private curriculum::workflow_create {} {
    Create the 'curriculum' workflow for curriculum.
} {
    set spec {
        curriculum {
            pretty_name "Curriculum"
            package_key "curriculum"
            object_type "cu_curriculum"
            callbacks { 
                curriculum.CurriculumNotificationInfo
            }
            roles {
                author {
                    pretty_name "Author"
                    callbacks { 
                        workflow.Role_DefaultAssignees_CreationUser
                    }
                }
                editor {
                    pretty_name "Editor"
                }
                publisher {
                    pretty_name "Publisher"
                    callbacks {
                        curriculum.CurriculumOwner
                        workflow.Role_PickList_CurrentAssignees
                        workflow.Role_AssigneeSubquery_RegisteredUsers
                    }
                }
            }
            states {
                authored {
                    pretty_name "Created"
                    hide_fields {}
                }
                edited {
                    pretty_name "Edited"
                }
                rejected {
                    pretty_name "Rejected"
                }
                published {
                    pretty_name "Published"
                }
                archived {
                    pretty_name "Archived"
                }
            }
            actions {
                create {
                    pretty_name "Create"
                    pretty_past_tense "Created"
                    new_state "authored"
                    initial_action_p t
                }
                comment {
                    pretty_name "Comment"
                    pretty_past_tense "Commented"
                    allowed_roles { author editor publisher }
                    privileges { write }
                    always_enabled_p t
                    edit_fields { 
			       comment
		         }
                }
                edit {
                    pretty_name "Edit"
                    pretty_past_tense "Edited"
                    new_state "edited"
                    allowed_roles { author editor publisher }
                    privileges { write }
                    always_enabled_p t
                    edit_fields { 
                        name
			       description
			       comment
		         }
                }
                reject {
                    pretty_name "Reject"
                    pretty_past_tense "Rejected"
                    new_state "rejected"
                    assigned_role "publisher"
                    enabled_states { authored edited }
                    assigned_states { edited }
                    privileges { write }
                    edit_fields { 
			       comment
		         }
                }
                publish {
                    pretty_name "Publish"
                    pretty_past_tense "Published"
                    assigned_role "publisher"
                    enabled_states { authored edited archived }
                    assigned_states { edited }
                    new_state "published"
                    privileges { write }
                    edit_fields {
			       comment
		         }
                }
                archive {
                    pretty_name "Archive"
                    pretty_past_tense "Archived"
                    assigned_role "publisher"
                    assigned_states { published }
                    new_state "archived"
                    privileges { write }
                    edit_fields {
                        comment
                    }
                }
            }
        }
    }
    set workflow_id [workflow::fsm::new_from_spec -spec $spec]
    
    return $workflow_id
}


ad_proc -public curriculum::workflow_short_name {} {
    Get the short name of the workflow for curriculums.
} {
    return "curriculum"
}


ad_proc -public curriculum::object_type {} {
    Get the object_type of curriculum.
} {
    return "cu_curriculum"
}


ad_proc -private curriculum::workflow_delete {} {
    Delete the 'curriculum' workflow for curriculum.
} {
    set workflow_id [get_package_workflow_id]
    if { ![empty_string_p $workflow_id] } {
        workflow::delete -workflow_id $workflow_id
    }
}


ad_proc -public curriculum::get_package_workflow_id {} { 
    Return the workflow_id for the package (not instance) workflow.
} {
    return [workflow::get_id \
            -short_name [workflow_short_name] \
            -package_key [package_key]]

}


ad_proc -public curriculum::get_instance_workflow_id {
    {-package_id {}}
} { 
    Return the workflow_id for the instance (not package) workflow.
} {
    if { [empty_string_p $package_id] } {
        set package_id [conn package_id]
    }

    return [workflow::get_id \
            -short_name [workflow_short_name] \
            -object_id $package_id]
}


ad_proc -private curriculum::instance_workflow_create {
    -package_id:required
} {
    Creates a clone of the default curriculum package workflow for a
    specific package instance. 
} {
    set workflow_id [workflow::fsm::clone \
            -workflow_id [get_package_workflow_id] \
            -object_id $package_id]
    
    return $workflow_id
}


ad_proc -private curriculum::instance_workflow_delete {
    -package_id:required
} {
    Deletes the instance workflow.
} {
    workflow::delete -workflow_id [get_instance_workflow_id -package_id $package_id]
}


####
#
# Curriculum owner.
#
####


ad_proc -private curriculum::owner::pretty_name {} {
    return "Curriculum owner"
}


ad_proc -private curriculum::owner::get_assignees {
    case_id
    object_id
    role_id
} {
    return [db_string select_curriculum_owner {*SQL*} -default {}]
}


####
#
# Capture resolution code. (Useful if we need to perform side effects but not being used right now.)
#
####


# FIXME
ad_proc -private curriculum::capture_resolution_code::pretty_name {} {
    return "Capture resolution code in the case activity log"
}


ad_proc -private curriculum::capture_resolution_code::do_side_effect {
    case_id
    object_id
    action_id
    entry_id
} {
    db_dml insert_resolution_code {*NOT WRITTEN YET*}
}


####
#
# Format log title.
#
####


ad_proc -private curriculum::format_log_title::pretty_name {} {
    return "Add resolution code to log title"
}


ad_proc -private curriculum::format_log_title::format_log_title {
    case_id
    object_id
    action_id
    entry_id
    data_arraylist
} {
    array set data $data_arraylist

    if { [info exists data(resolution)] } {
        return [resolution_pretty $data(resolution)]
    } else {
        return {WHAT?!}
    }
}


# FIXME. Resolution ????
ad_proc -private curriculum::resolution_get_options {} {

    return {
        fixed     "Fixed"
        bydesign  "By Design" 
        wontfix   "Won't Fix" 
        postponed "Postponed"
        duplicate "Duplicate"
        norepro   "Not Reproducable"
        needinfo  "Need Info"
    }

}


ad_proc -private curriculum::resolution_pretty {
    resolution
} {
    array set resolution_codes [resolution_get_options]

    if { [info exists resolution_codes($resolution)] } {
        return $resolution_codes($resolution)
    } else {
        return {}
    }
}


####
#
# Notification info.
#
####


ad_proc -private curriculum::notification_info::pretty_name {} {
    return "Curriculum info"
}


# FIXME. 
ad_proc -private curriculum::notification_info::get_notification_info {
    case_id
    object_id
} {
####
    return [list /my/test/url one_line {details_list testing} notification_subject_tag]
    ad_script_abort
####


    bug_tracker::bug::get -bug_id $object_id -array bug

    set url "[ad_url][apm_package_url_from_id $bug(project_id)]bug?[export_vars { { bug_number $bug(bug_number) } }]"

    bug_tracker::get_pretty_names -array pretty_names

    set notification_subject_tag [db_string select_notification_tag {} -default {}]

    set one_line "$pretty_names(Bug) #$bug(bug_number): $bug(summary)"

    # Build up data structures with the form labels and values
    # (Note, this is something that the metadata system should be able to do for us)

    array set label {
        summary "Summary"
        status "Status"
        found_in_version "Found in version"
        fix_for_version "Fix for version"
        fixed_in_version "Fixed in version"
    }

    set label(bug_number) "$pretty_names(Bug) #"
    set label(component) "$pretty_names(Component)"

    set fields {
        bug_number
        component
    }

    # keywords
    foreach { category_id category_name } [bug_tracker::category_types] {
        lappend fields $category_id
        set value($category_id) [bug_tracker::category_heading \
                                     -keyword_id [cr::keyword::item_get_assigned -item_id $bug(bug_id) -parent_id $category_id] \
                                     -package_id $bug(project_id)]
        set label($category_id) $category_name
    }

    lappend fields summary status 

    if { [bug_tracker::versions_p -package_id $bug(project_id)] } {
        lappend fields found_in_version fix_for_version fixed_in_version
    }

    set value(bug_number) $bug(bug_number)
    set value(component)  $bug(component_name)
    set value(summary) $bug(summary)
    set value(status) $bug(pretty_state)
    set value(found_in_version) [ad_decode $bug(found_in_version_name) "" "Unknown" $bug(found_in_version_name)]
    set value(fix_for_version) [ad_decode $bug(fix_for_version_name) "" "Undecided" $bug(fix_for_version_name)]
    set value(fixed_in_version) [ad_decode $bug(fixed_in_version_name) "" "Unknown" $bug(fixed_in_version_name)]

    # Remove fields that should be hidden in this state
    foreach field $bug(hide_fields) {
        set index [lsearch -exact $fields $field]
        if { $index != -1 } {
            set fields [lreplace $fields $index $index]
        }
    }
    
    # Build up the details list
    set details_list [list]
    foreach field $fields {
        lappend details_list $label($field) $value($field)
    }

    return [list $url $one_line $details_list $notification_subject_tag]
}


ad_proc -public curriculum::get_watch_link {
    {-curriculum_id:required}
} {
    Get link for watching a curriculum.
    @return 3-tuple of url, label and title.
} {
    set user_id [ad_conn user_id]
    set return_url [util_get_current_url]
    
    # Get the type id
    set type "workflow_case"
    set type_id [notification::type::get_type_id -short_name $type]

    # Check if subscribed
    set request_id [notification::request::get_request_id \
                        -type_id $type_id \
                        -object_id $curriculum_id \
                        -user_id $user_id]

    set subscribed_p [expr ![empty_string_p $request_id]]
        
    if { !$subscribed_p } {
        set url [notification::display::subscribe_url \
                     -type $type \
                     -object_id $curriculum_id \
                     -url $return_url \
                     -user_id $user_id \
                     -pretty_name "this curriculum"]
        set label "Watch"
        set title "Request notifications for activity on this curriculum"
    } else {
        set url [notification::display::unsubscribe_url -request_id $request_id -url $return_url]
        set label "Stop watching"
        set title "Unsubscribe to notifications for activity on this curriculum"
    }
    return [list $url $label $title]
}


ad_proc -private curriculum::security_violation {
    -user_id:required
    -curriculum_id:required
    -action:required
} {
    ns_log Notice "$user_id doesn't have permission to '$action' on curriculum $curriculum_id"
    ad_return_forbidden \
            "Security Violation" \
            "<blockquote>
    You don't have permission to '$action' on this curriculum.
    <br>
    This incident has been logged.
    </blockquote>"
    ad_script_abort
}
