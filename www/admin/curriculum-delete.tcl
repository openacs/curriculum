ad_page_contract {

    Delete a curriculum.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-06-03
    @cvs-id $Id$

} {
    curriculum_id:integer,notnull
}

curriculum::delete -curriculum_id $curriculum_id

# Force the curriculum bar to reflect the reality.
# Not needed since we do this when we disable a curriculum,
# which we always do before we delete it.
#curriculum::elements_flush

ad_returnredirect "."
