-- packages/curriculum/sql/oracle/curriculum-curriculum-package-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

create or replace package cu_curriculum
as

    function new (
        curriculum_id in cu_curriculums.curriculum_id%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'cu_curriculum',
        name in cu_curriculums.name%TYPE,
-- The description column is of type clob rather than varchar
-- in order to allow a maximum of 32K as opposed to varchar's 4K.
-- However, clob doesn't support the %TYPE syntax and clob isn't
-- a valid type in PLSQL. But since a varchar in PLSQL can be up
-- to 32K that is the explicit type we use here.
        description in varchar default null,
        desc_format in cu_curriculums.desc_format%TYPE,
        owner_id in cu_curriculums.owner_id%TYPE,
        package_id in cu_curriculums.package_id%TYPE,
        sort_key in cu_curriculums.sort_key%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE,
        context_id in acs_objects.context_id%TYPE default null
    ) return cu_curriculums.curriculum_id%TYPE;

    function name (
        curriculum_id in cu_curriculums.curriculum_id%TYPE
    ) return cu_curriculums.name%TYPE;

    procedure del (
        curriculum_id in cu_curriculums.curriculum_id%TYPE
    );

end cu_curriculum;
/
show errors


create or replace package body cu_curriculum
as

    function new (
        curriculum_id in cu_curriculums.curriculum_id%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'cu_curriculum',
        name in cu_curriculums.name%TYPE,
        description in varchar default null,
        desc_format in cu_curriculums.desc_format%TYPE,
        owner_id in cu_curriculums.owner_id%TYPE,
        package_id in cu_curriculums.package_id%TYPE,
        sort_key in cu_curriculums.sort_key%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE,
        context_id in acs_objects.context_id%TYPE default null
    ) return cu_curriculums.curriculum_id%TYPE
    is
        v_curriculum_id cu_curriculums.curriculum_id%TYPE;
        v_sort_key cu_curriculums.sort_key%TYPE;
    begin
        v_curriculum_id := acs_object.new(
            object_id => curriculum_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => nvl(context_id, package_id)
        );

        if new.sort_key is null then
            select nvl(max(sort_key)+1, 1)
            into   v_sort_key
            from   cu_curriculums
            where  package_id = new.package_id;
        else
            v_sort_key := new.sort_key;
        end if;
        
	  insert into cu_curriculums
	  (curriculum_id, name, description, desc_format, owner_id, package_id, sort_key)
   	  values
	  (v_curriculum_id, name, description, desc_format, owner_id, package_id, v_sort_key);

        return v_curriculum_id;
    end new;

    function name (
        curriculum_id in cu_curriculums.curriculum_id%TYPE
    ) return cu_curriculums.name%TYPE
    is
	   v_name cu_curriculums.name%TYPE;
    begin
        select name
        into   v_name
        from   cu_curriculums
        where  curriculum_id = cu_curriculum.name.curriculum_id;

        return v_name;
    end name;
    
    procedure del (
        curriculum_id in cu_curriculums.curriculum_id%TYPE
    )
    is
        cursor c_element_cur is
            select element_id
            from   cu_elements
            where  curriculum_id = cu_curriculum.del.curriculum_id;
    begin
        delete from acs_permissions
        where  object_id = cu_curriculum.del.curriculum_id;

        -- Delete all elements in the curriculum.
        for v_element_val in c_element_cur loop
            cu_element.del(v_element_val.element_id);
        end loop;

        delete from cu_curriculums
        where  curriculum_id = cu_curriculum.del.curriculum_id;

        acs_object.del(cu_curriculum.del.curriculum_id);
    end del;

end cu_curriculum;
/
show errors

-- packages/curriculum/sql/oracle/curriculum-element-package-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

create or replace package cu_element
as

    function new (
        element_id in cu_elements.element_id%TYPE default null,
        curriculum_id in cu_elements.curriculum_id%TYPE,
        name in cu_elements.name%TYPE,
-- The description column is of type clob rather than varchar
-- in order to allow a maximum of 32K as opposed to varchar's 4K.
-- However, clob doesn't support the %TYPE syntax and clob isn't
-- a valid type in PLSQL. But since a varchar in PLSQL can be up
-- to 32K that is the explicit type we use here.
        description in varchar default null,
        desc_format in cu_elements.desc_format%TYPE,
        url in cu_elements.url%TYPE,
        external_p in cu_elements.external_p%TYPE default 'f',
        enabled_p in cu_elements.enabled_p%TYPE default 't',
        sort_key in cu_elements.sort_key%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'cu_element',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE,
        context_id in acs_objects.context_id%TYPE default null
    ) return cu_elements.element_id%TYPE;

    function name (
        element_id in cu_elements.element_id%TYPE
    ) return cu_elements.name%TYPE;

    procedure del (
        element_id in cu_elements.element_id%TYPE
    );

end cu_element;
/
show errors


create or replace package body cu_element
as

    function new (
        element_id in cu_elements.element_id%TYPE default null,
        curriculum_id in cu_elements.curriculum_id%TYPE,
        name in cu_elements.name%TYPE,
-- The 'description' column is of type clob rather than varchar
-- in order to allow a maximum of 32K as opposed to varchar's 4K.
-- However, clob doesn't support the %TYPE syntax and clob isn't
-- a valid type in PLSQL. But since a varchar in PLSQL can be up
-- to 32K that is the explicit type we use here.
        description in varchar default null,
        desc_format in cu_elements.desc_format%TYPE,
        url in cu_elements.url%TYPE,
        external_p in cu_elements.external_p%TYPE default 'f',
        enabled_p in cu_elements.enabled_p%TYPE default 't',
        sort_key in cu_elements.sort_key%TYPE default null,
        object_type in acs_objects.object_type%TYPE default 'cu_element',
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE,
        context_id in acs_objects.context_id%TYPE default null
    ) return cu_elements.element_id%TYPE
    is
        v_element_id cu_elements.element_id%TYPE;
        v_sort_key cu_elements.sort_key%TYPE;
    begin
        v_element_id := acs_object.new ( 
            object_id 	=> element_id, 
            object_type 	=> object_type,
            creation_date 	=> creation_date,
            creation_user 	=> creation_user,
            creation_ip 	=> creation_ip,
            context_id 	=> nvl(context_id, curriculum_id)
        );  
 
        if new.sort_key is null then
            select nvl(max(sort_key)+1, 1)
            into   v_sort_key
            from   cu_elements
            where  curriculum_id = new.curriculum_id;
        else
            v_sort_key := new.sort_key;
        end if;

        insert into cu_elements
        (element_id, curriculum_id, name, description, desc_format, url, external_p, enabled_p, sort_key)
        values
        (v_element_id, curriculum_id, name, description, desc_format, url, external_p, enabled_p, v_sort_key);

        return v_element_id;
    end new;

    function name (
        element_id in cu_elements.element_id%TYPE
    ) return cu_elements.name%TYPE
    is
        v_name cu_elements.name%TYPE;
    begin
        select name into v_name
        from   cu_elements
        where  element_id = name.element_id;

        return v_name;
    end name;

    procedure del (
        element_id in cu_elements.element_id%TYPE
    )
    is
    begin
        delete from acs_permissions
        where  object_id = cu_element.del.element_id;
  
        delete from cu_elements
        where  element_id = cu_element.del.element_id;

        acs_object.del(element_id);
    end del;

end cu_element;
/
show errors
