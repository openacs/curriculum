<?xml version="1.0"?>
<queryset>

    <fullquery name="curriculum::apm::after_instantiate.insert_default_assignees">
        <querytext>

        insert into cu_default_assignees
                    (package_id, default_editor, default_publisher)
                    values
                    (:package_id, :user_id, :user_id)

        </querytext>
    </fullquery>

    <fullquery name="curriculum::apm::before_uninstantiate.delete_default_assignees">
        <querytext>

        delete from cu_default_assignees
        where package_id = :package_id

        </querytext>
    </fullquery>

</queryset>
