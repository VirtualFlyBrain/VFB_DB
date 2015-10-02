/* A simple view table that collapses the link from anatomy term ID to cvterm_id down to a single table */

CREATE TABLE vfbview_fbbt AS
SELECT DISTINCT c.cvterm_id as cvterm_id, db.name as db_name, dbx.accession, c.name as cvterm_name
       FROM cvterm c
       JOIN dbxref dbx ON (dbx.dbxref_id = c.dbxref_id)
       JOIN db ON (db.db_id = dbx.db_id)
       WHERE db.name = 'FBbt'
       AND c.is_obsolete = 0
       AND c.is_relationshiptype = 0;

ALTER TABLE vfbview_fbbt ADD PRIMARY KEY (cvterm_id);
CREATE UNIQUE INDEX fbbti ON vfbview_fbbt (accession);

/* The following is intended as a view table that gets around the ugly mess of iterative queries required to link allele transcripts and peptides to transgenes.  This has been made significantly more ugly by recent changes to the feature relationship table (basically changing more specific relationships -> associated_with ... <rant> Hey why bother with the table in the first place!?  If you only have one relationship with lots of different meanings you may as well just use joins!!! </rant>

Key relationships:

'allele transcript product' associated_with 'allele'
'allele peptide product' associated_with 'allele
'allele' associated_with 'transposon'
'allele' associated_with '' 

<rant> - but note specific transcript to gene is still partof !!! </rant>

Note - there is one wrinkle here: it is possible for one allele transcript to be associated with multiple transposons. This leads to potentially misleading inference: if a paper has expression curation for an allele that has multiple associated transposons - then it looks like the paper analysed expression from all of these transposons.  This could be improved somewhat by checking for direct association with pub.
*/

CREATE TABLE vfbview_transgene_expressed_gp AS
SELECT DISTINCT obj2.feature_id as transgene_feature_id, obj2.name as transgene_name, obj2.uniquename as transgene_uniquename, stype.name as gp_type_name, fe.feature_id as gp_feature_id
   	FROM feature_expression fe
	JOIN feature subj ON (fe.feature_id=subj.feature_id)
	JOIN cvterm stype ON (subj.type_id=stype.cvterm_id)
	JOIN feature_relationship fr1 ON (fe.feature_id = fr1.subject_id)
   	JOIN cvterm rel1 ON (fr1.type_id = rel1.cvterm_id)
   	JOIN feature_relationship fr2 ON (fr1.object_id = fr2.subject_id)
   	JOIN cvterm rel2 ON (fr2.type_id = rel2.cvterm_id)
   	JOIN feature obj2 ON (fr2.object_id = obj2.feature_id)
	JOIN feature_relationship fr3 ON (fr1.object_id = fr3.subject_id)
   	JOIN cvterm rel3 ON (fr3.type_id = rel3.cvterm_id)
   	WHERE rel1.name='associated_with'
   	AND rel2.name='associated_with'
   	AND rel3.name='alleleof'
	AND obj2.uniquename ~ 'FBtp|FBti'
	AND obj2.is_obsolete IS FALSE;

ALTER TABLE vfbview_transgene_expressed_gp ADD PRIMARY KEY (gp_feature_id, transgene_feature_id);

/* NOTE - experimented with adding index: 
CREATE INDEX gpi ON vfbview_transgene_expressed_gp(gp_feature_id);
BUT this significantly *slowed* final query */

/* A view table for gene expression queries
Note that generic transcript or peptide -> gene relationship is 'associated_with'.  Even though the relationship for specific (known) transcripts and peptides is 'partof'...  go figure... 
 */
CREATE TABLE vfbview_gene_expressed_gp AS
SELECT DISTINCT subj.feature_id as gp_feature_id, subj.name as gp_name, stype.name as gp_type_name, obj.name as gene_name, obj.uniquename as gene_uniquename, obj.feature_id as gene_feature_id 
   	FROM feature_expression fe
	JOIN feature subj ON (fe.feature_id=subj.feature_id)
	JOIN cvterm stype ON (subj.type_id=stype.cvterm_id)
	JOIN feature_relationship fr1 ON (fe.feature_id = fr1.subject_id)
   	JOIN cvterm rel1 ON (fr1.type_id = rel1.cvterm_id)
   	JOIN feature obj ON (fr1.object_id = obj.feature_id)
   	WHERE rel1.name='associated_with'
	AND obj.uniquename like 'FBgn%'
	AND subj.is_obsolete IS FALSE;

ALTER TABLE vfbview_gene_expressed_gp ADD PRIMARY KEY (gp_feature_id, gene_feature_id);  -- Note - expected gp_feature_id to be unique, but oddly it is not. Should probably investigate further

/* view table cutting out slow steps in */

