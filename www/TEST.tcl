#curriculum::elements_flush

doc_return 200 text/plain "

curriculum_ids: [curriculum::conn -nocache curriculum_ids] \n
package_id: [curriculum::conn package_id] \n
package_id (ad_conn): [ad_conn package_id] \n
subsite_id: [curriculum::conn subsite_id] \n
package_url: [curriculum::conn package_url] \n
package_url (ad_conn): [ad_conn package_url] \n
subsite_url: [curriculum::conn subsite_url] \n
curriculum_ids: [curriculum::conn curriculum_ids] \n
curriculum_names: [curriculum::conn curriculum_names] \n
curriculum_count: [curriculum::conn curriculum_count] \n

enabled rows:\n
[join [curriculum::enabled_elements_memoized] \n]

"

