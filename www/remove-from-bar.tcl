ad_page_contract {

    Curriculum remove-published-curriculums-from-bar page

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-01
    @cvs-id $Id$

} {
    curriculum_id:integer,optional
    {return_url "."}
}

set package_id [curriculum::conn package_id]

# Removing is actually obtained by inserting a row into the table
# "cu_user_curriculum_map", which holds the row(s) the user DOESN'T want.

if [set user_id [ad_conn user_id]] {    
    
    if { [info exists curriculum_id] } {

	# Just remove the this one curriculum.
	db_dml user_curriculum_map_insert {*SQL*}
	
    } else {

	db_foreach desired_curriculums {*SQL*} {
	    db_dml user_curriculum_map_insert {*SQL*}
	} if_no_rows {
	    # Don't do a thing!
	}

    }

    # Force the bar to update.
    curriculum::elements_flush
    
}

ns_returnredirect $return_url
