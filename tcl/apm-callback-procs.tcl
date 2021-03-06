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
    
    set user_id [ad_conn user_id]
    db_dml insert_default_assignees {*SQL*}
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

	db_dml delete_default_assignees {*SQL*}
    }
}


ad_proc -private curriculum::apm::after_mount {
    {-package_id:required}
    {-node_id:required}
} {
    Package mount callback proc.
} {
    # Register the filter that makes tracking in the curriculum bar work.
    curriculum::register_filter -package_id $package_id
}


#####
#
# Service contract implementations.
#
#####


ad_proc -private curriculum::apm::register_implementations {} {
    db_transaction {
	curriculum::apm::register_curriculum_default_editor_impl
	curriculum::apm::register_curriculum_default_publisher_impl
        curriculum::apm::register_curriculum_notification_info_impl
	curriculum::apm::register_flush_elements_impl
    }
}


ad_proc -private curriculum::apm::unregister_implementations {} {
    db_transaction {
	
        acs_sc::impl::delete \
	    -contract_name [workflow::service_contract::role_default_assignees]  \
	    -impl_name "Role_DefaultAssignees_Editor"
	
        acs_sc::impl::delete \
	    -contract_name [workflow::service_contract::role_default_assignees]  \
	    -impl_name "Role_DefaultAssignees_Publisher"
	
        acs_sc::impl::delete \
	    -contract_name [workflow::service_contract::notification_info] \
	    -impl_name "CurriculumNotificationInfo"
	
        acs_sc::impl::delete \
	    -contract_name [workflow::service_contract::action_side_effect] \
	    -impl_name "CurriculumFlushElementsCache"
	
    }
}


ad_proc -private curriculum::apm::register_curriculum_default_editor_impl {} {

    set spec {
        name "Role_DefaultAssignees_Editor"
        aliases {
            GetObjectType curriculum::object_type
            GetPrettyName curriculum::default_editor::pretty_name
            GetAssignees  curriculum::default_editor::get_assignees
        }
    }
    
    lappend spec contract_name [workflow::service_contract::role_default_assignees]
    lappend spec owner [curriculum::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}

        
ad_proc -private curriculum::apm::register_curriculum_default_publisher_impl {} {

    set spec {
        name "Role_DefaultAssignees_Publisher"
        aliases {
            GetObjectType curriculum::object_type
            GetPrettyName curriculum::default_publisher::pretty_name
            GetAssignees  curriculum::default_publisher::get_assignees
        }
    }
    
    lappend spec contract_name [workflow::service_contract::role_default_assignees]
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


ad_proc -private curriculum::apm::register_flush_elements_impl {} {
    
    set spec {
        name "CurriculumFlushElementsCache"
        aliases {
            GetObjectType curriculum::object_type
            GetPrettyName curriculum::flush_elements::pretty_name
            DoSideEffect  curriculum::flush_elements::do_side_effect
        }
    }
    
    lappend spec contract_name [workflow::service_contract::action_side_effect] 
    lappend spec owner [curriculum::package_key]
    
    acs_sc::impl::new_from_spec -spec $spec
}
