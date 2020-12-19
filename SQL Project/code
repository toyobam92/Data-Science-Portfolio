CREATE TABLE `G02_OLAP`.`Dim_Industry` (

  `ind_id` INT NOT NULL auto_increment,

  `naics` char(6),

  `ind_desc` varchar(75),

  PRIMARY KEY (`ind_id`)

);

 

#CODE TO INSERT INTO INDUSTRY DIMENSTION

INSERT INTO `G02_OLAP`.`Dim_Industry`(naics, ind_desc)

SELECT naics, ind_desc

FROM FCP_CBP_OLTP.Industry;

 

#CHECKPOINT FOR INDUSTRY DIMENSION

SELECT * FROM `G02_OLAP`.`Dim_Industry`;

 

#CODE TO CREATE FLAG DIMENSION

CREATE TABLE `G02_OLAP`.`Dim_Flag` (

  `code` char(1) NOT NULL,

  `flag_desc` varchar(100) NOT NULL,

  PRIMARY KEY (`code`)

);

 

#CODE TO INSERT INTO FLAG DIMENSION

INSERT INTO `G02_OLAP`.`Dim_Flag`(`code`,`flag_desc`)

VALUES("D","Withheld to avoid disclosing data for individual companies,data are included in higher level totals"),

("S","Withheld because estimate did not meet publication standards"),

("G","Low noise infusion (0% to <2%)"),

("H", "Medium noise infusion (2% to 5%)"),

("J","High noise infusion (>=5%)");

 

#CHECKPOINT FOR FLAG DIMENSION

SELECT * FROM `G02_OLAP`.`Dim_Flag`;

 

#CODE TO CREATE CONGRESSIONAL DISTRICT DIMENSION

CREATE TABLE `G02_OLAP`.`Dim_Congressional_District` (

  `cd_id` INT NOT NULL auto_increment,

  `fips` char(2),

  `area_name` char(100),

  `cong_name` char(9),

  `dist_num` varchar(3),

  PRIMARY KEY (`cd_id`)

);

 

#CODE TO INSERT INTO CONGRESSIONAL DISTRICT DIMENSION

INSERT INTO `G02_OLAP`.`Dim_Congressional_District`(`cd_id`, `fips`, `area_name`, `cong_name`, `dist_num`)

SELECT `Congressional_District`.`cd_id`, `Area`.`fips`, `Area`.`area_name`, `Congress`.`cong_name`, `Congressional_District`.`dist_num`

FROM `FCP_CBP_OLTP`.`Congressional_District`

 

JOIN `FCP_CBP_OLTP`.`Area` ON `Area`.`fips` = `Congressional_District`.`fips`

JOIN `FCP_CBP_OLTP`.`Congress` ON `Congress`.`cong_id` = `Congressional_District`.`cong_id`;

 

 #CHECKPOINT FOR CONGRESSIONAL DISTRICT DIMENSION

 SELECT * FROM `G02_OLAP`.`Dim_Congressional_District`;

 

#CODE TO CREATE DATE DIMENSION

CREATE TABLE `G02_OLAP`.`Dim_Date` (

  `date_id` INT NOT NULL auto_increment,

  `year` year,

  PRIMARY KEY (`date_id`)

);

 

#CODE TO INSERT INTO DATE DIMENSION

INSERT INTO `G02_OLAP`.`Dim_Date`(`year`)

SELECT DISTINCT `year` FROM FCP_CBP_OLTP.District_Industry

ORDER BY `year` ASC;

 

#CHECKPOINT FOR DATE DIMENSION

SELECT * FROM `G02_OLAP`.`Dim_Date`;

 

DROP TABLE IF EXISTS `G02_OLAP`.`Facts_District_Industry`;

CREATE TABLE `G02_OLAP`.`Facts_District_Industry` (

  `facts_tabID` INT AUTO_INCREMENT,

  `cd_id` int(5),

  `ind_id` int(5),

  `date_id` char(10),

  `num_est` int ,

  `num_empl` int ,

  `empl_f` char(1) ,

  `q1_pr` int,

  `q1_pr_f` char(1),

  `yr_pr` int ,

  `yr_pr_f` char(1),

  PRIMARY KEY (`facts_tabID`),

 CONSTRAINT `Dim_Congressional_District_fk` FOREIGN KEY(`cd_id`)

 REFERENCES `G02_OLAP`.`Dim_Congressional_District`(`cd_id`),

 CONSTRAINT `Dim_Industry_fk` FOREIGN KEY(`ind_id`)

 REFERENCES `G02_OLAP`.`Dim_Industry`(`ind_id`),

 CONSTRAINT `Dim_Flag_fk` FOREIGN KEY(`empl_f`)

 REFERENCES `G02_OLAP`.`Dim_Flag`(`code`),

 CONSTRAINT `Dim_Flag2_fk` FOREIGN KEY(`q1_pr_f`)

 REFERENCES `G02_OLAP`.`Dim_Flag`(`code`),

 CONSTRAINT `Dim_Flag3_fk` FOREIGN KEY(`yr_pr_f`)

 REFERENCES `G02_OLAP`.`Dim_Flag`(`code`)

 );

 

INSERT INTO `G02_OLAP`.`Facts_District_Industry`(`cd_id`, `ind_id`, `date_id`, `num_est`, `num_empl`, `empl_f`, `q1_pr`, `q1_pr_f`, `yr_pr`, `yr_pr_f`)

SELECT `Congressional_District`.`cd_id`, `Industry`.`ind_id`,

 `Dim_Date`.`date_id`, `District_Industry`.`num_est`,

 `District_Industry`.`num_empl`,

 `District_Industry`.`empl_flag_id`, `District_Industry`.`q1_pr`,

 `District_Industry`.`q1_pr_flag_id`, `District_Industry`.`yr_pr`,

 `District_Industry`.`yr_pr_flag_id`

 FROM `FCP_CBP_OLTP`.`District_Industry`

 

 JOIN `FCP_CBP_OLTP`.`Congressional_District` ON `Congressional_District`.`cd_id` = `District_Industry`.`cd_id`

 JOIN `FCP_CBP_OLTP`.`Industry` ON `Industry`.`ind_id` = `District_Industry`.`ind_id`

 JOIN `G02_OLAP`.`Dim_Date` ON `Dim_Date`.`year`= `District_Industry`.`year`;

 

#CHECKPOINT FOR DISTRICT INDUSTRY

SELECT * FROM `G02_OLAP`.`Facts_District_Industry`
