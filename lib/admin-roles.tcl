ad_page_contract {

    Add/edit/view default assignees.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2004-02-06
    @cvs-id $Id$

} {
    {return_url "."}
} -properties {
    title:onevalue
    context:onevalue
}

set title "[_ curriculum.Default_Assignees]"
set context [list $title]

set user_list [curriculum::users_get_options]
set search_query [db_map dbqd.curriculum.lib.curriculum-ave.user_search]

ad_form -name default_assignees \
    -cancel_url $return_url \
    -mode display \
    -form {
	{default_editor:search,optional
	    {result_datatype integer}
	    {label "[_ curriculum.Editor]"}
	    {options $user_list}
	    {search_query $search_query}
	}
	{default_publisher:search,optional
	    {result_datatype integer}
	    {label "[_ curriculum.Publisher]"}
	    {options $user_list}
	    {search_query $search_query}
	}
    } -on_request {

	set default_editor [curriculum::default_editor::get_assignees {} {} {}]
	set default_publisher [curriculum::default_publisher::get_assignees {} {} {}]

    } -on_submit {
	
	set package_id [curriculum::conn package_id]

	db_dml update_default_assignees {*SQL*}
	
    } -after_submit {
	
	#ad_returnredirect $return_url
	#ad_script_abort
	
    }

ad_return_template
