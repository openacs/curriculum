<?xml version="1.0"?>
<queryset>

    <fullquery name="get_all_curriculum_package_ids">
        <querytext>
        select   package_id 
        from     apm_packages 
        where    package_key = :package_key
        order by package_id
        </querytext>
    </fullquery>

</queryset>
