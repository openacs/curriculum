ad_library {
    
    Curriculum Library (Misc Procs).
    
    @creation-date 2003-05-30
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$
    
}


namespace eval curriculum {}


ad_proc -public curriculum::conn {
    args
} {
    set flag [lindex $args 0]
    if { ![string equal "-" [string index $flag 0]] } {
	# Insert the implicit "-get" flag explicitly at the beginning of args
	# so that the switch statement below may always rely on it to exist.
	set var $flag
	set flag "-get"
	set args [linsert $args 0 $flag]
    } else {
	set var [lindex $args 1]
    }

    switch -- $flag {
	-set {
	    set value [lindex $args 2]

	    if { [empty_string_p [set subsite_id [lindex $args 3]]] } {
		set subsite_id [conn subsite_id]
	    }

	    return [util_memoize_seed [list list $var $subsite_id] $value]
	}	    
	-flush {
	    # Flush the cache for key $var in the specified subsite.

	    if { [empty_string_p [set subsite_id [lindex $args 2]]] } {
		set subsite_id [conn subsite_id]
	    }

	    util_memoize_flush [list list $var $subsite_id]
	}
	-nocache {
	    # Call ourselves with the -flush flag to flush the cache and then
	    # call ourselves again with the -get flag to return fresh data.
	    conn -flush $var
	    conn -get $var
	}
	-get {
	    switch -- $var {
		subsite_id {
		    # Get the closest ancestor package_id for package_key "acs-subsite" or "dotlrn".
		    # We can't use "ad_conn subsite_id" because .LRN classes and clubs aren't
		    # instances of "acs-subsite" but instances of "dotlrn", and we need to be able
		    # to scope our cache based on those instances too ...

		    # Still using this proc despite the fact that it is deprecated. The new proc 
		    # (site_node::closest_ancestor_package), which supersedes this one, is a lot slower.
		    return [site_node_closest_ancestor_package -url [ad_conn url] { acs-subsite dotlrn }]
		}
		package_id -
		package_url -
		subsite_url {

		    set subsite_id [conn subsite_id]
		    set proc [list get_package_info -subsite_id $subsite_id]

		    return [get_info -var $var -subsite_id $subsite_id -proc $proc]

		}			
		curriculum_count {
		    
		    set proc [list get_curriculum_stats]

		    return [get_info -var $var -proc $proc]

		}
		curriculum_ids -
		curriculum_names {

		    # This block returns a list.

		    set proc [list get_curriculum_info]

		    return [get_info -var $var -proc $proc]

		}
		default {
		    error "curriculum::conn: unknown var $var"
		}
	    }
	}
	default {
	    error "curriculum::conn: unknown flag $flag"
	}
    }
}


ad_proc -private curriculum::get_info {
    -var:required
    {-subsite_id ""}
    -proc:required
} {    
    if { [empty_string_p $subsite_id] } {
	set subsite_id [conn subsite_id]
    }

    if { [util_memoize_cached_p [list list $var $subsite_id]] } {
	# Return the cached value for $var in this particular subsite.
	return [util_memoize [list list $var $subsite_id]]
    }

    if { [empty_string_p [set result [eval $proc]]] } {
	return {}
    }
    array set info $result
    foreach name [array names info] {
	util_memoize_seed [list list $name $subsite_id] $info($name)
    }
    
    return $info($var)
}


#####
#
# Cached package info procs
# 
#####


ad_proc -private curriculum::get_package_info {
    {-subsite_id ""}
} {
    if { [empty_string_p $subsite_id] } {
	set subsite_id [conn subsite_id]
    }

    set package_key [package_key]

    set info(subsite_url) [site_node::get_url_from_object_id -object_id $subsite_id]
    
    # Note! Returns a list of curriculum package_ids mounted directly under the given 
    # node. Of course, only one curriculum instance is allowed under a "curriculum subsite" 
    # (acs-subsite or dotlrn instance) so it should never return more than one element.
    set subsite_node_id [site_node::get_node_id -url $info(subsite_url)]
    set info(package_id) [site_node::get_children \
			      -package_key $package_key \
			      -element package_id \
			      -node_id $subsite_node_id]
    
    if { [llength $info(package_id)] > 1 } {
	
	# Get the latest curriculum instance that was mounted.
	set latest_package_id [db_string max_curriculum_package_id {*SQL*}]
	set node_id [site_node::get_node_id_from_object_id -object_id $latest_package_id]
	set export_vars [export_vars -url { node_id { confirm_p 1 } }]
	
	set delete_url "/admin/applications/application-delete?$export_vars"
	
	ad_return_error "[_ curriculum.lt_More_than_one_instanc]" "[_ curriculum.lt_Please_delete_the_ext]"
	
	ad_script_abort
    }
    
    set info(package_url) [site_node::get_url_from_object_id -object_id $info(package_id)]
    
    return [array get info]
}


