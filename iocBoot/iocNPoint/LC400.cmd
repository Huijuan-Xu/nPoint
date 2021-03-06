#emulated serial port (slower transfer rates)
#drvAsynSerialPortConfigure("serial1", "/dev/ttyUSB0", 0, 0, 0)
#asynSetOption("serial1",0,"baud","230400")
#asynSetOption("serial1",0,"bits","8")
#asynSetOption("serial1",0,"parity","none")
#asynSetOption("serial1",0,"stop","1")

#asynSetTraceIOMask("serial1", -1, 0x4)
#asynSetTraceMask("serial1", -1, 0x9)

#FTDI driver
drvAsynFTDIPortConfigure("LC400ftdi", "0x403", "0x6014","3000000", "2", "0", "0", "1")
# Allow FTDI info detected
epicsThreadSleep(2)

dbLoadRecords("auxParameters.db","PORT=LC400,ADDR=0,P=XF:05IDD-CT,R={MC:25}")
dbLoadRecords("auxParameters.db","PORT=LC400,ADDR=1,P=XF:05IDD-CT,R={MC:25}")
dbLoadRecords("auxParameters.db","PORT=LC400,ADDR=2,P=XF:05IDD-CT,R={MC:25}")

dbLoadTemplate("LC400.substitutions")

# LC400CreateController(
#      port name,
#      serial port,
#      num axes,
#      moving poll period (ms),
#      idle poll period (ms))
LC400CreateController("LC400", "LC400ftdi", 3, 100, 1000)
#LC400CreateController("LC400", "serial1", 3, 100, 1000)

#optional functions
#LC400ConfigAxis(
#       port name,
#       axis number,
#       positive hard limit
#       negative hard limit
#       tolerance for hard limits in %
#)
LC400ConfigAxis("LC400ftdi", 0, 55, -55, 0.05)
LC400ConfigAxis("LC400ftdi", 1, 55, -55, 0.05)
LC400ConfigAxis("LC400ftdi", 2, 55, -55, 0.05)
