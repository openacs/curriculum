ad_page_contract {

    Curriculum add-published-curriculums-to-bar page

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-31
    @cvs-id $Id$

} {
    curriculum_id:optional
    {return_url "."}
}

set package_id [curriculum::conn package_id]

# Adding is actually obtained by deleting one or more rows from the table
# "cu_user_curriculum_map", which holds the row(s) the user DOESN'T want.

if { [info exists curriculum_id] } {
    # Just add one particular curriculum.
    set extra_where_clause { and curriculum_id = :curriculum_id }
} else {
    # Add all the curriculums there is.
    set extra_where_clause {}
}

if [set user_id [ad_conn user_id]] {    

    db_transaction {
	db_dml add_published_curriculums_to_bar {*SQL*}

	# Force the bat to update.
	curriculum::elements_flush
    }

}

ns_returnredirect $return_url