#####
#
# Cached curriculum info procs
# 
#####


ad_proc -private curriculum::get_curriculum_info {
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }

    
    set list_of_ns_sets [db_list_of_ns_sets curriculum_info {*SQL*}]
    
    if { [empty_string_p $list_of_ns_sets] } {
	return {}
    }

    set columns [ad_ns_set_keys [lindex $list_of_ns_sets 0]]

    foreach column $columns {
	lappend result $column
	foreach ns_set $list_of_ns_sets {
	    lappend sublist [ns_set get $ns_set $column]
	}
	lappend result $sublist
    }

    return $result
    
}


#####
#
# Cached curriculum stats procs
# 
#####


ad_proc -private curriculum::get_curriculum_stats {
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }
    
    if { [db_0or1row curriculum_stats {*SQL*} -column_array stats] } {
	return [array get stats]
    } else {
	error "curriculum::get_curriculum_stats didn't return any row"
    }
}


#####
#
# Curriculum bar procs
# 
#####


ad_proc -public curriculum::enabled_elements_memoized {
    {-package_id ""}
} {
    # "ad_conn package_id" can't be used because occasionally our proc gets
    # called from a filter, and filters don't seem to handle such calls.
    # Besides, we are sometimes called from outside our package borders which
    # would have given us the wrong package_id anyway.

    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }

    set user_id [ad_conn user_id]

    # Cache the bar per curriculum instance and user.
    return [util_memoize [list curriculum::enabled_elements -package_id $package_id -user_id $user_id]]
}    


ad_proc -private curriculum::enabled_elements {
    {-package_id ""}
    -user_id:required
} {
    This is designed to be called within a memoization proc.
} {

    # The list this proc returns will be cached and used for (at least) two purposes:
    # A) To produce the curriculum bar multirow.
    # B) To check elements against a cookie value to mark if an element has been visited.
    # Either way, we only keep elements from curriculums in workflow state "published"
    # in the list.

    # "workflow::state::fsm::get_id" doesn't return the id of state "published" if there
    # is no workflow, and there isn't one for "/" ... That is why we feed this proc the
    # package_id "curriculum::conn" gave us, which is the package_id of the curriculum
    # instance in this subsite, regardless of which node we requested within the subsite.

    if { ![empty_string_p $package_id] } {
	
	# During normal operation, when a curriculum instance is mounted under the current
	# subsite, the given package_id should be trustworthy ...

	set workflow_id [curriculum::get_instance_workflow_id -package_id $package_id]
	
	set state_id [workflow::state::fsm::get_id \
			  -workflow_id $workflow_id \
			  -short_name published]

    } else {

	# State id "0" does not exist, hence our query won't return any rows. Just what
	# we want if there's no curriculum mounted in the subsite (as indicated by the
	# empty package_id).

	set state_id 0
    }
    
    # If the user is logged in, the "cu_user_curriculum_map" will give an indication
    # as to which curriculums are UNWANTED by the user. If the user is not logged in
    # we're showing all (published) curriculums in the instance (there should be no
    # user_id "0" in the mapping table).

    # FIXME. The PG version ought to look more like the Oracle version.
    set ns_sets [db_list_of_ns_sets element_ns_set_list {*SQL*}]
    
    return [util_list_of_ns_sets_to_list_of_lists -list_of_ns_sets $ns_sets]
}


# FIXME. Integrate with "enabled_elements" above?
ad_proc -private curriculum::user_elements {
    {-package_id ""}
} {
    Not meant to be cached.
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }
    
    set workflow_id [curriculum::get_instance_workflow_id -package_id $package_id]

    # We need to get elements of published curriculums.
    set state_id [workflow::state::fsm::get_id \
		      -workflow_id $workflow_id \
		      -short_name published]

    # We need user_id to join against the mapping table that holds information
    # on what curriculums (in the package instance) the user cares about.
    set user_id [ad_conn user_id]

    set truncation_length [parameter::get -package_id $package_id \
			       -parameter DescTruncLength -default 200]

    set ns_sets [db_list_of_ns_sets user_element_ns_set_list {*SQL*}]

    return [util_list_of_ns_sets_to_list_of_lists -list_of_ns_sets $ns_sets]
}


