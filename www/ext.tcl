ad_page_contract {

    Clickthrough page

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-28
    @cvs-id $Id$

} {
    element_id:integer
    curriculum_id:integer
    {return_url "."}
    {position "bottom"}
}
# The positions are:
# "top" (horizontal)
# "bottom" (horizontal)
# "left" (vertical).
# "right" (vertical).

set package_id [curriculum::conn package_id]

set destination_url [db_string get_destination_url {*SQL*}]

####
#
# Integration with the Clickthrough package.
#
####

# You may want to uncomment the below if you decide to install Clickthrough.

# The URL should be guaranteed to be external already since we were sent
# to this script, but it doesn't hurt to check again ...
#if { [string equal -length 7 "http://" $destination_url] } {
#
#    set destination_url [clickthrough_href $destination_url]
#}

set input_cookie [ad_get_cookie [curriculum::get_cookie_name]]

if { ![empty_string_p $input_cookie] && [lsearch $input_cookie $element_id] == -1} {

    set new_cookie_value [curriculum::curriculum_progress_cookie_value \
			      -package_id $package_id $input_cookie $element_id]

    ad_set_cookie [curriculum::get_cookie_name] $new_cookie_value
}

if { [set user_id [ad_conn user_id]] } {
    # FIXME. Port this query to Oracle.
    db_dml insert_into_map_table {*SQL*}
}

ad_return_template