ad_library {
    
    Curriculum Library (Misc Procs).
    
    @creation-date 2003-05-30
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$
    
}


namespace eval curriculum {}


ad_proc -public curriculum::package_keys {
} {
    Builds a list that will be used as an argument to "site_node_closest_ancestor_package".
    If .LRN is not installed it will be set to "acs_subsite" and if it is installed, 
    "dotlrn" will be prepended to the list. The Underlying reason we do this is because
    we want to allow one Curriculum instance under each dotLRN instance, if dotLRN is
    installed. And if it is installed it should take precedence over acs_subsite.
} {
    set package_keys [list acs-subsite]
    
    if { [apm_package_installed_p dotlrn] } {
	set package_keys [concat dotlrn $package_keys]
    }

    return $package_keys
}

    
ad_proc -public curriculum::conn {
    args
} {
    set flag [lindex $args 0]
    if { [string index $flag 0] != "-" } {
	set var $flag
	set flag "-get"
	# We want the number of args to be the same as if a flag had been provided.
	set args [linsert $args 0 $flag]
    } else {
	set var [lindex $args 1]
    }

    switch -- $flag {
	-set {

	    set value [lindex $args 2]
	    return [util_memoize_seed [list $var [conn subsite_id]] $value]

	}	    
	-flush {
	    # Flush the cache for key $var.
	    util_memoize_flush [list $var [conn subsite_id]]
	}
	-nocache {
	    # Call ourselves with the -flush flag to flush the cache.
	    conn -flush $var

	    # Call ourselves with the -get flag and return fresh data.
	    conn -get $var
	}
	-get {
	    switch -- $var {
		subsite_id {
		    # "ad_conn subsite_id" does not work when called from within a filter
		    # (which we do for the curriculum bar), so we use the following instead.

		    return [site_node_closest_ancestor_package [package_keys]]
		}
		package_id -
		package_url -
		subsite_url {

		    return [get_info -proc get_package_info -var $var]

		}			
		curriculum_count {

		    return [get_info -proc get_curriculum_stats -var $var]

		}
		curriculum_ids -
		curriculum_names {

		    # This block returns a list.

		    set $var [list]
		    set list_of_ns_sets [get_curriculum_info]
		    foreach ns_set $list_of_ns_sets {
			lappend $var [ns_set get $ns_set $var]
		    }
		    set cu_conn($var) [set $var]
		    return $cu_conn($var)
		}
		default {
		    error "curriculum::conn: unknown variable $var"
		}
	    }
	}
	default {
	    error "::curriculum::conn: unknown flag $flag"
	}
    }
}


ad_proc -private curriculum::get_info {
    -proc:required
    -var:required
} {    
    set subsite_id [conn subsite_id]

# FIXME. Bypass the cache for debugging purposes.    
#    if { ![empty_string_p [set value [util_memoize [list $var $subsite_id]]]] } {
#	return $value
#    }
    
    array set info [$proc]
    foreach name [array names info] {
	util_memoize_seed [list $name $subsite_id] $info($name)
    }
    
    return $info($var)
}


# FIXME. Not used.
ad_proc -private curriculum::get_client_property {
    -table
    -proc
    -module:required
    -var:required
} {    
    set value [ad_get_client_property -cache_only t $module $var]
    
    if { ![empty_string_p $value] } {
	# Return the cached value
	return $value
    }

    # The key $var is not cached so let's cache it and the rest of the keys in
    # this block, too, while we're at it. The extra cost should be negligable.
    
    if { [info exists proc] } {
	set result_list [$proc]
    } elseif { [info exists table] } {
	set result_list [get_table_info -table $table]
    } else {
	error "::curriculum::get_info: neither -proc nor -table specified"
    }

    if { [empty_string_p $result_list] } {
	return {}
    }

    array set info $result_list
    foreach name [array names info] {
	# Call curriculum::conn and seed the cache
	conn -set $name $info($name)
    }
    return $info($var)
}


#####
#
# Cached package info procs
# 
#####


