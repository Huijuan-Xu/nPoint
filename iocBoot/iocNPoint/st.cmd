#!../../bin/linux-x86_64/nPoint

< envPaths

epicsEnvSet("ENGINEER", "Huijuan x4394")
epicsEnvSet("LOCATION", "XF:05ID D Hutch")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.5.3.255")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/nPoint.dbd"
nPoint_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/${IOC}"

## motorUtil (allstop & alldone)
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=XF:05IDD-ES:1{MC:25}")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db", "IOC=XF:05IDD-CT{IOC:MC25}")
#dbLoadRecords("$(EPICS_BASE)/db/asynRecord.db", "P=XF:05IDD-CT,R={MC:25},PORT=LC400,ADDR=0,OMAX=100,IMAX=100")
##
< LC400.cmd
#< C300.cmd

dbLoadRecords("$(EPICS_BASE)/db/asynRecord.db", "P=XF:05IDD-CT,R={MC:25}Asyn,PORT=LC400,ADDR=0,OMAX=100,IMAX=100")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

iocInit

## motorUtil (allstop & alldone)
#motorUtilInit("{MC:25}")

## more autosave/restore machinery
cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

cd $(TOP)
dbl > records.dbl
