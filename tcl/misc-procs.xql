<?xml version="1.0"?>
<queryset>

    <fullquery name="curriculum::get_curriculum_info.curriculum_info">
        <querytext>
            select   curriculum_id as curriculum_ids,
                     name as curriculum_names
            from     cu_curriculums
            where    package_id = :package_id
            order by sort_key
        </querytext>
    </fullquery>

    <fullquery name="curriculum::reset_one_curriculum.element_ids">
        <querytext>
            select element_id
            from   cu_elements_enabled
            where  curriculum_id = :curriculum_id
            and    package_id = :package_id
        </querytext>
    </fullquery>
 
    <fullquery name="curriculum::get_curriculum_stats.curriculum_stats">
        <querytext>
            select count(*) as curriculum_count
            from   cu_curriculums
            where  package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="curriculum::get_package_id_from_subsite_id.max_curriculum_id">
        <querytext>
            select max(package_id)
            from   apm_packages
            where package_key = :package_key
        </querytext>
    </fullquery>

 
</queryset>
