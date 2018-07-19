# Mysql Note

TBD
  
# Basic Commands
 ```
 mysql -u root -p123abc
 
Warning: Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
[root@UAT10161 hj_xu]# mysql -u root -p123abc
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 771
Server version: 5.6.21-ctrip MySQL Community Server (GPL)

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
 show databases;
 +--------------------+
 | Database           |
 +--------------------+
 | information_schema |
 | camundadb          |
 | mysql              |
 | performance_schema |
 +--------------------+
 4 rows in set (0.00 sec)

 use camundadb;
 show tables;
 +-------------------------+
 | Tables_in_camundadb     |
 +-------------------------+
 | ACT_GE_BYTEARRAY        |
 | ACT_GE_PROPERTY         |
 | ACT_HI_ACTINST          |
 | ACT_HI_ATTACHMENT       |
 | ACT_HI_BATCH            |
 | ACT_HI_CASEACTINST      |
 | ACT_HI_CASEINST         |
 | ACT_HI_COMMENT          |
 | ACT_HI_DECINST          |
 | ACT_HI_DEC_IN           |
 | ACT_HI_DEC_OUT          |
 | ACT_HI_DETAIL           |
 | ACT_HI_EXT_TASK_LOG     |
 | ACT_HI_IDENTITYLINK     |
 | ACT_HI_INCIDENT         |
 | ACT_HI_JOB_LOG          |
 | ACT_HI_OP_LOG           |
 | ACT_HI_PROCINST         |
 | ACT_HI_TASKINST         |
 | ACT_HI_VARINST          |
 | ACT_ID_GROUP            |
 | ACT_ID_INFO             |
 | ACT_ID_MEMBERSHIP       |
 | ACT_ID_TENANT           |
 | ACT_ID_TENANT_MEMBER    |
 | ACT_ID_USER             |
 | ACT_RE_CASE_DEF         |
 | ACT_RE_DECISION_DEF     |
 | ACT_RE_DECISION_REQ_DEF |
 | ACT_RE_DEPLOYMENT       |
 | ACT_RE_PROCDEF          |
 | ACT_RU_AUTHORIZATION    |
 | ACT_RU_BATCH            |
 | ACT_RU_CASE_EXECUTION   |
 | ACT_RU_CASE_SENTRY_PART |
 | ACT_RU_EVENT_SUBSCR     |
 | ACT_RU_EXECUTION        |
 | ACT_RU_EXT_TASK         |
 | ACT_RU_FILTER           |
 | ACT_RU_IDENTITYLINK     |
 | ACT_RU_INCIDENT         |
 | ACT_RU_JOB              |
 | ACT_RU_JOBDEF           |
 | ACT_RU_METER_LOG        |
 | ACT_RU_TASK             |
 | ACT_RU_VARIABLE         |
 +-------------------------+
 46 rows in set (0.00 sec)

 describe ACT_RE_PROCDEF;
 +---------------------+---------------+------+-----+---------+-------+
 | Field               | Type          | Null | Key | Default | Extra |
 +---------------------+---------------+------+-----+---------+-------+
 | ID_                 | varchar(64)   | NO   | PRI | NULL    |       |
 | REV_                | int(11)       | YES  |     | NULL    |       |
 | CATEGORY_           | varchar(255)  | YES  |     | NULL    |       |
 | NAME_               | varchar(255)  | YES  |     | NULL    |       |
 | KEY_                | varchar(255)  | NO   |     | NULL    |       |
 | VERSION_            | int(11)       | NO   |     | NULL    |       |
 | DEPLOYMENT_ID_      | varchar(64)   | YES  | MUL | NULL    |       |
 | RESOURCE_NAME_      | varchar(4000) | YES  |     | NULL    |       |
 | DGRM_RESOURCE_NAME_ | varchar(4000) | YES  |     | NULL    |       |
 | HAS_START_FORM_KEY_ | tinyint(4)    | YES  |     | NULL    |       |
 | SUSPENSION_STATE_   | int(11)       | YES  |     | NULL    |       |
 | TENANT_ID_          | varchar(64)   | YES  | MUL | NULL    |       |
 | VERSION_TAG_        | varchar(64)   | YES  | MUL | NULL    |       |
 | HISTORY_TTL_        | int(11)       | YES  |     | NULL    |       |
 +---------------------+---------------+------+-----+---------+-------+
 14 rows in set (0.00 sec)

 ```

