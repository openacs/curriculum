<?xml version="1.0"?>

<queryset>

<fullquery name="prior_sort_order">      
      <querytext>
       
	select max(sort_key) 
	from   cu_elements
	where  curriculum_id = :curriculum_id
	and    sort_key < :sort_order
    
      </querytext>
</fullquery>

<fullquery name="next_sort_order">      
      <querytext>
       
	select min(sort_key) 
	from   cu_elements
	where  curriculum_id = :curriculum_id
	and    sort_key > :sort_order
    
      </querytext>
</fullquery>

<fullquery name="swap_sort_orders">      
      <querytext>

      update cu_elements
      set    sort_key = case when sort_key = :sort_order
                             then $new_sort_order
                             when sort_key = :new_sort_order
                             then $sort_order end
      where  curriculum_id = :curriculum_id
      and    sort_key in (:sort_order, :new_sort_order)

      </querytext>
</fullquery>

</queryset>
