-- packages/curriculum/sql/postgresql/curriculum-element-package-create.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

select define_function_args('cu_element__new','element_id,curriculum_id,name,description,desc_format,url,enabled_p,sort_key,object_type;cu_element,creation_date,creation_user,creation_ip,context_id');

create or replace function cu_element__new (
    integer,     -- element_id
    integer,     -- curriculum_id
    varchar,     -- name
    text,        -- description
    varchar,     -- desc_format
    varchar,     -- url
    char,        -- enabled_p
    integer,     -- sort_key
    varchar,     -- object_type
    timestamptz, -- creation_date
    integer,     -- creation_user
    varchar,     -- creation_ip
    integer      -- context_id
) returns integer as '
declare
    p_element_id                   alias for $1;  -- default null
    p_curriculum_id                alias for $2;
    p_name                         alias for $3;
    p_description                  alias for $4;
    p_desc_format                  alias for $5;
    p_url                          alias for $6;
    p_enabled_p                    alias for $7;  -- default ''t''
    p_sort_key                     alias for $8;  -- default null
    p_object_type                  alias for $9;  -- default ''cu_element''
    p_creation_date                alias for $10; -- default current_timestamp
    p_creation_user                alias for $11; -- default null
    p_creation_ip                  alias for $12; -- default null
    p_context_id                   alias for $13; -- default null
    v_element_id cu_elements.element_id%TYPE;
    v_sort_key cu_elements.sort_key%TYPE;
begin
    v_element_id := acs_object__new ( 
        p_element_id, 
        p_object_type,
        p_creation_date,
        p_creation_user,
        p_creation_ip,
        p_context_id
    );  

    if p_sort_key is null then
        select coalesce(max(sort_key)+1, 1)
        into   v_sort_key
        from   cu_elements
        where  curriculum_id = p_curriculum_id;
    else
        v_sort_key := p_sort_key;
    end if;
 
    insert into cu_elements
        (element_id, curriculum_id, name, description, desc_format, url, enabled_p, sort_key)
    values
        (v_element_id, p_curriculum_id, p_name, p_description, p_desc_format, p_url, p_enabled_p, v_sort_key);

    raise NOTICE ''Adding element - %'',p_name;

    return v_element_id;

end;' language 'plpgsql';


select define_function_args('cu_element__del','element_id');

create or replace function cu_element__del (
    integer -- element_id
) returns integer as '
declare
    p_element_id alias for $1;
    v_return integer := 0; 
begin
    delete from acs_permissions
    where object_id = p_element_id;

    delete from cu_elements
    where element_id = p_element_id;

    raise NOTICE ''Deleting element - %'',p_element_id;

    perform acs_object__delete(p_element_id);

    return v_return;

end;' language 'plpgsql';


select define_function_args('cu_element__name','element_id');

create or replace function cu_element__name (
    integer -- element_id
) returns varchar as '
declare
    p_element_id alias for $1;
begin
    return name from cu_elements where element_id = p_element_id;
end;
' language 'plpgsql';
