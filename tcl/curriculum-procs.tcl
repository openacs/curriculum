ad_library {

    Curriculum Library.

    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}


namespace eval curriculum {}

# Service contract implementation alias namespaces (phew, that was long!).
namespace eval curriculum::default_editor {}
namespace eval curriculum::default_publisher {}
namespace eval curriculum::notification_info {}
namespace eval curriculum::flush_elements {}


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
    @param package_id     Package-id makes the Curriculum package subsite-aware. Defaults to [ad_conn package_id].
    @param sort_key       The relative sort order of the curriculums in a package instance.

    @return The object-id of the newly created curriculum.

    @author Ola Hansson (ola@polyxena.net)

} {
    # Prepare the variables for instantiation.
    set extra_vars [ns_set create]
    oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {curriculum_id name description desc_format package_id sort_key}
    
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
    {-desc_format "text/html"}
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

    @return curriculum_id (just for convenience).

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


ad_proc -public curriculum::get {
    -curriculum_id:required
    -array:required
    {-action_id {}}
} {

    Retrieve info about the curriculum with given id into an 
    array (using upvar) in the callers scope. The
    array will contain the keys:

    <p>curriculum_id, name, description, desc_format, package_id, sort_key</p>
    
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

    # I am localizing pretty_state at this level, for now. It might be better to do it at
    # the "workflow::case::fsm::get" level though, in order to reduce tedious repetition ...
    set row(pretty_state)     [lang::util::localize $case(pretty_state)]
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

	workflow::case::delete -case_id $case_id

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
    set curriculum_ids [conn -nocache curriculum_ids $package_id]

    db_transaction {
	
	foreach curriculum_id $curriculum_ids {
	    ns_log Notice "curriculum::delete_instance - [_ curriculum.lt_deleting_curriculum_c]"
	    delete -curriculum_id $curriculum_id
	}
	
    }

    # Force the curriculum bar to update.
    curriculum::elements_flush -thorough -package_id $package_id
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
            pretty_name \#curriculum.Curriculum_1\#
            package_key curriculum
            object_type cu_curriculum
            callbacks { 
                curriculum.CurriculumNotificationInfo
            }
            roles {
                author {
                    pretty_name \#curriculum.Author\#
                    callbacks { 
                        workflow.Role_DefaultAssignees_CreationUser
                    }
                }
                editor {
                    pretty_name \#curriculum.Editor\#
                    callbacks {
                        curriculum.Role_DefaultAssignees_Editor
                        workflow.Role_PickList_CurrentAssignees
                        workflow.Role_AssigneeSubquery_RegisteredUsers
                    }
                }
                publisher {
                    pretty_name \#curriculum.Publisher\#
                    callbacks {
                        curriculum.Role_DefaultAssignees_Publisher
                        workflow.Role_PickList_CurrentAssignees
                        workflow.Role_AssigneeSubquery_RegisteredUsers
                    }
                }
            }
            states {
                authored {
                    pretty_name \#curriculum.Pending\#
                    hide_fields {}
                }
                edited {
                    pretty_name \#curriculum.Edited\#
                }
                rejected {
                    pretty_name \#curriculum.Rejected\#
                }
                published {
                    pretty_name \#curriculum.Published\#
                }
                archived {
                    pretty_name \#curriculum.Archived\#
                }
            }
            actions {
                create {
                    pretty_name \#curriculum.Create\#
                    pretty_past_tense \#curriculum.Created\#
                    new_state authored
                    initial_action_p t
                    edit_fields { 
			comment
		    }
                }
                comment {
                    pretty_name \#curriculum.Comment\#
                    pretty_past_tense \#curriculum.Commented\#
                    allowed_roles { author editor publisher }
                    privileges { write }
                    always_enabled_p t
                    edit_fields { 
			comment
		    }
                }
                edit {
                    pretty_name \#curriculum.Edit\#
                    pretty_past_tense \#curriculum.Edited\#
                    new_state edited
                    allowed_roles { author editor publisher }
		    assigned_states { authored }
                    privileges { write }
                    always_enabled_p t
                    edit_fields { 
			name
			description
			comment
		    }
		    callbacks {
			curriculum.CurriculumFlushElementsCache
		    }
                }
                reject {
                    pretty_name \#curriculum.Reject\#
                    pretty_past_tense \#curriculum.Rejected\#
                    new_state rejected
                    allowed_roles { publisher }
                    enabled_states { authored edited }
                    privileges { admin }
                    edit_fields { 
			comment
		    }
                }
                publish {
                    pretty_name \#curriculum.Publish\#
                    pretty_past_tense \#curriculum.Published\#
                    assigned_role publisher
                    enabled_states { authored rejected archived }
                    assigned_states { edited }
                    new_state published
                    privileges { admin }
                    edit_fields { 
			comment
		    }
		    callbacks {
			curriculum.CurriculumFlushElementsCache
		    }
                }
                archive {
                    pretty_name \#curriculum.Archive\#
                    pretty_past_tense \#curriculum.Archived\#
                    allowed_roles { publisher }
                    enabled_states { published }
                    new_state archived
                    privileges { admin }
                    edit_fields { 
			comment
		    }
		    callbacks {
			curriculum.CurriculumFlushElementsCache
		    }
                }
                assign {
                    pretty_name \#curriculum.Assign\#
                    pretty_past_tense \#curriculum.Assigned\#
                    allowed_roles { publisher }
                    privileges { admin }
                    always_enabled_p t
                    edit_fields { 
			role_editor
			role_publisher
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
        set package_id [conn -nocache package_id]
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
# Curriculum Default Editor.
#
####

ad_proc -private curriculum::default_editor::pretty_name {} {
    return "[_ curriculum.Editor]"
}


ad_proc -private curriculum::default_editor::get_assignees {
    case_id
    object_id
    role_id
} {
    set package_id [curriculum::conn package_id]
    return [db_string select_default_editor {*SQL*} -default {}]
}


####
#
# Curriculum Default Publisher.
#
####

ad_proc -private curriculum::default_publisher::pretty_name {} {
    return "[_ curriculum.Publisher]"
}


ad_proc -private curriculum::default_publisher::get_assignees {
    case_id
    object_id
    role_id
} {
    set package_id [curriculum::conn package_id]
    return [db_string select_default_publisher {*SQL*} -default {}]
}


ad_proc -private curriculum::users_get_options {
    -package_id
} {
    if { ![info exists package_id] } {
        set package_id [conn package_id]
    }
    
    set user_id [ad_conn user_id]
    
    # This picks out users who are already assigned as editors or publishers in this curriculum instance.    
    set users_list [db_list_of_lists users {*SQL*}]
    
    set users_list [concat { { "Unassigned" "" } } $users_list]
    lappend users_list { "Search..." ":search:" }
    
    return $users_list
}


####
#
# Flush element cache (action side-effect).
#
####


ad_proc -private curriculum::flush_elements::pretty_name {} {
    return "[_ curriculum.lt_Flush_element_cache]"
}


ad_proc -private curriculum::flush_elements::do_side_effect {
    case_id
    object_id
    action_id
    entry_id
} {
    # Force the curriculum bar to update.
    curriculum::elements_flush
}


####
#
# Notification info.
#
####


ad_proc -private curriculum::notification_info::pretty_name {} {
    return "[_ curriculum.Curriculum_info]"
}


ad_proc -private curriculum::notification_info::get_notification_info {
    case_id
    object_id
} {
    
    curriculum::get -curriculum_id $object_id -array curriculum
    
    set url "[ad_url][apm_package_url_from_id $curriculum(package_id)]curriculum-ave?[export_vars { { curriculum_id $curriculum(curriculum_id) } }]"
    
    set notification_subject_tag "[_ curriculum.Curriculum_1]"
    
    set one_line "$curriculum(name)"

    # Build up data structures with the form labels and values
    # (Note, this is something that the metadata system should be able to do for us)
    
    array set label [list \
			 name "[_ curriculum.Name]" \
			 status "[_ curriculum.Status]"]
    
    array set value [list \
			 name "$curriculum(name)" \
			 status "$curriculum(pretty_state)"]
    
    set fields {
        name
        status
    }
    
    # Remove fields that should be hidden in this state
    foreach field $curriculum(hide_fields) {
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
                     -pretty_name "[_ curriculum.this_curriculum]"]
        set label "[_ curriculum.Watch]"
        set title "[_ curriculum.lt_Request_notifications]"
    } else {
        set url [notification::display::unsubscribe_url -request_id $request_id -url $return_url]
        set label "[_ curriculum.Stop_watching]"
        set title "[_ curriculum.lt_Unsubscribe_to_notifi]"
    }
    return [list $url $label $title]
}


ad_proc -private curriculum::security_violation {
    -user_id:required
    -curriculum_id:required
    -action:required
} {
    ns_log Notice "[_ curriculum.lt_user_id_doesnt_have_p]"
    ad_return_forbidden \
	"[_ curriculum.Security_Violation]" \
	"<blockquote>
    [_ curriculum.lt_You_dont_have_permiss]
    </blockquote>"
    ad_script_abort
}
