-- packages/curriculum/sql/postgresql/curriculum-curriculum-package-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

select define_function_args('cu_curriculum__new','curriculum_id,name,description,desc_format,package_id,sort_key,object_type;cu_curriculum,creation_date,creation_user,creation_ip,context_id');

create or replace function cu_curriculum__new (
    integer,     -- curriculum_id
    varchar,     -- name
    text,        -- description
    varchar,     -- desc_format
    integer,     -- package_id
    integer,     -- sort_key
    varchar,     -- object_type
    timestamptz, -- creation_date
    integer,     -- creation_user
    varchar,     -- creation_ip
    integer      -- context_id
) returns integer as '
declare
    p_curriculum_id  alias for $1;  -- default null
    p_name           alias for $2;
    p_description    alias for $3;  -- default null
    p_desc_format    alias for $4;
    p_package_id     alias for $6;
    p_sort_key       alias for $7;  -- default null
    p_object_type    alias for $8;  -- default ''cu_curriculum''
    p_creation_date  alias for $9;  -- default current_timestamp
    p_creation_user  alias for $10; -- default null
    p_creation_ip    alias for $11; -- default null
    p_context_id     alias for $12; -- default null
    v_curriculum_id cu_curriculums.curriculum_id%TYPE;
    v_sort_key cu_curriculums.sort_key%TYPE;
begin
    v_curriculum_id := acs_object__new ( 
        p_curriculum_id, 
        p_object_type,
        p_creation_date,
        p_creation_user,
        p_creation_ip,
        coalesce(p_context_id, p_package_id)
    );  

    if p_sort_key is null then
        select coalesce(max(sort_key)+1, 1)
        into   v_sort_key
        from   cu_curriculums
        where  package_id = p_package_id;
    else
        v_sort_key := p_sort_key;
    end if;
 
    insert into cu_curriculums
        (curriculum_id, name, description, desc_format, package_id, sort_key)
    values
        (v_curriculum_id, p_name, p_description, p_desc_format, p_package_id, v_sort_key);

    raise NOTICE ''Adding curriculum - %'',p_name;

    return v_curriculum_id;

end;' language 'plpgsql';


select define_function_args('cu_curriculum__del','curriculum_id');

create or replace function cu_curriculum__del (
    integer -- curriculum_id
) returns integer as '
declare
    p_curriculum_id alias for $1;
    v_cur RECORD;
    v_return integer := 0; 
begin
    delete from acs_permissions
    where object_id = p_curriculum_id;

    for v_cur in select element_id
                 from   cu_elements
                 where  curriculum_id = p_curriculum_id
        
    loop
        perform cu_element__del(v_cur.element_id);
    end loop;

    raise NOTICE ''Deleting curriculum - %'',p_curriculum_id;

    perform acs_object__delete(p_curriculum_id);

    return v_return;

end;' language 'plpgsql';


select define_function_args('cu_curriculum__name','curriculum_id');

create or replace function cu_curriculum__name (
    integer -- curriculum_id
) returns varchar as '
declare
    p_curriculum_id alias for $1;
begin
    return name from cu_curriculums where curriculum_id = p_curriculum_id;
end;
' language 'plpgsql';
