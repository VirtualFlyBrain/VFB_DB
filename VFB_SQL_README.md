This DB drives generation of links and retrieval of images.  It is
used to populate third party beans as follows:

~~~~~.sql
    SELECT l.vfbid, f.fbid, l.remoteid, l.source_name, l.thumb_name, l.local_stack_url, s.base_url, s.thumb_local_base, s.stack_local_base, s. descr, l.display_name,
    f.stack_type, f.complete_expression_pattern
    FROM third_party_site_lookup l
    JOIN third_party_site_source s ON (l.source_name = s.name)
    LEFT OUTER JOIN third_party_flybase_lookup f on (f.vfbid=l.vfbid);
~~~~~

* l.vfbid = shortFormID of owl individual depicted in the image.
* f.fbid = FlyBase ID of expressed feature.  This id is used for linking
this feature to FlyBase.
* l.remoteid = ID of linked entity on third party site - to be used in rolling links.
* l.source_name = Name of source to display on website
* l.thumb_name = Name of thumb file (?)
* l.display_name = name of owl_individual - used in linking an display of metadata
* s.base_url - baseURL for source links
* s.thumb\_local_base = base local path for thumbnail
* s.stack\_local_base = base local path for source
* s.descr = ?
* l.display\_name = name of owl_individual - used in linking an display of metadata
* f.stack_type = ?
* f.complete\_expression_pattern = A binary indicating whether the
  individual is a complete expression pattern (rather than just some
  structure that expresses X). 