ad_proc -public curriculum::elements_flush {
    {-thorough:boolean 0}
    {-package_id ""}
    {-user_id ""}
} {
    Flushes the memoized proc that gets the element_id, url and name for the curriculum bar(s).
    Should be run upon ceation, enabling, disabling or deletion of a curriculum or an element.
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }

    if { $thorough_p } {

	# Flush the cache for all users (including non-registered) in this package instance.
	util_memoize_flush_regexp [list curriculum::enabled_elements -package_id $package_id]

    } else {
	
	if { [empty_string_p $user_id] } {
	    set user_id [ad_conn user_id]
	}
	
	util_memoize_flush [list curriculum::enabled_elements -package_id $package_id -user_id $user_id]
    }
}


ad_proc -public curriculum::get_bar {
    -bar_p:required
    {-package_id ""}
} {
    Returns a string containing the HTML for a curriculum bar that shows the amount of progress a user has made on a curriculum.
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }

    # Is the curriculum bar even activated? If not, return the empty string.
    if { $bar_p && ![parameter::get -package_id $package_id -parameter ShowCurriculumBarP -default 1] } {
	return {}
    }

    # Check cookie to make sure this person isn't finished.
    set input_cookie [ad_get_cookie [get_cookie_name -package_id $package_id]]

    # Compare what the user has seen to what is in the full curriculum(s)
    # to put in checkboxes; we check the output headers first and then 
    # the input headers, in case there is going to be a newer value.
    set output_cookie [get_output_cookie -package_id $package_id]

    if { [empty_string_p $output_cookie] } {
	get_bar_internal -bar_p $bar_p -package_id $package_id $input_cookie
    } else {
	get_bar_internal -bar_p $bar_p -package_id $package_id $output_cookie
    }
}


ad_proc -private curriculum::get_bar_internal {
    -bar_p:required
    -package_id:required
    cookie_value
} {
    if { $bar_p } {

	# Get the cached curriculum list for the bar.
	set rows [enabled_elements_memoized -package_id $package_id]

    } else {

	# Get the NOT cached curriculum list for index page use.
	set rows [user_elements -package_id $package_id]

    }

    # If the user is logged in the "cu_user_curriculum_map" will be checked
    # for unwanted curriculums. OTOH, if the user is not logged in, we're
    # showing all (published) curriculums.
    # See "curriculum::enabled_elements" (the non-cached version).
    
    if { [llength $rows] == 0 } {
	# Publisher hasn't published any curriculum.
	return {}
    }

    set manipulated_rows {}
    set completed_p 1
    array set first_row [lindex $rows 0]
    set this_curriculum $first_row(curriculum_id)
    set element_ids [list]

    foreach row $rows {
	array set info $row

	if { $info(curriculum_id) != $this_curriculum } {
	    # Next curriculum.
	    set this_curriculum $info(curriculum_id)
	    
	    foreach element_id $element_ids {
		lappend manipulated_rows [concat $info_row($element_id) checked_p $checked_p($element_id) completed_p $completed_p]
	    }
	    
	    # Empty the list.
	    set element_ids [list]
	    set completed_p 1
	}
	
	# Recorded elements.
	lappend element_ids $info(element_id)
	# Remember every row.
	set info_row(${info(element_id)}) $row
	
	# Check in cookie whether the element has been visited or not.
	if { [lsearch -exact $cookie_value $info(element_id)] != -1 } {
	    set checked_p(${info(element_id)}) 1
	} else {
	    set checked_p(${info(element_id)}) 0
	    set completed_p 0
	}

    }
    
    # Play the recording for the last curriculum.
    foreach element_id $element_ids {
	lappend manipulated_rows [concat $info_row($element_id) checked_p $checked_p($element_id) completed_p $completed_p]
    }
    
    # Let's turn this list into a multirow datasource in the <include>
    # template's environment. 3 levels up, that is.
    
    template::util::list_to_multirow elements $manipulated_rows 3
}


# FIXME. Not used yet.
ad_proc -public curriculum::element_visited_p {
    element_id
} {
    # FIXME.
    # I need to think harder about the logic here.
    
    set survey_installed_p 0
    set survey_required_p 1
    set survey_graded_p 1
    set survey_passed_p 1
    set cookie [ad_get_cookie [get_cookie_name]]
    
    if { $survey_installed_p && $survey_required_p } {
	if { $survey_graded_p && !$survey_passed_p} {
	    # indicate status "unpassed"
	    return -1
	} elseif { $survey_graded_p && $survey_passed_p } {
	    # checked
	    return 1
	} else {
	    # 
	}
    } else {
	# Has the user visited this element?
	if { [lsearch -exact $cookie $element_id] == -1 } {
	    return 0
	}
	return 1
    }
}


#####
#
# Cookie procs
# 
#####


ad_proc -public curriculum::get_output_cookie {
    {-package_id ""}
} {
    Returns the value of the CurriculumProgress cookie that will be written to the client, or empty string if none is in the outputheaders ns_set
} {
    if [empty_string_p [ns_conn outputheaders]] {
	return {}
    }

    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }
    
    return [ad_get_cookie -include_set_cookies t [get_cookie_name -package_id $package_id]]
}


