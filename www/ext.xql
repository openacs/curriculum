<?xml version="1.0"?>
<queryset>

    <fullquery name="get_destination_url">
        <querytext>
    select url
    from   cu_elements
    where  element_id = :element_id
        </querytext>
    </fullquery>

</queryset>
