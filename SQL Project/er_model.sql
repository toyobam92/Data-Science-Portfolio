
###THE following set of codes CREATE tables and POPULATES/INSERTS the data into those tables
#Congress Table
CREATE TABLE `G02_OLTP`.`Congress` (
  `cong_id` INT(5) NOT NULL AUTO_INCREMENT,
  `cong_name` char(9),
  PRIMARY KEY (`cong_id`),
  KEY `FK` (`cong_name`)
);

#Insert Congress Data 
INSERT INTO G02_OLTP.Congress(cong_name)
SELECT DISTINCT CONGRESS FROM FCP_CBP.full_dataset 
ORDER BY CONGRESS ASC;

#Check point
SELECT *
FROM G02_OLTP.Congress 
ORDER BY cong_id;

#Insert State Table 
CREATE TABLE `G02_OLTP`.`State` (
  `fips` char(2) NOT NULL,
  `State_name` char(100) ,
  PRIMARY KEY (`fips`)
);
##Insert State Data 

# METHOD #1 (QUERY USING TRIM FUNCTION)
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`)
SELECT DISTINCT `STATE_FIPS`, TRIM(`STATE`) FROM `FCP_CBP`.`full_dataset`
WHERE `STATE` NOT IN (SELECT `State_name` FROM `G02_OLTP`.`State` GROUP BY STATE)
;

## METHOD #2 (HARD CODE)
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(1, 'Alabama');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(2, 'Alaska');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(4, 'Arizona');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(5, 'Arkansas');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(6, 'California');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(8, 'Colorado');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(9, 'Connecticut');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(10, 'Delaware');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(11, 'District of Columbia');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(12, 'Florida');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(13, 'Georgia');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(15, 'Hawaii');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(16, 'Idaho');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(17, 'Illinois');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(18, 'Indiana');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(19, 'Iowa');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(20, 'Kansas');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(21, 'Kentucky');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(22, 'Louisiana');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(23, 'Maine');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(24, 'Maryland');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(25, 'Massachusetts');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(26, 'Michigan');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(27, 'Minnesota');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(28, 'Mississippi');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(29, 'Missouri');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(30, 'Montana');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(31, 'Nebraska');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(32, 'Nevada');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(33, 'New Hampshire');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(34, 'New Jerse' );
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(35, 'New Mexico');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(36, 'New York');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(37, 'North Carolina');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(38, 'North Dakota');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(39, 'Ohio');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(40, 'Oklahoma');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(41, 'Oregon');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(42, 'Pennsylvania');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(44, 'Rhode Island');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(45, 'South Carolina');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(46, 'South Dakota');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(47, 'Tennessee');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(48, 'Texas');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(49, 'Utah');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(50, 'Vermont');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(51, 'Virginia');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(53, 'Washington');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(54, 'West Virginia');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(55, 'Wisconsin');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(56, 'Wyoming');
INSERT INTO `G02_OLTP`.`State`(`fips`,`State_name`) VALUES(72, 'Puerto Rico');

#Checkpoint
SELECT *
FROM State
ORDER BY State_name ASC;

#Create Congressional District table 
CREATE TABLE `G02_OLTP`.`Congressional_District` (
  `cd_id` int(5) NOT NULL AUTO_INCREMENT,
  `cong_id` int(5) NOT NULL,
  `fips` char(2) NOT NULL,
  `dist_num` varchar(3) NULL,
 PRIMARY KEY (`cd_id`),
 CONSTRAINT `Congress_fk` FOREIGN KEY(`cong_id`)
 REFERENCES `G02_OLTP`.`Congress`(`cong_id`),
 CONSTRAINT `State_fk` FOREIGN KEY(`fips`)
 REFERENCES `G02_OLTP`.`State`(`fips`));

INSERT INTO `G02_OLTP`.`Congressional_District`(`cong_id`, `fips`, `dist_num`)
SELECT DISTINCT `Congress`.`cong_id`, STATE_FIPS, DISTRICT 
FROM FCP_CBP.full_dataset
JOIN G02_OLTP.State ON full_dataset.STATE_FIPS = State.fips
JOIN G02_OLTP.Congress ON full_dataset.CONGRESS = Congress.cong_name;

#Checkpiont 
SELECT * FROM G02_OLTP.Congressional_District;
 
#Create Industry table
CREATE TABLE `G02_OLTP`.`Industry` (
  `ind_id` INT(5) NOT NULL AUTO_INCREMENT,
  `naics` char(6),
  `ind_desc` varchar(75),
  PRIMARY KEY (`ind_id`),
  KEY `AK` (`naics`)
);

#Insert Industry data 
INSERT INTO `G02_OLTP`.`Industry`(naics, ind_desc)
SELECT DISTINCT NAICS, NAICS_DESC FROM FCP_CBP.full_dataset;

SELECT * 
FROM G02_OLTP.Industry;

#Create Flag table 
CREATE TABLE `G02_OLTP`.`Flag` (
  `code` varchar(5) NOT NULL,
  `flag_desc` varchar(100) NOT NULL,
  PRIMARY KEY (`code`)
);

#Insert Flag data 
INSERT INTO G02_OLTP.Flag(code,flag_desc)
VALUES("D","Withheld to avoid disclosing data for individual companies,data are included in higher level totals"),
("S","Withheld because estimate did not meet publication standards"),
("G","Low noise infusion (0% to <2%)"),
("H", "Medium noise infusion (2% to 5%)"),
("J","High noise infusion (>=5%)");

#Check point 
SELECT * 
FROM G02_OLTP.Flag;

#Create District Industry table 
CREATE TABLE `G02_OLTP`.`District_Industry` (
  `cd_id` int(5) NOT NULL,
  `ind_id` int(5) NOT NULL,
  `year` char(4) NOT NULL,
  `num_est` int,
  `num_empl` int,
  `empl_f` char(1) NULL,
  `q1_pr` int,
  `q1_pr_f` char(1) NULL,
  `yr_pr` int,
  `yr_pr_f` char(1) NULL,
  PRIMARY KEY (`year`, `cd_id`,`ind_id`),
 CONSTRAINT `Congressinal_District_fk` FOREIGN KEY(`cd_id`)
 REFERENCES `G02_OLTP`.`Congressional_District`(`cd_id`),
 CONSTRAINT `Industry_fk` FOREIGN KEY(`ind_id`)
 REFERENCES `G02_OLTP`.`Industry`(`ind_id`),
 CONSTRAINT `Flag_fk` FOREIGN KEY(`empl_f`)
 REFERENCES `G02_OLTP`.`Flag`(`code`),
 CONSTRAINT `Flag2_fk` FOREIGN KEY(`q1_pr_f`)
 REFERENCES `G02_OLTP`.`Flag`(`code`),
 CONSTRAINT `Flag3_fk` FOREIGN KEY(`yr_pr_f`)
 REFERENCES `G02_OLTP`.`Flag`(`code`)
 );

#Insert District_Industry Data

INSERT INTO `G02_OLTP`.`District_Industry`(`cd_id`, `ind_id`, `year`, `num_est`, `num_empl`, `empl_f`, `q1_pr`, `q1_pr_f`, `yr_pr`, `yr_pr_f`)
SELECT DISTINCTROW TRIM(`Congressional_District`.`cd_id`), TRIM(`Industry`.`ind_id`), TRIM(`YR`), TRIM(`NUM_EST`), TRIM(`NUM_EMPL`), 
TRIM(`EMPL_F`), TRIM(`Q1_PR`), TRIM(`Q1_PR_F`), TRIM(`YR_PR`), TRIM(`YR_PR_F`) 
FROM FCP_CBP.full_dataset
JOIN G02_OLTP.Industry ON full_dataset.naics = Industry.naics
JOIN G02_OLTP.Congress ON full_dataset.CONGRESS = Congress.cong_name
JOIN G02_OLTP.State ON full_dataset.STATE_FIPS = State.fips
JOIN G02_OLTP.Congressional_District ON Congress.cong_id = Congressional_District.cong_id  AND 
State.fips = Congressional_District.fips AND full_dataset.DISTRICT = Congressional_District.dist_num
GROUP BY `cd_id`, `ind_id`, `YR`, `num_est`, `num_empl`, `empl_f`, `q1_pr`, `q1_pr_f`, `yr_pr`, `yr_pr_f`;

###SELECT FUNCTIONS CHECKPOINT 

SELECT * FROM G02_OLTP.State;

SELECT * FROM G02_OLTP.Congress;

SELECT * FROM G02_OLTP.Congressional_District;

SELECT * FROM G02_OLTP.District_Industry;

SELECT * FROM G02_OLTP.Flag;

SELECT * FROM G02_OLTP.Industry;

DROP TABLE G02_OLTP.Congressional_District, G02_OLTP.Congress, G02_OLTP.Industry, G02_OLTP.Flag, G02_OLTP.District_Industry, G02_OLTP.Area