ad_proc -public curriculum::get_cookie_name {
    {-package_id ""}
} {
    Returns the package_id-dependent name of our cookie (CurriculumProgress_****).
} {
    if { [empty_string_p $package_id] } {
	set package_id [conn package_id]
    }

    return CurriculumProgress_$package_id
}


ad_proc -public curriculum::curriculum_progress_cookie_value {
    -package_id:required
    {old_value ""}
    {new_element ""}
} {
    If not args are supplied, returns the initial value for the CurriculumProgress_**** cookie.
    If old_value and new_element are supplied, returns an appropriate new cookie value.
} {
    if { [empty_string_p $old_value] && [empty_string_p $new_element] } {
	return "start"
    }

    if { [string equal "start" $old_value] } {
	return [list $new_element]
    }

    if { [string equal "reset_one_curriculum" $old_value] } {
	set curriculum_id $new_element
	return [reset_one_curriculum -curriculum_id $curriculum_id -package_id $package_id]
    }

    set tentative_result [lappend old_value $new_element]

    return $tentative_result	
}


ad_proc -private curriculum::reset_one_curriculum {
    -curriculum_id:required
    -package_id:required
} {
    Restart just one specific curriculum (uncheck its checkboxes).
} {
    set cookie [ad_get_cookie [get_cookie_name -package_id $package_id]]

    db_foreach element_ids {*SQL*} {
	if { [set cookie_index [lsearch -exact $cookie $element_id]] != -1 } {
	    set cookie [lreplace $cookie $cookie_index $cookie_index]
	}
    }

    if { [empty_string_p $cookie] } {
	return "start"
    } else {
	return $cookie
    }
}


#####
#
# Filter procs
# 
#####


ad_proc -public curriculum::curriculum_filter {
    conn
    package_id
    why
} {
    We run this filter on registered url patterns for GETs in conjunction 
    with "curriculum_bar" which gets called from the default-master.
    This will run after a registered url has been served.
} {
    # We don't want an error in the script to interrupt page service
    if { [catch { curriculum_filter_internal -package_id $package_id } errmsg] } {
	ns_log Error "\"curriculum::curriculum_filter_internal -package_id $package_id\" coughed up: $errmsg"
    }

    return "filter_ok"
}


ad_proc -private curriculum::curriculum_filter_internal {
    -package_id:required
} {
    set cookie_name [get_cookie_name -package_id $package_id]
    set cookie [ad_get_cookie $cookie_name]

    if { [empty_string_p $cookie] } {
	# No cookie.
	if { [parameter::get -package_id $package_id \
		  -parameter AutomaticBarActivationP -default 1] } {
	    ad_set_cookie -replace t \
		$cookie_name [curriculum_progress_cookie_value -package_id $package_id]
	}
	return
    }

    # We have a cookie.
    # See what the user is looking at right now and compare
    # to curriculums to consider adding to cookie.
    set list_of_lists [curriculum::enabled_elements_memoized -package_id $package_id]
    set current_url [ad_conn url]
    # Check for query vars. URL decode the vars here if they exist, and do the same
    # when we compare current_url to the element URLs to ensure consistency ...
    if { ![empty_string_p [set query_vars [ad_conn query]]] } {
	append current_url "?[ns_urldecode $query_vars]"
    }
    
    foreach list $list_of_lists {
	array set info $list

	# Is the user visiting this curriculum element url?
	set element_url [ns_urldecode $info(url)]

	if { ![string equal $current_url $element_url] } {

	    # We're doing this since given a dir "/foo/", both "/foo/" and "/foo" will take 
	    # us there, and both ways of getting there should result in a checked box.
	    
	    # Is the visited URL a "directory"?
	    if { ![string equal "/" [string range $current_url end end]] } {
		continue
	    }
	    
	    if { ![string equal $element_url [string range $current_url 0 end-1]] } {
		continue
	    }
	}
	
	
	# See if this element isn't already in user's cookie.
	set element_id $info(element_id)
	
	if { [lsearch -exact $cookie $element_id] == -1 } {
	    set cookie [curriculum_progress_cookie_value -package_id $package_id $cookie $element_id]
	    ad_set_cookie -replace t $cookie_name $cookie
	    
	    # If the user is logged in, we'll also want to record
	    # the additional element in the database.
	    
	    if { [set user_id [ad_conn user_id]] } {
		# Insert, but only if there isn't a row already there.
		set curriculum_id $info(curriculum_id)
		db_dml map_insert {*SQL*}
	    }			
	}
    }	    
}
