ad_library {

    Curriculum Security Library

    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$

}

namespace eval curriculum::security {}


ad_proc -private curriculum::security::do_abort {} {
    Do an abort if security violation.
} {
    ad_returnredirect "not-allowed"
    return -code error
}    


ad_proc -public curriculum::security::can_read_curriculum_p {
    {-user_id ""}
    {-curriculum_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $curriculum_id -privilege curriculum_read]
}


ad_proc -public curriculum::security::require_read_curriculum {
    {-user_id ""}
    {-curriculum_id:required}
} {
    if {![can_read_curriculum_p -user_id $user_id -curriculum_id $curriculum_id]} {
	do_abort
    }
}


ad_proc -public curriculum::security::can_create_curriculum_p {
    {-user_id ""}
    {-curriculum_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $curriculum_id -privilege curriculum_create]
}


ad_proc -public curriculum::security::require_create_curriculum {
    {-user_id ""}
    {-curriculum_id:required}
} {
    if {![can_create_curriculum_p -user_id $user_id -curriculum_id $curriculum_id]} {
	do_abort
    }
}


ad_proc -public curriculum::security::can_create_element_p {
    {-user_id ""}
    {-element_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $element_id -privilege curriculum_write]
}


ad_proc -public curriculum::security::require_create_element {
    {-user_id ""}
    {-element_id:required}
} {
    if {![can_create_element_p -user_id $user_id -element_id $element_id]} {
	do_abort
    }
}


ad_proc -public curriculum::security::can_write_curriculum_p {
    {-user_id ""}
    {-curriculum_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $curriculum_id -privilege curriculum_write]
}


ad_proc -public curriculum::security::require_write_curriculum {
    {-user_id ""}
    {-curriculum_id:required}
} {
    if {![can_write_curriculum_p -user_id $user_id -curriculum_id $curriculum_id]} {
	do_abort
        }
}


ad_proc -public curriculum::security::can_write_element_p {
    {-user_id ""}
    {-element_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $element_id -privilege curriculum_write]
}


ad_proc -public curriculum::security::require_write_element {
    {-user_id ""}
    {-element_id:required}
} {
    if {![can_write_element_p -user_id $user_id -element_id $element_id]} {
	do_abort
    }
}


ad_proc -public curriculum::security::can_admin_curriculum_p {
    {-user_id ""}
    {-curriculum_id:required}
} {
    return [permission::permission_p -party_id $user_id -object_id $curriculum_id -privilege curriculum_write]
}


ad_proc -public curriculum::security::require_admin_curriculum {
    {-user_id ""}
    {-curriculum_id:required}
} {
    if {![can_admin_curriculum_p -user_id $user_id -curriculum_id $curriculum_id]} {
	do_abort
    }
}