ad_proc -private curriculum::get_package_info {
} {
    set subsite_id [conn subsite_id]

    set info(package_id) [get_package_id_from_subsite_id \
			      -subsite_id $subsite_id]

    set info(package_url) [lindex [site_node::get_url_from_object_id \
				       -object_id $info(package_id)] 0]

    set info(subsite_url) [lindex [site_node::get_url_from_object_id \
				       -object_id $subsite_id] 0]
    
    return [array get info]
}


ad_proc -private curriculum::get_package_id_from_subsite_id {
    -subsite_id:required
} {
    # This call is what prevents us from mounting several curriculum instances
    # per subsite ... Maybe that could be amended?

    if { [catch {
	set package_id [site_node_apm_integration::get_child_package_id \
			    -package_id $subsite_id -package_key [package_key]]
    } errmsg] } {

	ad_return_error "Could not get child package_id" \
	    "This could be because you have mounted more than one instance 
of the Curriculum package in a subsite. Curriculum was designed to only 
be mounted once per acs-subsite. Please visit the <a href=\"/admin/site-map/\">Site-Map</a> and unmount the extra instance. However, it could also be a bug in the code.
<p>
Here is what the database said:
<p>
$errmsg"
	ad_script_abort

    } else {

	return $package_id
    }
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
    
    return [db_list_of_ns_sets curriculum_info {*SQL*}]
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
    
    db_1row curriculum_stats {*SQL*} -column_array stats
    
    return [array get stats]
}


#####
#
# Cached objective progress info procs
# 
#####

# FIXME. Not used.
ad_proc -private curriculum::get_table_info {
    -table:required
} {
    set user_id [ad_conn user_id]
    
    db_multirow -local info table_info "
	select *
	from   $table
	where  user_id = :user_id
    " {} if_no_rows {

	# Ack! No rows returned. Don't worry, we'll fall back on the defaults.
	# If this query, too, returns nothing the "curriculum::conn ???"
	# call we originated from will simply return an empty list.
	
	set magic_user_id [magic_user]

	db_0or1row info_fallback "
	    select *
	    from   $table
	    where  user_id = :magic_user_id
	" -column_array info_fallback

	return -code return [array get info_fallback]
    }

    # We have something. Convert it to array-settable list and then return it.
    return [multirow_to_list_of_attrib_lists -var_name info]
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
    # called from a filter, and filters don't seem to handle such calls. :(

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

    # The list this proc returns will be cached and used for (at least)
    # two purposes: A) To produce the curriculum bar multirow. B) To check
    # elements against a cookie value to be able to mark if an element has
    # been visited. Either way we only keep elements from curriculums in
    # workflow state "published" in the list.

    # "workflow::state::fsm::get_id" doesn't return the id of state "published" if there
    # is no workflow, and there isn't one in "/"... That is why we feed this proc the
    # package_id "curriculum::conn" gave us, which is the package_id of the curriculum
    # instance in this subsite, regardless of what node we requested within the subsite.

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
	# Flush the cache for all users (including non-logged in) in this package_id.
	util_memoize_flush_regexp [list curriculum::enabled_elements -package_id $package_id]
	return
    }
    
    if { [empty_string_p $user_id] } {
	set user_id [ad_conn user_id]
    }

    # Only bother to flush the cache if the bar is going to be displayed.
    # FIXME. Bad idea since the index page takes advantage of this cache too - not just the bar.
    #
    #if { ![parameter::get -package_id $package_id -parameter ShowCurriculumBarP -default 1] } {
    #return {}
    #}

    util_memoize_flush [list curriculum::enabled_elements -package_id $package_id -user_id $user_id]
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

#    if { $bar_p && [empty_string_p $input_cookie] } {
#	# No cookie; this person is either brand new or the browser is rejecting cookies.
#	# Let's not uglify all their pages with a bar that they can't use.
#	return {}
#    }

    # We have a cookie.
