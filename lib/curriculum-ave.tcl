ad_page_contract {

    Add/edit/view curriculum.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
    curriculum_id:integer,optional
    {return_url "."}
} -properties {
    title:onevalue
    context:onevalue
}

set package_id [curriculum::conn package_id]
set user_id [ad_conn user_id]
set actions [list]
set element_mode {}
set desc_help_text "[_ curriculum.lt_This_text_should_desc]"

if { [set new_p [ad_form_new_p -key curriculum_id]] } {

    ####
    # New curriculum.
    ####

    permission::require_permission -object_id $package_id -privilege write
    set write_p 1

    set form_mode edit
    set title "[_ curriculum.Create_Curriculum]"

} else {

    ####
    # Edit/display curriculum.
    ####

    set write_p [permission::permission_p -object_id $curriculum_id -privilege write]

    if { $write_p } {
	
	#permission::require_permission -object_id $curriculum_id -privilege write

	####
	# Workflow.
	####

	# The form goes into "edit" mode if there is a workflow action ...
	set action_id [form get_action curriculum]
	set wf_action_exists_p [expr ![empty_string_p $action_id]]
	
	# FIXME. Do we need this when we require permission above already?
	# Registration required for all actions.
	#    if { $wf_action_exists_p } {
	#	ad_maybe_redirect_for_registration
	#    }
	
	set case_id [workflow::case::get_id \
			 -object_id $curriculum_id \
			 -workflow_short_name [curriculum::workflow_short_name]]
	
	# Check permissions.
	if { ![workflow::case::action::available_p -case_id $case_id -action_id $action_id] } {
	    curriculum::security_violation -user_id $user_id -curriculum_id $curriculum_id -action $action_id
	}
	
	# Action buttons.
	if { !$wf_action_exists_p } {
	    foreach available_action_id [workflow::case::get_available_actions -case_id $case_id] {
		workflow::action::get -action_id $available_action_id -array available_action
		lappend actions [list "     $available_action(pretty_name)     " $available_action(action_id)]
	    }
	}
	
	# Action pretty names.
	if { $wf_action_exists_p } {
	    
	    # Hmm... Not elegant but initially we need to set the mode for each element
	    # of the form to display mode, thus overriding the default form mode,
	    # and then "open up" the edit_fields for the given action for editing.
	    # We can't just change the mode of the entire form to display mode because
	    # then the form will lose its OK and Cancel buttons when an action button is pressed.
	    
	    set element_mode display
	    
	    set action_pretty_name [lang::util::localize [workflow::action::get_element \
							      -action_id $action_id \
							      -element pretty_name]]
	} else {
	    set action_pretty_name {}
	}
	
	set curriculum_name [acs_object_name $curriculum_id]
	set title "[ad_decode $action_pretty_name "" "[_ curriculum.View]" $action_pretty_name] [_ curriculum.Curriculum] $curriculum_name"
    } else {

	# Display mode only! (User doesn't have write perms)

	set wf_action_exists_p 0
	set curriculum_name [acs_object_name $curriculum_id]
	set title "[_ curriculum.Curriculum] $curriculum_name"

    }
    
    
    set form_mode display
}

set context {$title}

# Curriculum "owner" select box. 
set users_list [list]
lappend users_list [list [person::name -person_id $user_id] "$user_id"]
lappend users_list [list "[_ curriculum.Search]" ":search:"]


####
#
# Build the form.
#
####

# It's a shame to have to specify "{mode display}" for every single element
# and then force the "edit_fields" into edit mode depending on wf status, etc. 
# This might be figured out by ad_form, e.g. if there exist any actions ...

ad_form -name curriculum \
    -cancel_url $return_url \
    -mode $form_mode \
    -actions $actions \
    -has_edit [expr !$write_p] \
    -form {
    curriculum_id:key
    {name:text
	{mode $element_mode}
	{label "[_ curriculum.Name]"}
	{html {size 50}}
    }
}

ad_form -extend -name curriculum -form {
    {description:richtext,optional
	{mode $element_mode}
	{label "[_ curriculum.Description]"}
	{help_text $desc_help_text}
	{html {rows 10 cols 50 wrap soft}}
    }
}

if { $write_p } {
    ad_form -extend -name curriculum -form {
	{comment:richtext,optional
	    {mode $element_mode}
	    {label "[_ curriculum.Action_Log]"}
	    {help_text "[_ curriculum.lt_This_field_is_for_com]"}
	    {html {rows 5 cols 50 wrap soft}}
	}
    }
}

# Add status field on display/edit mode for people with write privs.
if { !$new_p && $write_p } {
    ad_form -extend -name curriculum -form {
	{pretty_state:text(inform)
	    {label "[_ curriculum.Status]"}
	    {before_html <b>}
	    {after_html  </b>}
	}
    }

    # Extend the form with assignee widgets (only in edit or display mode).
    workflow::case::role::add_assignee_widgets -case_id $case_id -form_name curriculum
    
    # FIXME. Get values for the role assignment widgets.
    workflow::case::role::set_assignee_values -case_id $case_id -form_name curriculum
    
    # Set values for comment field.
    # Is before_html the right placement of this? Perhaps we should link
    # to a different page where we show the case log?
    set user_name [person::name -person_id $user_id]
    element set_properties curriculum comment \
	-before_html "[workflow::case::get_activity_html -case_id $case_id][ad_decode $action_id "" "" "<p><b>[_ curriculum.lt_action_pretty_name_by]</b></p>"]"
    
    # Single-curriculum notifications link.
    set notification_link [curriculum::get_watch_link -curriculum_id $curriculum_id]
    foreach { notification_url notification_label notification_title } $notification_link {
	# Do nothing!
    }
    
}

# More fixed form elements
# FIXME. Datatype "search" does not appear to work with ad_form very well.
# Do we need an owner anyway when we're using workflow roles?
ad_form -extend -name curriculum -form {
    {owner_id:search,optional
	{mode $element_mode}
	{result_datatype integer}
	{label "[_ curriculum.Owner]"}
	{options $users_list}  
	{search_query {[db_map user_search]}}
    }
}

####
#
# Done defining the form elements.
#
####

# Set editable fields. Must do this after the "-form" block!
if { !$new_p && $wf_action_exists_p } {

    foreach field [workflow::action::get_element -action_id $action_id -element edit_fields] { 
	element set_properties curriculum $field -mode edit 
    }
}    

ad_form -extend -name curriculum -edit_request {

    curriculum::get -curriculum_id $curriculum_id -array curriculum_array

    template::util::array_to_vars curriculum_array

    set description [template::util::richtext::create $description $desc_format]

    # Hide elements that should be hidden because of a certain wf status.
    foreach element $curriculum_array(hide_fields) {
	element set_properties curriculum $element -widget hidden
    }
    
} -validate {

    {name
	{[string length $name] <= [set length 200]}
	"[_ curriculum.lt_Name_may_not_be_more_]"
    }

} -new_data {

    curriculum::new \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-comment [template::util::richtext::get_property contents $comment] \
	-comment_format [template::util::richtext::get_property format $comment] \
	-owner_id $owner_id \
	-package_id $package_id
    
} -edit_data {

    curriculum::edit \
	-curriculum_id $curriculum_id \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-comment [template::util::richtext::get_property contents $comment] \
	-comment_format [template::util::richtext::get_property format $comment] \
	-action_id $action_id \
	-array curriculum_array

} -after_submit {

    # Force the curriculum bar to update.
    #curriculum::elements_flush

    ad_returnredirect $return_url
    ad_script_abort

}


ad_return_template
