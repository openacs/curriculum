ad_page_contract {
    
    Flush the bar (individually cached per user) for this curriculum instance.
    
    @creation-date 2003-06-07
    @author Ola Hansson (ola@polyxena.net)
    @cvs-id $Id$
  
} {
}

curriculum::elements_flush -thorough
	
ad_returnredirect "."