#    if { $bar_p && [string equal "finished" $input_cookie] } {
#	# User has completed curriculum, don't bother showing the bar.
#	#return {}
#    }

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
    # See "curriculum::enabled_elements" (the non-cached variant).
    
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
    If an old value and new element are supplied, returns an appropriate new cookie value.
} {
    if { [empty_string_p $old_value] && [empty_string_p $new_element] } {
	return "start"
    } elseif { [string equal "start" $old_value] } {
	if { [llength [enabled_elements_memoized -package_id $package_id]] == 1} {
	    return "finished"
	} else {
	    return [list $new_element]
	}	    
    } elseif { [string equal "reset_one_curriculum" $old_value] } {
	set curriculum_id $new_element
	return [reset_one_curriculum $curriculum_id]
    } elseif { [string equal "finished" $old_value] } {
	# If you're finished, adding a new element doesn't change that!
	return "finished"
    } else {
	set tentative_result [lappend old_value $new_element]
	if { [llength [enabled_elements_memoized -package_id $package_id]] == [llength $tentative_result] } {
	    return "finished"
	} else {
	    return $tentative_result	
	}
    }
}


ad_proc -private curriculum::reset_one_curriculum {
    curriculum_id
} {
    Restart just one specific curriculum (uncheck its checkboxes).
} {
    set cookie [ad_get_cookie [get_cookie_name]]
    set package_id [conn package_id]
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
    args
    why
} {
    We run this filter on registered urls in conjunction with
    "curriculum_bar" which gets called from the default-master.
    This will run after a registered url has been served.
} {
    # FIXME. Remove the row below and uncomment the catch statement when the package is published.
    curriculum_filter_internal $args $why    
    
    #       we don't want an error in the script to interrupt page service
    #	if [catch { curriculum_filter_internal $args $why } errmsg] {
    #	    ns_log Error "curriculum::curriculum_filter_internal coughed up $errmsg"
    #	}
    #
    
    return "filter_ok"
}


ad_proc -private curriculum::curriculum_filter_internal {
    args
    why
} {
    set cookie [ad_get_cookie [get_cookie_name]]
    set package_id [conn package_id]
    if { ![empty_string_p $cookie] } {
	# We have a cookie.
#	if { [string equal "finished" $cookie] } {
#	    # User has completed curriculum, nothing more to do.
#	    return
#	}

	# See what the user is looking at right now and compare
	# to curriculums to consider adding to cookie.
	set list_of_lists [curriculum::enabled_elements_memoized -package_id $package_id]
	set current_url [ad_conn url]
	
	foreach list $list_of_lists {
	    array set info $list
	    # Is the user visiting this curriculum element url?
	    if { [string equal $current_url $info(url)] } {
		# See if this element isn't already in user's cookie.
		set element_id $info(element_id)
		if { [lsearch -exact $cookie $element_id] == -1 } {
		    set cookie [curriculum_progress_cookie_value -package_id $package_id $cookie $element_id]
		    ad_set_cookie -replace t [get_cookie_name] $cookie
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
    } else {
	# No cookie.
	if { [parameter::get -package_id $package_id \
		  -parameter AutomaticBarActivationP -default 1] } {
	    ad_set_cookie -replace t \
		[get_cookie_name] [curriculum_progress_cookie_value -package_id $package_id]
	}
    }
}


#####
#
# Util procs (that perhaps should go back to the community)
# 
#####

# FIXME. Not used.
# Maybe this would be useful to the OpenACS community...?
ad_proc -public curriculum::multirow_to_list_of_attrib_lists {
    -var_name:required
} {
    Convert a multirow into an array-settable list of the format:
    <pre>
    col1 {row1 row2 ...} col2 {row1 row2 ...} col3 {row1 row2 ...} ...
    </pre>

    @param -var_name The name of the multirow to convert
    
    @author Ola Hansson (ola@polyxena.net)
    @creation-date January 07, 2003
} {
    upvar $var_name:rowcount rowcount $var_name:columns columns i i

    for { set i 1 } { $i <= $rowcount } { incr i } {
	upvar $var_name:$i row
	foreach column [set columns] {
	    lappend $column $row($column)
	}
    }

    foreach column $columns {
	lappend result $column [set $column]
    }

    return $result
}


# FIXME. Not used.
ad_proc -private curriculum::magic_user {
} {
    # Magic user_id.
    return [db_exec_plsql get_magic_user_id {select cu_magic_user()}]
}
