ad_page_contract {

    Curriculum listing widget for users.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-31
    @cvs-id $Id$

} {
} -properties {
    logged_in_p:onevalue
}

set logged_in_p [ad_conn user_id]

#set curriculum_count [curriculum::conn -nocache curriculum_count]

# Upvar the "elements" multirow datasource for the curriculum bar.
curriculum::get_bar -bar_p 0

ad_return_template
