ad_page_contract {

    Horizontal bar on external pages.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-10
    @cvs-id $Id$

} {
    return_url
    destination_url
} -properties {
    return_url:onevalue
    destination_url:onevalue
    ad_url:onevalue
}

# Solely used to set the return_url and destination_url for the "bar" frame.
set ad_url [ad_url]
