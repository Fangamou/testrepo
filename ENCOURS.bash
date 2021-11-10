 

                                  ASSUMPTIONS
|=========|=================|==================|=======|==========================|=============|
|ROLE     |SERVER_NAME      |  DB_UNIQUE_NAME  | SID   | ORACLE NET SERVICES NAME | @IP         |
|=========|=================|==================|=======|==========================|=============|
|Primary  | simma-primary   |  primdb          |simogc |       primdb             |10.173.85.130|          
|=========|=================|==================|=======|==========================|=============|
|Standby  | simma-secondary |  secondb         |simogc |      secondb             |10.173.85.131|
|=========|=================|==================|=======|==========================|=============|

-------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ON BOTH PRIMARY AND STANDBY SERVERS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-------------------------------------------------------------------------------------------------
1-CREATION DE REPO LOCAL
=========================
mkdir -p /mnt/cdrom
mount /dev/sr0  /mnt/cdrom
cp /mnt/cdrom/media.repo /etc/yum.repos.d/rhel7dvd.repo
chmod 644 /etc/yum.repos.d/rhel7dvd.repo
vim /etc/yum.repos.d/rhel7dvd.repo
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[InstallMedia]
name=DVD for Red Hat Enterprise Linux 7.1 Server
mediaid=1359576196.686790
metadata_expire=-1
gpgcheck=1
cost=500
enabled=1
baseurl=file:///mnt/cdrom
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
yum clean all
yum repolist
yum update
-------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ON BOTH PRIMARY AND STANDBY SERVERS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-------------------------------------------------------------------------------------------------
2-PARAMETRATGE DU NOYAU
=========================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo 'fs.file-max = 6815744' >> /etc/sysctl.conf
echo 'kernel.sem = 250 32000 100 128' >> /etc/sysctl.conf
echo 'kernel.shmmni = 4096' >> /etc/sysctl.conf
echo 'kernel.shmall = 1073741824' >> /etc/sysctl.conf
echo 'kernel.shmmax = 4398046511104' >> /etc/sysctl.conf
echo 'kernel.panic_on_oops = 1' >> /etc/sysctl.conf
echo 'net.core.rmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 4194304' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 1048576' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.rp_filter = 2' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.rp_filter = 2' >> /etc/sysctl.conf
echo 'fs.aio-max-nr = 1048576' >> /etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range = 9000 65500' >> /etc/sysctl.conf
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/sbin/sysctl -p
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo 'oracle   soft   nofile    1024' >> /etc/security/limits.conf
echo 'oracle   hard   nofile    65536' >> /etc/security/limits.conf
echo 'oracle   soft   nproc    16384' >> /etc/security/limits.conf
echo 'oracle   hard   nproc    16384' >> /etc/security/limits.conf
echo 'oracle   soft   stack    10240' >> /etc/security/limits.conf
echo 'oracle   hard   stack    32768' >> /etc/security/limits.conf
echo 'oracle   hard   memlock  134217728'>> /etc/security/limits.conf
echo 'oracle   soft   memlock  134217728'>> /etc/security/limits.conf
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
3-INSTALLATION DES PACKAGES
=============================
yum install binutils -y
yum install compat-libstdc++-33 -y
yum install compat-libstdc++-33.i686 -y
yum install gcc -y
yum install gcc-c++ -y
yum install glibc -y
yum install glibc.i686 -y
yum install glibc-devel -y
yum install glibc-devel.i686 -y
yum install ksh -y
yum install libgcc -y
yum install libgcc.i686 -y
yum install libstdc++ -y
yum install libstdc++.i686 -y
yum install libstdc++-devel -y
yum install libstdc++-devel.i686 -y
yum install libaio -y
yum install libaio.i686 -y
yum install libaio-devel -y
yum install libaio-devel.i686 -y
yum install libXext -y
yum install libXext.i686 -y
yum install libXtst -y
yum install libXtst.i686 -y
yum install libX11 -y
yum install libX11.i686 -y
yum install libXau -y
yum install libXau.i686 -y
yum install libxcb -y
yum install libxcb.i686 -y
yum install libXi -y
yum install libXi.i686 -y
yum install make -y
yum install sysstat -y
yum install unixODBC -y
yum install unixODBC-devel -y
yum install zlib-devel -y
yum install zlib-devel.i686 -y

4-CREATION DES GROUPES ET UILISATEURS
======================================
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54327 asmdb
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin
groupadd -g 54330 racdba
useradd -u 54321 -g oinstall -G dba,oper,backupdba,dgdba,kmdba,asmdb,racdba oracle
useradd -u 54322 -g oinstall -G dba,asmdb,asmoper,asmadmin,racdba grid

