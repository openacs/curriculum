ad_page_contract {
    
    Swaps two sort keys for two elements, sort_order and new_sort_order.
    
    @creation-date 2003-06-03
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$
  
} {
    curriculum_id:integer,notnull
    sort_order:integer,notnull
    direction:notnull
}

permission::require_permission -object_id $curriculum_id \
    -privilege write

db_transaction {

	if { [string equal "up" $direction] } {
	    set new_sort_order [db_string prior_sort_order {*SQL*}]
	} else {
	    # Assume the direction is "down".
	    set new_sort_order [db_string next_sort_order {*SQL*}]
	}
	
	# For some reason the PG driver couldn't handle bind vars for all the
	# vars in "element-swap.xql". I therefore left a couple of $s in there.

	db_dml swap_sort_orders {*SQL*}

	# Force the curriculum bar to reflect the reality.
	curriculum::elements_flush
	
}

ad_returnredirect "."
