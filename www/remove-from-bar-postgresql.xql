<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="user_curriculum_map_insert">
        <querytext>
         insert into cu_user_curriculum_map
         (user_id, curriculum_id, package_id)
         select :user_id,
                :curriculum_id,
                :package_id
         where  not exists (select 1
                            from   cu_user_curriculum_map
                            where  user_id = :user_id
                            and    curriculum_id = :curriculum_id)
        </querytext>
    </fullquery>

</queryset>