5-CREATION DES REPERTOIRES ET DES OCTROIE DES DROITS
====================================================
mkdir -p /u01/app/oracle
mkdir -p /u01/app/oraInventory
mkdir -p /u01/app/oracle/product/12.1.0.2/db_1
mkdir -p /u02/app/oracle/oradata/DONNEES
mkdir -p /u03/app/oracle/oradata/RECUPERATIONS

chown -R oracle:oinstall /u01/app/oracle
chown -R oracle:oinstall /u01/app/oraInventory
chown -R oracle:oinstall /u01/app/oracle/product/12.1.0.2/db_1
chown -R oracle:oinstall /u02/app/oracle/oradata/DONNEES
chown -R oracle:oinstall /u03/app/oracle/oradata/RECUPERATIONS

chmod -R 775 /u01
chmod -R 775 /u02
chmod -R 775 /u03
6-ARRET DU FIREWALLD
========================
systemctl stop firewalld
systemctl disable firewalld
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo '# This file controls the state of SELinux on the system.'>/etc/selinux/config
echo '# SELINUX= can take one of these three values:'>>/etc/selinux/config
echo '#     enforcing - SELinux security policy is enforced.'>>/etc/selinux/config
echo '#     permissive - SELinux prints warnings instead of enforcing.'>>/etc/selinux/config
echo '#     disabled - No SELinux policy is loaded.'>>/etc/selinux/config
echo 'SELINUX=permissive'>>/etc/selinux/config
echo '# SELINUXTYPE= can take one of three two values:'>>/etc/selinux/config
echo '#     targeted - Targeted processes are protected,'>>/etc/selinux/config
echo '#     minimum - Modification of targeted policy. Only selected processes are protected.'>>/etc/selinux/config
echo '#     mls - Multi Level Security protection.'>>/etc/selinux/config
echo 'SELINUXTYPE=targeted'>>/etc/selinux/config
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
setenforce Permissive

-------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!ON THE PRIMARY SERVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-------------------------------------------------------------------------------------------------

7-PARAMETRAGE DES NOMS ET ADRESSES
===================================
echo 'simma-primary'> /etc/hostname 
echo '10.173.85.130'"  "'simma-primary.orange-sonatel.com'"  "'simma-primary'>> /etc/hosts
echo '10.173.85.131'"  "'simma-secondary.orange-sonatel.com'"  "'simma-secondary'>> /etc/hosts

8-PARAMETRAGE DE L'ENVIRONNEMENT DE L'INSTALLATEUR
===================================================
echo 'export TMP=/tmp'>>/home/oracle/.bash_profile
echo 'export TMPDIR=$TMP'>>/home/oracle/.bash_profile
echo 'export ORACLE_HOSTNAME=simma-primary.orange-sonatel.com'>>/home/oracle/.bash_profile
echo 'export ORACLE_UNQNAME=primdb'>>/home/oracle/.bash_profile
echo 'export ORACLE_BASE=/u01/app/oracle'>>/home/oracle/.bash_profile
echo 'export ORACLE_HOME=$ORACLE_BASE/product/12.1.0.2/db_1'>>/home/oracle/.bash_profile
echo 'export ORACLE_SID=simogc'>>/home/oracle/.bash_profile
echo 'export PATH=/usr/sbin:$PATH'>>/home/oracle/.bash_profile
echo 'export PATH=$ORACLE_HOME/bin:$PATH'>>/home/oracle/.bash_profile
echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib'>>/home/oracle/.bash_profile
echo 'export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib'>>/home/oracle/.bash_profile
passwd oracle

---------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!LLATION ON BOTH PRIMARY AND STANDBY DATABASE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------
9-ON THE PRIMARY SERVER INSTALL THE SOFTWARE AND CREATE THE DATABASE
10-ON THE STANDBY SERVER INSTALL ONLY THE SOFTWARE

---------------------------------------------------------------------------------------------------
11.!!!!!!!!!!!!!!!!!!!!PREPARING THE PRIMARY SERVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------
|OS>vim /u01/app/oracle/product/12.1.0.2/db_1/network/admin/tnsnames.ora
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# tnsnames.ora Network Configuration File: 
#/u01/app/oracle/product/12.1.0.2/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.
PRIMDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.130)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = simogc)
    )
  )
SECONDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.131)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = simogc)
    )
	)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OS>vim /u01/app/oracle/product/12.1.0.2/db_1/network/admin/listener.ora
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.130)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
SID_LIST_LISTENER    =
 (SID_LIST =
 (SID_DESC =
 (GLOBAL_DBNAME = primdb )
 (ORACLE_HOME = /u01/app/oracle/product/12.1.0.2/db_1)
 (SID_NAME = simogc )
 )
)
ADR_BASE_LISTENER = /u01/app/oracle

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tnsping primdb
tnsping secondb

sqlplus / as sysdba
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ALTER DATABASE FLASHBACK ON;
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=7200;
ALTER SYSTEM SET UNDO_RETENTION=14400;
ALTER DATABASE FORCE LOGGING;
ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='dg_config=(primdb,secondb)';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=use_db_recovery_file_dest' SCOPE=BOTH;
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES=5;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='service=secondb async affirm valid_for=(online_logfiles,primary_role) db_unique_name=secondb reopen=15 net_timeout=10';

ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE;
ALTER SYSTEM SET FAL_SERVER='camdb';
ALTER SYSTEM SET FAL_CLIENT='sonfdb';
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT='AUTO' ;
ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE SCOPE=SPFILE;
SELECT NAME,VALUE FROM V$PARAMETER WHERE NAME IN
('db_unique_name','db_domaine','service_names','spfile','log_archive_config','log_archive_max_processes',
 'log_archive_dest_1','log_archive_dest_2','fal_client','fal_server','db_create_file_dest','db_create_online_log_dest_1',
  'db_create_online_log_dest_2','db_recovery_file_dest','db_recovery_file_dest_size','standby_file_management',
  'dg_broker_config_file1','dg_broker_config_file2','dg_broker_start','local_listener','undo_retention','db_flashback_retention_target');

ALTER DATABASE ADD STANDBY LOGFILE '/u03/app/oracle/oradata/RECUPERATIONS/SIMOGC/redostn01.log' SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE '/u03/app/oracle/oradata/RECUPERATIONS/SIMOGC/redostn02.log' SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE '/u03/app/oracle/oradata/RECUPERATIONS/SIMOGC/redostn03.log' SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE '/u03/app/oracle/oradata/RECUPERATIONS/SIMOGC/redostn04.log' SIZE 50M;


SELECT GROUP# G, Type, member FROM v$logfile;
exit
reboot
sqlplus / as sysdba
CREATE pfile='/tmp/initsimogc.ora' FROM spfile;
exit
orapwd file=/tmp/orapwsimogc password=oracle entries=30 force=yes;
scp /tmp/orapwsimogc    oracle@10.173.85.131:/u01/app/oracle/product/12.1.0.2/db_1/dbs/
scp /tmp/initsimogc.ora oracle@10.173.85.131:/tmp/
--------------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!ON THE STANDBY SERVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------------------------------------------------------------------------------------

===============================
11.CONFIGURE TNS AND LISTENER               
===============================
OS>vim /u01/app/oracle/product/12.1.0.2/db_1/network/admin/tnsnames.ora|
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# tnsnames.ora Network Configuration File: 
#/u01/app/oracle/product/12.1.0.2/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.
PRIMDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.130)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = simogc)
    )
  )
SECONDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.131)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = simogc)
    )
	)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OS>vim /u01/app/oracle/product/12.1.0.2/db_1/network/admin/listener.ora|
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.173.85.131)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
SID_LIST_LISTENER    =
 (SID_LIST =
 (SID_DESC =
 (GLOBAL_DBNAME = secondb )
 (ORACLE_HOME = /u01/app/oracle/product/12.1.0.2/db_1)
 (SID_NAME = simogc )
 )
)
ADR_BASE_LISTENER = /u01/app/oracle
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
su - oracle
lsnrctl reload listener
tnsping PRIMDB
tnsping SECONDB

-------------------------------------------------------------------------------------------------------- 
!!!!!!!!!!!!!!!!!!!!!!17.Create audit destination at os level using mkdir!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
--------------------------------------------------------------------------------------------------------
mkdir -p /u01/app/oracle/audit/simogc
mkdir -p /u01/app/oracle/admin/simogc/adump
mkdir -p /u03/app/oracle/oradata/RECUPERATIONS/SIMOGC
mkdir -p /u01/app/oracle/product/12.1.0.2/db_1/dbs/
--------------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!18.Modify the parameter file!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------------------------------------------------------------------------------------

sqlplus / as sysdba
startup nomount pfile='/tmp/initsimogc.ora';

