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
set package_id [curriculum::conn package_id]

set logged_in_p [ad_conn user_id]

set return_url [ad_return_url]
set return_url_export [export_vars -url return_url]

# Upvar the "elements" multirow datasource for the curriculum bar.
curriculum::get_bar -bar_p 1

# Top, bottom, left, right.
set position [parameter::get -package_id $package_id -parameter ExternalSiteBarPosition -default bottom]

# Horizontal or vertical.
set direction [parameter::get -package_id $package_id -parameter BarDirection -default horizontal]

ad_return_template /packages/curriculum/lib/bar-$direction
