ad_library {

    Curriculum Initialization

    @creation-date 2003-06-02
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}

# FIXME. Most likely we should only get the package_ids that have
# curriculums which are published.
set package_ids [db_list get_all_curriculum_package_ids {*SQL*}]

foreach package_id $package_ids {

    # Register the filter that keeps track of which elements the user has seen.
    # If no "UrlPatternsToFilter" parameter is detected we register
    # this filter for all urls in this curriculum instance.
    
    set url_patterns [parameter::get -package_id $package_id \
			  -parameter UrlPatternsToFilter \
			  -default *]
    
    foreach url_pattern [split [string trim $url_patterns]] {
	ns_log Notice "Installing curriculum filter for $url_pattern in package_id $package_id"
	ad_register_filter postauth GET $url_pattern curriculum::curriculum_filter
    }

}
