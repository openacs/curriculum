ad_page_contract {

    enable (activate) curriculum element

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
    element_id:integer,notnull
}

curriculum::element::enable -element_id $element_id

# Force the curriculum bar to reflect the reality.
curriculum::elements_flush

ad_returnredirect "."
