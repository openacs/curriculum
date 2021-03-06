ad_library {

    Curriculum Element Library
    
    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$
    
}

namespace eval curriculum::element {}

ad_proc -public curriculum::element::new {
    {-element_id ""}
    {-curriculum_id:required}
    {-name:required}
    {-description ""}
    {-desc_format "text/html"}
    {-url ""}
    {-enabled_p t}
    {-sort_key ""}
} {

    Create a new curriculum element.

    @param element_id    The pre-fetched object-id of the element to create (normally not used).
    @param curriculum_id The object-id of the curriculum this element belongs to.
    @param name          The name of the element.
    @param description   Long description of the element.
    @param desc_format   The format of the description. Current formats are: text/enhanced text/plain text/html text/fixed-width
    @param url           Url that this element is linked to. (URLs without "http://" are considered to be relative to the page root, and no URL at all will make the element point to its info page).
    @param enabled_p     Should the element be enabled or disabled (archived) upon creation? This can be toggled afterwards.
    @param sort_key      The relative sort order of the elements in a curriculum.

    @return The object-id of the newly created curriculum element.

    @author Ola Hansson (ola@polyxena.net)

} {
    # Check for external URLs.
    set external_p [external_p -url $url]
    
    # Prepare the variables for instantiation.
    set extra_vars [ns_set create]
    oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {element_id curriculum_id name description desc_format url external_p enabled_p sort_key}
    
    # Instantiate the curriculum element.
    return [package_instantiate_object -extra_vars $extra_vars cu_element]
}


ad_proc -public curriculum::element::external_p {
    {-url:required}
} {

    Determine whether or not a curriculum element is external.

    @param url         The url to check.

    @return t or f

    @author Ola Hansson (ola@polyxena.net)

} {
    # Check for external URLs.
    if { [string equal -length 7 "http://" $url] } {
	set external_p t
    } else {
	# Try to determine if the URL belongs to another subsite.

	set subsite_id [site_node_closest_ancestor_package -url $url { acs-subsite dotlrn }]

	if { $subsite_id == [curriculum::conn subsite_id] } {
	    set external_p f
	} else {
	    set external_p t
	}
    }

    return $external_p
}


ad_proc -public curriculum::element::edit {
    {-element_id:required}
    {-name:required}
    {-description:required}
    {-desc_format:required}
    {-url ""}
} {

    Edit a curriculum element.

    @param element_id  The object-id of the element to update.
    @param name        The new name.
    @param description The new description.
    @param desc_format The format of the description. Current formats are: text/enhanced text/plain text/html text/fixed-width
    @param url         The new url.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    # Check for external URLs.
    set external_p [external_p -url $url]

    db_dml update_curriculum_element {*SQL*}
}


ad_proc -public curriculum::element::enable {
    {-element_id:required}
} {

    Enable (unarchive) a curriculum element.

    @param element_id The object-id of the element to enable.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    db_dml update_element_enabled_p {*SQL*}
}


ad_proc -public curriculum::element::disable {
    {-element_id:required}
} {

    Disable (archive) a curriculum element.

    @param element_id The object-id of the element to disable.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    db_dml update_element_disabled_p {*SQL*}
}


ad_proc -public curriculum::element::get {
    -element_id:required
    -array:required
    {-action_id {}}
} {

    Retrieve info about the element with given id into an 
    array (using upvar) in the callers scope. The
    array will contain the keys:

    <p>curriculum_id, name, url, description, desc_format, sort_key</p>
    
    @param element_id The id of the element to retrieve information about.
    @param array The name of the array in the callers scope where the information will
    be stored.
    
    @return The return value from db_0or1row. If more than one row is returned, throws an error.
    
    @author Ola Hansson (ola@polyxena.net)

} {
    upvar $array row

    if { ![db_0or1row get_element_data {*SQL*} -column_array row] } {
	# Query did not return a row. We should probably return an error instead.
	return 0
	ad_script_abort
    }

    return 1
}


ad_proc -public curriculum::element::delete {
    {-element_id:required}
} {

    Delete a curriculum element.

    @param element_id The object-id of the element to delete.

    @return Nothing.

    @author Ola Hansson (ola@polyxena.net)

} {
    db_exec_plsql delete_element {*SQL*}
}
