ad_library {

    APM callback procedures.
    
    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}

namespace eval curriculum::apm {}


####
#
# APM callbacks.
#
####


ad_proc -private curriculum::apm::after_install {} {
    Package installation callback proc.
} {
    db_transaction {
        curriculum::apm::register_implementations
        curriculum::workflow_create
    }
}


ad_proc -private curriculum::apm::before_uninstall {} {
    Package un-installation callback proc.
} {
    db_transaction {
        curriculum::workflow_delete
        curriculum::apm::unregister_implementations
    }
}


ad_proc -private curriculum::apm::after_instantiate {
    {-package_id:required}
} {
    Package instantiation callback proc.
} {
    curriculum::instance_workflow_create -package_id $package_id
    
    ###
    # FIXME. We just set this up for convenience during development.
    ###
    
    db_transaction {

	set subsite_url [curriculum::conn subsite_url]

	# Create a curriculum.
	set curriculum_id [curriculum::new \
			       -name [set name "Demo Curriculum A"] \
			       -description "$name description." \
			       -package_id $package_id]
	
	# Add some elements.
	foreach { url label } [list ${subsite_url}api-doc/ "API Documentation" ${subsite_url} "Home" ${subsite_url}doc/ "Package Documentation"] {
	    curriculum::element::new \
		-curriculum_id $curriculum_id \
		-name $label \
		-description "Description of <i>$label</i>." \
		-desc_format "text/html" \
		-url $url
	}
	
	# Create a curriculum.
	set curriculum_id [curriculum::new \
			       -name [set name "Demo Curriculum B"] \
			       -description "$name description." \
			       -package_id $package_id]
	
	# Add some elements.
	foreach { url label } [list ${subsite_url}curriculum/ "Curriculum Home" ${subsite_url}admin/ "Admin" ${subsite_url}acs-service-contract/ "Service Contracts" http://openacs.org "OpenACS Website"] {
	    curriculum::element::new \
		-curriculum_id $curriculum_id \
		-name $label \
		-description "Description of <i>$label</i>." \
		-desc_format "text/fixed-width" \
		-url $url
	}
	
    }

    curriculum::elements_flush

}


ad_proc -private curriculum::apm::before_uninstantiate {
    {-package_id:required}
} {
    Package un-instantiation callback proc.
} {
    db_transaction {
	# Deletes the curriculum(s) in a package instance including
	# their data and associated workflow cases.
	curriculum::delete_instance -package_id $package_id

	curriculum::instance_workflow_delete -package_id $package_id
    }
}


#####
#
# Service contract implementations.
#
#####


ad_proc -private curriculum::apm::register_implementations {} {
    db_transaction {
        #curriculum::apm::register_capture_resolution_code_impl
        curriculum::apm::register_curriculum_owner_impl
        curriculum::apm::register_format_log_title_impl
        curriculum::apm::register_curriculum_notification_info_impl
    }
}


ad_proc -private curriculum::apm::unregister_implementations {} {
    db_transaction {

        #acs_sc::impl::delete \
                -contract_name [workflow::service_contract::action_side_effect] \
                -impl_name "CurriculumCaptureResolutionCode"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::role_default_assignees]  \
                -impl_name "CurriculumOwner"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::activity_log_format_title] \
                -impl_name "CurriculumFormatLogTitle"

        acs_sc::impl::delete \
                -contract_name [workflow::service_contract::notification_info] \
                -impl_name "CurriculumNotificationInfo"
    }
}


#ad_proc -private curriculum::apm::register_capture_resolution_code_impl {} {
#
#    set spec {
#        name "CurriculumCaptureResolutionCode"
#        aliases {
#            GetObjectType curriculum::object_type
#            GetPrettyName curriculum::capture_resolution_code::pretty_name
#            DoSideEffect  curriculum::capture_resolution_code::do_side_effect
#        }
#    }
#    
#    lappend spec contract_name [workflow::service_contract::action_side_effect] 
#    lappend spec owner [curriculum::package_key]
#    
#    acs_sc::impl::new_from_spec -spec $spec
#}


ad_proc -private curriculum::apm::register_curriculum_owner_impl {} {

    set spec {
        name "CurriculumOwner"
        aliases {
            GetObjectType curriculum::object_type
            GetPrettyName curriculum::owner::pretty_name
            GetAssignees  curriculum::owner::get_assignees
        }
    }
    
    lappend spec contract_name [workflow::service_contract::role_default_assignees]
    lappend spec owner [curriculum::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

        
ad_proc -private curriculum::apm::register_format_log_title_impl {} {

    set spec {
        name "CurriculumFormatLogTitle"
        aliases {
            GetObjectType curriculum::object_type
            GetPrettyName curriculum::format_log_title::pretty_name
            GetTitle      curriculum::format_log_title::format_log_title
        }
    }
    
    lappend spec contract_name [workflow::service_contract::activity_log_format_title]
    lappend spec owner [curriculum::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}


ad_proc -private curriculum::apm::register_curriculum_notification_info_impl {} {

    set spec {
        name "CurriculumNotificationInfo"
        aliases {
            GetObjectType       curriculum::object_type
            GetPrettyName       curriculum::notification_info::pretty_name
            GetNotificationInfo curriculum::notification_info::get_notification_info
        }
    }
    
    lappend spec contract_name [workflow::service_contract::notification_info]
    lappend spec owner [curriculum::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}
