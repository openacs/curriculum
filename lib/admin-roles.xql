<?xml version="1.0"?>
<queryset>

<fullquery name="update_default_assignees">
      <querytext>
      
            update cu_default_assignees set
            default_editor    = :default_editor,
            default_publisher = :default_publisher
            where package_id  = :package_id

      </querytext>
</fullquery>

</queryset>
