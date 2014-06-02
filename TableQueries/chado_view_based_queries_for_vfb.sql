/* Generic transgene expression Query: */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, teg.transgene_name, teg.transgene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_transgene_expressed_gp teg ON (teg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = '00003679'
  	AND stage.name = 'adult stage'; -- Note that different stage restrictions will be required as we broaden stage applicability of VFB views and queries.  The challenge here will be to deal with stage bracketing and substages.  These will require a second DL query and may require further chado denormalization (views).

/* Note - the above query assumes combined querying of proteins and transcripts.  If we want to separate these - so as to avoid incorrect inference over neurons where localisation is to only part of neuron, then need two separate queries.
DL: X or part_of some X -> protein only expression query
DL: X or overlaps some (X or part_of some X) -> transcript only expression query
*/

/* Transgene expression query - proteins */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, teg.transgene_name, teg.transgene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_transgene_expressed_gp teg ON (teg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = '00003679'
  	AND stage.name = 'adult stage';
	AND teg.gp_type_name='protein';

/* Transgene expression query - mRNA */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, teg.transgene_name, teg.transgene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_transgene_expressed_gp teg ON (teg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = '00003679'
  	AND stage.name = 'adult stage';
	AND teg.gp_type_name='mRNA'; -- assuming we don't have more exotic gene products, which right now we don't.  If we do, could enumerate by hand, but would be nicer to generate from SO.

/* Version with UTF-8 + SGML names */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, vfs.unicode_name, teg.transgene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_transgene_expressed_gp teg ON (teg.gp_feature_id = fe.feature_id)
       	JOIN vfbview_feature_synonym vfs ON (teg.transgene_feature_id = vfs.feature_id)
       	AND vfs.is_current is TRUE
       	AND vfs.stype ='symbol'
  	WHERE fbbt.accession = '00003679'
  	AND stage.name = 'adult stage';
	AND teg.gp_type_name='mRNA'; -- assuming we don't have more exotic gene products, which right now we don't.  If we do, could enumerate by hand, but would be nicer to generate from SO.

/* Generic gene expression query */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, geg.gene_name, geg.gene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_gene_expressed_gp geg ON (geg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = ?
  	AND stage.name = 'adult stage';

/* Gene expression query - proteins only */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, geg.gene_name, geg.gene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_gene_expressed_gp geg ON (geg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = ?
  	AND stage.name = 'adult stage'
	AND geg.gp_type_name='protein';

/* Version with UTF-8 + SGML names */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, vfs.unicode_name, geg.gene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_gene_expressed_gp geg ON (geg.gp_feature_id = fe.feature_id)
       	JOIN vfbview_feature_synonym vfs ON (geg.gene_feature_id = vfs.feature_id)
       	AND vfs.is_current is TRUE
       	AND vfs.stype ='symbol'
  	WHERE fbbt.accession = ?
  	AND stage.name = 'adult stage'
	AND geg.gp_type_name='protein';

/* Gene expression query - mRNA only */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, geg.gene_name, geg.gene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_gene_expressed_gp geg ON (geg.gp_feature_id = fe.feature_id)
  	WHERE fbbt.accession = ?
  	AND stage.name = 'adult stage'
	AND geg.gp_type_name='mRNA';

/* Version with UTF-8 + SGML names */

SELECT DISTINCT fbbt.cvterm_name AS anatomy, fbbt.db_name AS idp, fbbt.accession, vfs.unicode_name, geg.gene_uniquename, pub.miniref, pub.uniquename AS fbrf
	FROM vfbview_fbbt fbbt
  	JOIN expression_cvterm ec1 ON (fbbt.cvterm_id = ec1.cvterm_id)
  	JOIN expression_cvterm ec2 ON (ec2.expression_id = ec1.expression_id)
  	JOIN cvterm stage ON (stage.cvterm_id = ec2.cvterm_id)
  	JOIN feature_expression fe ON (ec1.expression_id = fe.expression_id)
  	JOIN pub ON (fe.pub_id = pub.pub_id)
  	JOIN vfbview_gene_expressed_gp geg ON (geg.gp_feature_id = fe.feature_id)
       	JOIN vfbview_feature_synonym vfs ON (geg.gene_feature_id = vfs.feature_id)
       	AND vfs.is_current is TRUE
       	AND vfs.stype ='symbol'
  	WHERE fbbt.accession = ?
  	AND stage.name = 'adult stage'
	AND geg.gp_type_name='mRNA';


/* PHENOTYPE QUERY */

SELECT DISTINCT fbbt.cvterm_name, vpf.name as feature, vpf.uniquename as fbid, pub.miniref, pub.uniquename as fbrf, fbbt.accession AS fbbt_accession
       FROM vfbview_fbbt fbbt
       JOIN phenotype p ON (fbbt.cvterm_id=p.observable_id)
       JOIN phenstatement ps ON (p.phenotype_id=ps.phenotype_id)
       JOIN pub ON (ps.pub_id = pub.pub_id)
       JOIN vfbview_phenstatement_feature vpf ON (vpf.phenstatement_id=ps.phenstatement_id)
       AND fbbt.accession = ?;

/* Note, this query has no stage restriction due to camcur assumption of adult as default. But this means that there may be some leakage of earlier stage phenotypes that wrongly use adult spec terms or that use broadly stage applicable terms. In the longer term, we need a fix for this.*/


/* Example phenotype query using UTF-8 / sgml output for allele names: */

SELECT DISTINCT fbbt.cvterm_name, vfs.unicode_name as feature, vfs.uniquename as fbid, pub.miniref, pub.uniquename as fbrf, fbbt.accession AS fbbt_accession
       FROM vfbview_fbbt fbbt
       JOIN phenotype p ON (fbbt.cvterm_id=p.observable_id)
       JOIN phenstatement ps ON (p.phenotype_id=ps.phenotype_id)
       JOIN pub ON (ps.pub_id = pub.pub_id)
       JOIN vfbview_phenstatement_feature vpf ON (vpf.phenstatement_id=ps.phenstatement_id)
       JOIN vfbview_feature_synonym vfs ON (vpf.feature_id = vfs.feature_id)
       AND vfs.is_current is TRUE
       AND vfs.stype ='symbol'
       AND fbbt.accession = ?;


/* List of ? of adult brain to test relatively large query

WHERE fbbt.accession IN ( '00007333', '00045003', '00007401', '00067500', '00067123', '00007438', '00067355', '00067363', '00067372', '00100384', '00100367', '00067014', '00067354', '00040000', '00067353', '00100389', '00100388', '00067364', '00100382', '00067028', '00007443', '00067369', '00067368', '00067017', '00100381', '00067367', '00067360', '00007475', '00067021', '00007439', '00067357', '00067361', '00067371', '00067352', '00067356', '00007446', '00067366', '00007447', '00007448', '00067365', '00007476', '00007449', '00100387', '00100383', '00007444', '00100380', '00007450', '00007451', '00007452', '00067359', '00100481', '00100378', '00100385', '00100386', '00100379', '00067358', '00007454', '00007437', '00003632', '00007146', '00100523', '00100513', '00100527', '00100515', '00007441', '00100369', '00007414', '00003684', '00067064', '00067013', '00067016', '00067018', '00067025', '00067033', '00067001', '00067036', '00067039', '00067042', '00067046', '00067048', '00067050', '00067052', '00067054', '00067056', '00067058', '00067061', '00067063', '00067003', '00067007', '00067011', '00067020', '00067023', '00067027', '00067031', '00067034', '00067041', '00067005', '00067044', '00067047', '00067049', '00007389', '00067051', '00067055', '00067057', '00067059', '00067062', '00067009', '00100525', '00100517', '00100526', '00003700', '00007453', '00007145', '00100524', '00100508', '00007440', '00100368', '00007445', '00005127', '00003979', '00007093', '00003960', '00003932', '00003933', '00003934', '00003935', '00007360', '00007361', '00003961', '00003962', '00003963', '00100531', '00003968', '00100375', '00003969', '00100377', '00100376', '00003964', '00003965', '00003970', '00007442', '00003975', '00003971', '00003972', '00003976', '00003940', '00003941', '00003977', '00007098', '00007097', '00003951', '00003936', '00007101', '00007099', '00007100', '00007363', '00003942', '00003943', '00003944', '00003937', '00003938', '00003945', '00007103', '00007102', '00003952', '00003946', '00003953', '00007105', '00007104', '00007366', '00003954', '00003955', '00007106', '00007107', '00003956', '00003947', '00003948', '00003957', '00003949', '00007391', '00007365', '00003958', '00003973', '00007092', '00003926', '00003927', '00003928', '00003929', '00100362', '00067350', '00003982', '00100015', '00100016', '00100017', '00100018', '00100019', '00007354', '00003986', '00004010', '00100365', '00007157', '00007076', '00007072', '00100337', '00040045', '00100339', '00040062', '00040043', '00045039', '00007575', '00007576', '00003992', '00003995', '00003987', '00003682', '00007385', '00045051', '00045020', '00003742', '00003743', '00003744', '00007403', '00003997', '00040047', '00005129', '00003727', '00045037', '00007405', '00045042', '00003998', '00100528', '00003767', '00003768', '00003769', '00003770', '00003771', '00003772', '00003773', '00003774', '00005897', '00003918', '00004207', '00004449', '00004209', '00045002', '00004011', '00100006', '00003638', '00003637', '00003678', '00007555', '00040034', '00007556', '00040070', '00007584', '00007546', '00007547', '00007548', '00007549', '00007550', '00007551', '00007552', '00100518', '00100516', '00100509', '00040040', '00003919', '00003663', '00003662', '00003661', '00003654', '00003655', '00003656', '00006009', '00005740', '00003679', '00040035', '00007487', '00007488', '00007490', '00007491', '00007492', '00007493', '00007494', '00007495', '00007496', '00007497', '00003657', '00007540', '00007541', '00007542', '00007543', '00007544', '00007536', '00007085', '00003640', '00003641', '00003642', '00003639', '00100519', '00003993', '00005810', '00045050', '00007073', '00007402', '00007416', '00040060', '00004020', '00003994', '00040039', '00100003', '00007407', '00007080', '00003858', '00003635', '00007574', '00007573', '00007572', '00007571', '00007570', '00007569', '00007568', '00007567', '00003917', '00100352', '00040050', '00100364', '00040049', '00040037', '00045046', '00007079', '00045027', '00003985', '00003757', '00006008', '00007578', '00003666', '00003665', '00100000', '00100014', '00100013', '00100011', '00100012', '00003686', '00003763', '00003708', '00045000', '00003746', '00003718', '00003719', '00003720', '00003722', '00003725', '00001943', '00003745', '00003741', '00007515', '00003681', '00007074', '00040001', '00100007', '00003667', '00007534', '00007535', '00007533', '00003659', '00007529', '00007530', '00007531', '00007532', '00007053', '00007081', '00007394', '00003688', '00003852', '00003870', '00003871', '00100482', '00100483', '00100484', '00100485', '00100486', '00003872', '00003873', '00003874', '00003875', '00003876', '00003877', '00003878', '00100480', '00045004', '00003879', '00003880', '00003881', '00003882', '00003883', '00003884', '00003853', '00003854', '00003855', '00003856', '00040016', '00040017', '00003885', '00007583', '00003906', '00003910', '00003886', '00003887', '00003888', '00003889', '00003907', '00003908', '00003909', '00003859', '00003860', '00003869', '00100487', '00100488', '00003861', '00003862', '00100489', '00100490', '00003863', '00003864', '00003865', '00003866', '00003867', '00003868', '00007390', '00040061', '00100005', '00005722', '00007353', '00007082', '00003683', '00003658', '00007509', '00007510', '00007511', '00003748', '00003750', '00003760', '00003751', '00003752', '00003753', '00003754', '00003755', '00003758', '00003759', '00005738', '00003775', '00003776', '00003785', '00003786', '00003787', '00003777', '00003778', '00003779', '00003780', '00003781', '00003782', '00003783', '00003784', '00003836', '00003837', '00003846', '00003847', '00003848', '00003849', '00003850', '00003851', '00003838', '00003839', '00003840', '00003841', '00003842', '00003843', '00003844', '00003845', '00003984', '00003721', '00100374', '00100370', '00100371', '00100372', '00100373', '00007415', '00045014', '00100258', '00100259', '00100260', '00100256', '00110000', '00100285', '00100286', '00100287', '00110004', '00100257', '00100266', '00110001', '00100282', '00100283', '00100284', '00110006', '00100267', '00100268', '00100252', '00003691', '00100250', '00100253', '00100249', '00100254', '00003690', '00100248', '00100223', '00100222', '00045018', '00100263', '00100264', '00100265', '00100261', '00110003', '00100280', '00100281', '00110005', '00100262', '00100269', '00110009', '00100278', '00100279', '00110008', '00100270', '00100271', '00100251', '00003694', '00003693', '00100226', '00100228', '00005780', '00110002', '00100273', '00100274', '00100275', '00100276', '00100277', '00100247', '00003695', '00005408', '00100229', '00100230', '00100231', '00100232', '00100233', '00100234', '00100235', '00100241', '00100242', '00100245', '00100246', '00003841', '00003842', '00003843', '00003844', '00003845', '00003984', '00003721', '00100374', '00100370', '00100371', '00100372', '00100373', '00007415', '00045014', '00100258', '00100259', '00100260', '00100256', '00110000', '00100285', '00100286', '00100287', '00110004', '00100257', '00100266', '00110001', '00100282', '00100283', '00100284', '00110006', '00100267', '00100268', '00100252', '00003691', '00100250', '00100253', '00100249', '00100254', '00003690', '00100248', '00100223', '00100222', '00045018', '00100263', '00100264', '00100265', '00100261', '00110003', '00100280', '00100281', '00110005', '00100262', '00100269', '00110009', '00100278', '00100279', '00110008', '00100270', '00100271', '00100251', '00003694', '00003693', '00100226', '00100228', '00005780', '00110002', '00100273', '00100274', '00100275', '00100276', '00100277', '00100247', '00003695', '00005408', '00100229', '00100230', '00100231', '00100232', '00100233', '00100234', '00100235', '00100241', '00100242', '00100245', '00100246', '00100243', '00100244', '00045010', '00100236', '00100237', '00100238', '00100239', '00005407', '00004186', '00004009', '00040033', '00003680', '00007404', '00003857', '00003747', '00003921', '00003698', '00007581', '00007582', '00003701', '00007577', '00003702', '00003703', '00003704', '00003705', '00003706', '00007059', '00003983', '00100224', '00003749', '00006007', '00003645', '00003646', '00003647', '00003644', '00003643', '00007433', '00045009', '00045008', '00045047', '00007456', '00004213', '00004215', '00004217', '00004219', '00004221', '00004223', '00004225', '02000006', '02000005', '00004227', '02000004', '02000003', '00100366', '00045001', '00003636', '00007523', '00007527', '00007528', '00007524', '00007525', '00007526', '00004012', '00007083', '00040044', '00040072', '00040046', '00040063', '00007086', '00040042', '00003668', '00003669', '00003670', '00003671', '00003672', '00003673', '00003674', '00003675', '00003676', '00003677', '00007539', '00040051', '00003832', '00003833', '00003834', '00003835', '00100520', '00100338', '00003649', '00007507', '00003650', '00003651', '00003652', '00003653', '00007538', '00007537', '00040038', '00003764', '00045048', '00005723', '00003922', '00040036', '00007339', '00001368', '00100359', '00003756', '00100002', '00007078', '00004210', '00100351', '00007075', '00100363', '00040048', '00045032', '00007054', '00007055', '00045030', '00040052', '00007077', '00045040', '00003626', '00001366', '00003726', '00003728', '00003729', '00003730', '00003731', '00003732', '00003733', '00003734', '00003735', '00003736', '00003737', '00003738', '00003739', '00003740', '00007579', '00003996', '00003890', '00003891', '00003900', '00003901', '00003902', '00003903', '00003904', '00003905', '00003892', '00003893', '00003894', '00003895', '00003896', '00003897', '00003898', '00003899', '00003788', '00003789', '00003798', '00003799', '00003800', '00003801', '00003802', '00003803', '00003804', '00003805', '00003806', '00003807', '00003790', '00003808', '00003809', '00003810', '00100243', '00100244', '00045010', '00100236', '00100237', '00100238', '00100239', '00005407', '00004186', '00004009', '00040033', '00003680', '00007404', '00003857', '00003747', '00003921', '00003698', '00007581', '00007582', '00003701', '00007577', '00003702', '00003703', '00003704', '00003705', '00003706', '00007059', '00003983', '00100224', '00003749', '00006007', '00003645', '00003646', '00003647', '00003644', '00003643', '00007433', '00045009', '00045008', '00045047', '00007456', '00004213', '00004215', '00004217', '00004219', '00004221', '00004223', '00004225', '02000006', '02000005', '00004227', '02000004', '02000003', '00100366', '00045001', '00003636', '00007523', '00007527', '00007528', '00007524', '00007525', '00007526', '00004012', '00007083', '00040044', '00040072', '00040046', '00040063', '00007086', '00040042', '00003668', '00003669', '00003670', '00003671', '00003672', '00003673', '00003674', '00003675', '00003676', '00003677', '00007539', '00040051', '00003832', '00003833', '00003834', '00003835', '00100520', '00100338', '00003649', '00007507', '00003650', '00003651', '00003652', '00003653', '00007538', '00007537', '00040038', '00003764', '00045048', '00005723', '00003922', '00040036', '00007339', '00001368', '00100359', '00003756', '00100002', '00007078', '00004210', '00100351', '00007075', '00100363', '00040048', '00045032', '00007054', '00007055', '00045030', '00040052', '00007077', '00045040', '00003626', '00001366', '00003726', '00003728', '00003729', '00003730', '00003731', '00003732', '00003733', '00003734', '00003735', '00003736', '00003737', '00003738', '00003739', '00003740', '00007579', '00003996', '00003890', '00003891', '00003900', '00003901', '00003902', '00003903', '00003904', '00003905', '00003892', '00003893', '00003894', '00003895', '00003896', '00003897', '00003898', '00003899', '00003788', '00003789', '00003798', '00003799', '00003800', '00003801', '00003802', '00003803', '00003804', '00003805', '00003806', '00003807', '00003790', '00003808', '00003809', '00003810', '00003811', '00003812', '00003813', '00003814', '00003815', '00003816', '00003791', '00003830', '00003792', '00003793', '00003831', '00003794', '00003795', '00003796', '00003797', '00003817', '00003818', '00003828', '00003829', '00003819', '00003820', '00003821', '00003822', '00003823', '00003824', '00003825', '00003826', '00003827', '00007395', '00007396', '00003991', '00003988', '00040059', '00040071', '00003920', '00045021', '00007058', '00040002', '00003634', '00007566', '00007565', '00007564', '00007563', '00007562', '00007561', '00007560', '00007559', '00007516', '00007517', '00007518', '00007519', '00007520', '00007521', '00007522', '00040041', '00007393', '00100004', '00003911', '00003912', '00003913', '00003914', '00003915', '00003916', '00007580', '00100008', '00100009', '00100010', '00100020', '00100021' ) 

*/