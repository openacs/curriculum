ad_page_contract {

    Curriculum index page.

    @author Ola Hansson (ola@polyxena.net)
    @creation-date 2003-05-31
    @cvs-id $Id$

} {
} -properties {
    title:onevalue
    context:onevalue
    admin_p:onevalue
}

set title "Curriculum"
set context {}

# We let admins see the link to the admin page.
set admin_p [permission::permission_p -object_id [curriculum::conn package_id] -privilege admin]

ad_return_template