--------------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!19.Duplicate SONFDB database via RMAN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------------------------------------------------------------------------------------
rman target sys/oracle@primdb auxiliary sys/oracle@secondb
DUPLICATE TARGET DATABASE FOR STANDBY  FROM ACTIVE DATABASE;
sql "ALTER SYSTEM SWITCH LOGFILE";
sql "ALTER DATABASE SET STANDBY TO MAXIMIZE PERFORMANCE";
sql "ALTER SYSTEM ARCHIVE LOG CURRENT";
sql "alter database recover managed standby database parallel disconnect";}
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
man target sys/oracle@sonfdb auxiliary sys/oracle@camdb
run
{
set newname for database to new;
allocate channel primaire1 type disk;
allocate channel primaire2 type disk;
allocate channel primaire3 type disk;
allocate auxilary channel secours1 type disk;
run
{
set newname for database to new;
duplicate target database for standby from active database
spfile
parameter_value_convert 'sonfdb','camdb'
set db_unique_name='camdb'
reset control_files
set db_create_file_dest='/u02/app/oracle/oradata/DONNEES'
set db_create_online_log_dest_1='/u02/app/oracle/oradata/DONNEES/CAMDB/onlinelog'
set db_recovery_file_dest='/u03/app/oracle/oradata/RECUPERATIONS'
set audit_file_dest='/u01/app/oracle/admin/camdb/adump'
set local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.0.101)(PORT=1521)))'
set fal_client='camdb'
set fal_server='sonfdb'
set log_archive_dest_2='service=sonfdb async affirm valid_for=(online_logfiles,primary_role) db_unique_name=sonfdb reopen=15 net_timeout=100'
}

--------------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ON THE STANDBY SERVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------------------------------------------------------------------------------------
20.Drop multiplexed Standby Redo Log (SRL) on standby
======================================================
SQL>SELECT NAME,DATABASE_ROLE,OPEN_MODE FROM v$database;
SQL> column member format a50;
SQL> SELECT GROUP#,member FROM v$logfile where type='STANDBY' ORDER BY 1,2;
SQL> ALTER DATABASE DROP LOGFILE MEMBER '/u01/app/oracle/fast_recovery_area/STANDBY/onlinelog/-------.log';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '/u01/app/oracle/fast_recovery_area/STANDBY/onlinelog/-------.log';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '/u01/app/oracle/fast_recovery_area/STANDBY/onlinelog/-------.log';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '/u01/app/oracle/fast_recovery_area/STANDBY/onlinelog/-------.log';
/!\ One of the logfile member will not drop as it is in use we need 
--- to switch log in the production and drop it as below shown.
--------------------------------------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ON THE ITUSDB SERVER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--------------------------------------------------------------------------------------------------------
SQL> ALTER SYSTEM SWITCH LOGFILE;
|=========================================================================|
|//////////////////ON THE STANDBY SERVER//////////////////////////////////|
|=========================================================================|
21.START STOP MRP on the standby
===========================================================================
SQL>alter database recover managed standby database disconnect;
SQL>alter database recover managed standby database cancel;

22.VERIFY REDO APPLY
===========================================================================
SQL>alter database recover managed standby database disconnect;
|=========================================================================|
|//////////////////ON BOTH THE ITUSDB AND THE STANDBY SERVERS////////////|
|=========================================================================|
SQL>set line 999;
SQL> select * from v$dataguard_status order by timestamp;
SQL> select dest_id,status,destination,error FROM v$archive_dest where dest_id<=2;

If you see any error do this on ITUSDB

SQL> ALTER SYSTEM SET log_archive_dest_state_2='DEFER';
SQL> ALTER SYSTEM SET log_archive_dest_state_2='ENABLE';
SQL> select dest_id,status,destination,error FROM v$archive_dest where dest_id<=2;
|=========================================================================|
|//////////////////ON THE ITUSDB SERVER//////////////////////////////////|
|=========================================================================|
SQL>select sequence#,first_time, next_time, applied,archived FROM v$archived_log
where name='standby'order by first_time;
SQL>select STATUS,GAP_STATUS from v$archive_dest_status where dest_id=2;
SQL>archive log list;
|=========================================================================|
|//////////////////ON THE STANDBY SERVER//////////////////////////////////|
|=========================================================================|
SQL>select process,status,sequence# from v$managed_standby where dest_id=2;
SQL>select sequence#,first_time, next_time, applied,name filename FROM v$archived_log
order by sequence#;
23.Enable flashback on standby
==============================================================================
SQL>alter database recover managed standby database cancel;
SQL>alter database flashback on ;
SQL>alter database recover managed standby database disconnect;








