ad_page_contract {

    Curriculum listing widget for users.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-31
    @cvs-id $Id$

} {
} -properties {
    logged_in_p:onevalue
}

# package_id may or may not be provided as an attribute with the <include> tag.
if { ![info exists package_id] } {
    set package_id [curriculum::conn package_id]
    # Use the ordinary template (user-curriculums.adp).
    set template ""
} else {
    # package_id provided.
    # Assume it came from the portlet <include> and use the "summary" template.
    set community_name [site_nodes::get_parent_name -package_id $package_id]
    set indent [string repeat "&nbsp;" 4]
    set template /packages/curriculum/lib/summary
}

set logged_in_p [ad_conn user_id]

# Upvar the "elements" multirow datasource for the curriculum bar.
curriculum::get_bar -bar_p 0 -package_id $package_id

# Top, bottom, left, right.
set position [parameter::get -package_id $package_id -parameter ExternalSiteBarPosition -default bottom]

# Prefix relevant urls with @url@ and they'll work when <include>d
# into the dotLRN portlet.
set url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]

set return_url [ad_return_url]
set return_url_export [export_vars -url return_url]

ad_return_template $template
