ad_page_contract {

    delete (archive) curriculum element

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
    element_id:integer,notnull
}

curriculum::element::delete -element_id $element_id

# Force the curriculum bar to reflect the reality.
# Not needed because we do this when we disable an element.
#curriculum::elements_flush

ad_returnredirect "."