CREATE TABLE vfbview_phenstatement_feature AS
SELECT DISTINCT f.name, f.uniquename, ps.phenstatement_id, f.feature_id
FROM phenstatement ps
JOIN feature_genotype fg ON (ps.genotype_id=fg.genotype_id)
JOIN feature f ON (fg.feature_id=f.feature_id)
WHERE f.is_obsolete IS FALSE -- Maybe slightly paranoid check
AND f.uniquename ~ 'FBa(l|b)[0-9]{7}'; -- Makes sure only FBal and FBab identifiers get through, excluding +, - and bogus.

ALTER TABLE vfbview_phenstatement_feature ADD PRIMARY KEY (phenstatement_id, uniquename);

/* A table for autocomplete on synonyms for feature -> expression/phenotype queries */

/* Start by populating the table with genes used in expression curation*/

CREATE TABLE vfbview_feature_synonym AS
SELECT DISTINCT f.feature_id, f.uniquename, s.name as ascii_name, stype.name as stype, fs.is_current, s.synonym_sgml as unicode_name
       FROM vfbview_gene_expressed_gp geg
       JOIN feature f on (geg.gene_feature_id=f.feature_id)
       JOIN feature_synonym fs on (f.feature_id=fs.feature_id)
       JOIN synonym s on (fs.synonym_id=s.synonym_id)
       JOIN cvterm stype on (s.type_id=stype.cvterm_id);  

/* Add transposons and insertions from expression curation */

INSERT INTO vfbview_feature_synonym
SELECT DISTINCT f.feature_id, f.uniquename, s.name as ascii_name, stype.name as stype, fs.is_current, s.synonym_sgml as unicode_name
       FROM vfbview_transgene_expressed_gp teg
       JOIN feature f on (teg.transgene_feature_id=f.feature_id)
       JOIN feature_synonym fs on (f.feature_id=fs.feature_id)
       JOIN synonym s on (fs.synonym_id=s.synonym_id)
       JOIN cvterm stype on (s.type_id=stype.cvterm_id);  

/* Add alleles used in phenotype curation */

INSERT INTO vfbview_feature_synonym
SELECT DISTINCT f.feature_id, f.uniquename, s.name as ascii_name, stype.name as stype, fs.is_current, s.synonym_sgml as unicode_name
       FROM vfbview_phenstatement_feature pf
       JOIN feature f on (pf.feature_id=f.feature_id)
       JOIN feature_synonym fs on (f.feature_id=fs.feature_id)
       JOIN synonym s on (fs.synonym_id=s.synonym_id)
       JOIN cvterm stype on (s.type_id=stype.cvterm_id);  

/* But this is worrying:
ALTER TABLE vfbview_feature_synonym ADD PRIMARY KEY (feature_id, ascii_name, is_current, stype);
=> ERROR:  could not create unique index "vfbview_feature_synonym_pkey"
DETAIL:  Table contains duplicated values.
 - seems quite amazing .... */
/* what to else index on? */

CREATE INDEX vfs_feat_i ON vfbview_feature_synonym (feature_id); -- only a little speed up seen...

/* USE in modifying query output

Clause to add to queries to => UTF-8 / sgml version:

JOIN vfbview_feature_synonym vfs ON (?.feature_id = vfs.feature_id)
WHERE vfs.is_current is TRUE
AND vfs.stype ='symbol'


Note that the output of this will need to be munged with regex to => html superscripts

*/       

/* A simple view table for publications and minirefs */

CREATE TABLE vfbview_pubminiref AS
SELECT DISTINCT pub.uniquename  AS uniquename, pub.miniref AS miniref, qdbx.accession AS accession
	FROM cvterm query, dbxref qdbx, dbxref xdbx, db qdb, db xdb, cvterm_dbxref cvt_dbx, pub 
	WHERE qdb.name ='FBbt' 
	AND qdbx.db_id = qdb.db_id 
	AND query.dbxref_id = qdbx.dbxref_id 
	AND query.cvterm_id=cvt_dbx.cvterm_id 
	AND cvt_dbx.dbxref_id=xdbx.dbxref_id 
	AND xdbx.db_id = xdb.db_id 
	AND xdb.name='FlyBase' 
	AND xdbx.accession=pub.uniquename;
CREATE INDEX vfbview_pubminiref_accession ON vfbview_pubminiref (accession);
/*ALTER TABLE vfbview_pubminiref ADD PRIMARY KEY (accession); */

/* Experimental - NM */
/* Create transgene view */
create table vfbview_transgene AS SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, teg.transgene_name, teg.transgene_uniquename, pub.miniref, pub.uniquename AS fbrf FROM vfbview_fbbt fbbt JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id) JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id) JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id) JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id) JOIN pub ON (fe.pub_id = pub.pub_id) JOIN vfbview_transgene_expressed_gp teg ON (teg.gp_feature_id = fe.feature_id);
create index vfbview_transgene_accession on vfbview_transgene (accession);
/* With this view and index the execution time falls 40-fold (avg 8.8ms vs 357ms on the joints) */

