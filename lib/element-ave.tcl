ad_page_contract {

    Add/edit/view curriculum element.

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
    set write_p 1

    set form_mode edit
    set title "[_ curriculum.Add_Element]"

    # Workaround for the default value of "url";
    # http://openacs.org/bugtracker/openacs/bug?bug%5fnumber=804
    set url $subsite_url

} else {

    ####
    # Edit/display element.
    ####

    # Since we permit several curriculums per package instance we
    # require permission on curriculum_id, not package_id basis.

    set write_p [permission::permission_p -object_id $curriculum_id -privilege write]

    set form_mode display
    set curriculum_name [acs_object_name $curriculum_id]
    set element_name [acs_object_name $element_id]
    set title "[_ curriculum.lt_element_name_part_of_]"
}

set context [list $title]

ad_form -name element \
    -export {curriculum_id} \
    -cancel_url $return_url \
    -mode $form_mode \
    -has_edit [expr !$write_p] \
    -form {
	element_id:key
	{name:text
	    {label "[_ curriculum.Name]"}
	    {html {size 50}}
	}
	{description:richtext,optional
	    {label "[_ curriculum.Description]"}
	    {help_text "[_ curriculum.lt_This_text_should_desc_1]"}
	    {html {rows 10 cols 50 wrap soft}}
	}
	{url:text(text),optional,nospell
	    {label "[_ curriculum.URL]"}
	    {help_text "[_ curriculum.lt_A_leading_http_indica]"}
	    {html {size 50}}
	}
    }

#if { [exists_and_not_null element_id] } {
#    if { ![empty_string_p [category_tree::get_mapped_trees $package_id]] } {
#	ad_form -extend -name element -form {
#	    {category_ids:integer(category),multiple {label "E Categories"}
#		{html {size 7}} {value {$element_id $package_id}}
#	    }
#	}
#    }
#} else {
#    if { ![empty_string_p [category_tree::get_mapped_trees $package_id]] } {
#        ad_form -extend -name element -form {
#            {category_ids:integer(category),multiple,optional {label "A Categories"}
#                {html {size 7}} {value {}}
#            }
#        }
#    }
#}

# SWC (Site-wide categories):
category::ad_form::add_widgets \
    -container_object_id $package_id \
    -categorized_object_id [value_if_exists entry_id] \
    -form_name element \
    -help_text "Help text here!"

ad_form -extend -name element -on_request {
    # Nothing, really
} -edit_request {

    curriculum::element::get -element_id $element_id -array element_array

    template::util::array_to_vars element_array

    set description [list $description $desc_format]

} -validate {

    {name
	{[string length $name] <= [set length 200]}
	"[_ curriculum.lt_Name_may_not_be_more_]"
    }
    {url
	{[string length $url] <= [set length 400]}
	"[_ curriculum.lt_URL_may_not_be_more_t]"
    }
    
} -on_submit {

    # SWC Collect categories from all the category widgets
    set category_ids [category::ad_form::get_categories \
                          -container_object_id $package_id]
    
} -new_data {

    curriculum::element::new \
	-element_id $element_id \
	-curriculum_id $curriculum_id \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-url [ad_decode $url "" "[curriculum::conn package_url]element-ave?curriculum_id=$curriculum_id&element_id=$element_id" $url] \
	-enabled_p t

    # SWC
    category::map_object -remove_old -object_id $element_id $category_ids
    
} -edit_data {

    curriculum::element::edit \
	-element_id $element_id \
	-name $name \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
	-url [ad_decode $url "" "[curriculum::conn package_url]element-ave?curriculum_id=$curriculum_id&element_id=$element_id" $url]
    
    # SWC
    category::map_object -remove_old -object_id $element_id $category_ids
    
} -after_submit {

    # Force the curriculum bar to update.
    curriculum::elements_flush
    
    ad_returnredirect $return_url
    ad_script_abort

}

# OLA HACK (borrowed from LARS): Make the URL element a real link
if { ![form is_valid element] } {
        
    if { [string equal -length 7 "http://" [set url [element get_value element url]]] } {
	set position [parameter::get -package_id $package_id -parameter ExternalSiteBarPosition -default bottom]
	set export_vars [export_vars -url {curriculum_id element_id position}]
	
	set link "<a href=\"[curriculum::conn package_url]ext?$export_vars\" target=\"_top\" title=\"[_ curriculum.Visit]\">$url</a>"
    } else {
	set link "<a href=\"$url\">$url</a>"
    }

    element set_properties element url -display_value $link
}

# If there is a spelling error you want to display the form in edit mode.
if { [form is_submission element] } {
    form set_properties element -mode edit
}


ad_return_template
