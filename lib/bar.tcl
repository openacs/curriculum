ad_page_contract {

    Horizontal curriculum bar.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-23
    @cvs-id $Id$

} {
} -properties {
    package_url:onevalue
    logged_in_p:onevalue
    return_url:onevalue
    elements:multirow
}

set package_url [curriculum::conn package_url]

set logged_in_p [ad_conn user_id]

set return_url [ad_conn url]
set return_url_export [export_vars -url return_url]

# Upvar the "elements" multirow datasource for the curriculum bar.
curriculum::get_bar -bar_p 1

ad_return_template
