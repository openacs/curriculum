ad_page_contract {

    Curriculum reset page

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
    curriculum_id:optional
    {return_url "."}
}

set package_id [curriculum::conn package_id]

if { [info exists curriculum_id] } {
    set new_cookie [curriculum::curriculum_progress_cookie_value \
			-package_id $package_id reset_one_curriculum $curriculum_id]

    set extra_where_clause { and curriculum_id = :curriculum_id }

} else {

    set new_cookie [curriculum::curriculum_progress_cookie_value \
			-package_id $package_id]

    set extra_where_clause {}
}

if [set user_id [ad_conn user_id]] {    
    db_dml start_over {*SQL*}
}

# Write the new cookie.
ad_set_cookie -replace t \
    [curriculum::get_cookie_name] $new_cookie


ns_returnredirect $return_url
