ad_page_contract {

    Add/edit curriculum element.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-26
    @cvs-id $Id$

} {
    element_id:integer,optional
    curriculum_id:integer
    {return_url "."}
    {mode:nohtml,optional "edit"}
} -properties {
    title:onevalue
    context:onevalue
}

set package_id [curriculum::conn package_id]
set subsite_url [curriculum::conn subsite_url]

if { [set new_p [ad_form_new_p -key element_id]] } {

    ####
    # New element.
    ####

    permission::require_permission -object_id $curriculum_id -privilege write

    set form_mode edit
    set title "Add Element"

} else {

    ####
    # Edit/display element.
    ####

    # Since we permit several curriculums per package instance we
    # require permission on curriculum_id, not package_id basis.
    permission::require_permission -object_id $curriculum_id -privilege write

    set form_mode display
    set curriculum_name [acs_object_name $curriculum_id]
    set element_name [acs_object_name $element_id]
    set title "Edit Element \"$element_name\" (part of $curriculum_name)"
}

set context {$title}

ad_form -name element -export {curriculum_id} -cancel_url $return_url -mode $form_mode -form {
    element_id:key
    {name:text
	{label Name}
	{html {size 50}}
    }
    {description:richtext
	{label Description}
	{html {rows 10 cols 50 wrap soft}}
	optional
    }
    {url:text(text)
	{label URL}
	{help_text "A leading \"http://\" indicates that the URL is external."}
	{html {size 50}}
	{value $subsite_url}
    }
}

ad_form -extend -name element -edit_request {

    curriculum::element::get -element_id $element_id -array element_array

    template::util::array_to_vars element_array

    set description [list $description $desc_format]

} -validate {

    {name
	{[string length $name] <= [set length 200]}
	"Name may not be more than $length characters long."
    }
    {url
	{[string length $url] <= [set length 400]}
	"URL may not be more than $length characters long."
    }
    
} -new_data {
    
    curriculum::element::new \
	-curriculum_id $curriculum_id \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-url $url \
	-enabled_p t

} -edit_data {

    curriculum::element::edit \
	-element_id $element_id \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-url $url

} -after_submit {

    # Force the curriculum bar to update.
    curriculum::elements_flush
    
    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template
