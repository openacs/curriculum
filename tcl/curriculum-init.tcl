ad_library {

    Curriculum Initialization

    @creation-date 2003-06-02
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}

set package_key [curriculum::package_key]

db_foreach get_all_curriculum_package_ids {*SQL*} {

    # Register the filter that keeps track of which elements the user has seen.
    curriculum::register_filter -package_id $package_id
}
