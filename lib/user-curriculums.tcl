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

set package_id [curriculum::conn package_id]

# Top, bottom, left, right.
set position [parameter::get -package_id $package_id -parameter ExternalSiteBarPosition -default bottom]

ad_return_template
