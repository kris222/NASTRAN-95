      SUBROUTINE ALGPO (SCR1)
C
      EXTERNAL        ORF
      INTEGER         APRESS,ATEMP,STRML,NAME(2),CORWDS,ITRL(7),TWO(32),
     1                ORF,CASECC,CASECA,GEOM3A,SCR1,LEND(3),SYSBUF,
     2                PGEOM,RD,RDREW,WRT,WRTREW,REW,NOREW,PLOAD2(3),
     3                TEMP(3),TEMPD(3),LREC(5)
      DIMENSION       RREC(5)
      CHARACTER       UFM*23,UWM*25
      COMMON /XMSSG / UFM,UWM
      COMMON /BLANK / APRESS,ATEMP,STRML,PGEOM,IPRTK,IFAIL
      COMMON /SYSTEM/ SYSBUF,NOUT
      COMMON /NAMES / RD,RDREW,WRT,WRTREW,REW,NOREW
      COMMON /TWO   / TWO
      COMMON /ZZZZZZ/ IZ(1)
      EQUIVALENCE     (LREC(1),RREC(1))
      DATA    LEND  / 3*2147483647 /
      DATA    NAME  / 4HALG ,4H    /
      DATA    LABP  / 4HPLOA/      , LABT /4HTEMP/
      DATA    PLOAD2/ 6809,68,199 /, TEMP/5701,57,27/, TEMPD/5641,65,98/
      DATA    CASECC, CASECA,GEOM3A /101,201,202/
C
C     ALG WILL USE OPEN CORE AT IZ
C     ALLOCATE OPEN CORE
C
      NZ    = KORSZ(IZ)
      IBUF1 = NZ - SYSBUF
      IBUF2 = IBUF1 - SYSBUF - 1
      LAST  = IBUF2 - 1
C
C     CHECK FOR SUFFICIENT CORE
C
      IF (LAST .LE. 0) CALL MESAGE (-8,0,NAME)
      LEFT   = CORWDS(IZ(1),IZ(LAST))
      KAPERR = 0
      KATERR = 0
      IFAIL  = 1
C
C     OPEN GEOM3A FOR OUTPUT OF PLOAD2 AND TEMP DATA
C
      CALL GOPEN (GEOM3A,IZ(IBUF1),WRTREW)
C
C     AERODYNAMIC PRESSURE SECTION
C
      IF (APRESS .LT. 0) GO TO 20
      IFILE = SCR1
      CALL OPEN (*901,SCR1,IZ(IBUF2),RDREW)
    8 CALL READ (*11,*10,SCR1,LREC,5,1,NWAR)
   10 IF (LREC(1) .EQ. LABP) GO TO 12
      GO TO 8
C
C     NO PLOAD2 CARDS ON SCR1 FILE
C
   11 KAPERR = 1
      IDP    = 0
      CALL REWIND (SCR1)
      WRITE (NOUT,2001) UWM
      GO TO 20
   12 CONTINUE
C
C     CREATE PLOAD2 RECORD
C
      CALL WRITE (GEOM3A,PLOAD2,3,0)
      IDP = LREC(3)
      GO TO 16
   14 CALL READ (*18,*15,SCR1,LREC,5,1,NWAR)
   15 IF (LREC(1) .NE. LABP) GO TO 18
   16 CALL WRITE (GEOM3A,LREC(3),3,0)
      GO TO 14
   18 CALL WRITE (GEOM3A,IZ,0,1)
      CALL REWIND (SCR1)
C
C     AERODYNAMIC TEMPERATURE SECTION
C
   20 IF (ATEMP .LT. 0) GO TO 35
      IF (APRESS .LT. 0) CALL OPEN (*901,SCR1,IZ(IBUF2),RDREW)
   21 CALL READ (*23,*22,SCR1,LREC,5,1,NWAR)
   22 IF (LREC(1) .EQ. LABT) GO TO 24
      GO TO 21
C
C     NO TEMP CARDS ON SCR1 FILE
C
   23 KATERR = 1
      IDT = 0
      WRITE (NOUT,2002) UWM
      GO TO 35
   24 CONTINUE
C
C     CREATE TEMP RECORD
C
      CALL WRITE (GEOM3A,TEMP,3,0)
      IDT   = LREC(3)
      DTEMP = RREC(5)
      ITPD  = 1
      GO TO 28
   26 CALL READ (*30,*27,SCR1,LREC,5,1,NWAR)
   27 IF (LREC(1) .NE. LABT) GO TO 30
   28 CALL WRITE (GEOM3A,LREC(3),3,0)
      ITPD = ITPD + 1
      IF (ITPD .LE. 3) DTEMP = DTEMP + RREC(5)
      GO TO 26
   30 CALL WRITE (GEOM3A,IZ,0,1)
C
C     CREATE TEMPD RECORD. AVERAGE FIRST THREE TEMPS. ON BLADE ROOT.
C
      CALL WRITE (GEOM3A,TEMPD,3,0)
      CALL WRITE (GEOM3A,IDT,1,0)
      DTEMP = DTEMP/3.0
      CALL WRITE (GEOM3A,DTEMP,1,1)
C
C     CLOSE GEOM3A
C
   35 CALL WRITE (GEOM3A,LEND,3,1)
      CALL CLOSE (GEOM3A,1)
      ITRL(1) = GEOM3A
      ITRL(2) = 0
      ITRL(3) = 0
      ITRL(4) = 0
      ITRL(5) = 0
      ITRL(6) = 0
      ITRL(7) = 0
      IF (APRESS.LT.0 .OR. KAPERR.EQ.1) GO TO 40
      IBIT = 68
      I1 = (IBIT-1)/16 + 2
      I2 = IBIT - (I1-2)*16 + 16
      ITRL(I1) = ORF(ITRL(I1),TWO(I2))
   40 IF (ATEMP.LT.0 .OR. KATERR.EQ.1) GO TO 50
      IBIT = 57
      I1 = (IBIT-1)/16 + 2
      I2 = IBIT - (I1-2)*16 + 16
      ITRL(I1) = ORF(ITRL(I1),TWO(I2))
      IBIT = 65
      I1 = (IBIT-1)/16 + 2
      I2 = IBIT - (I1-2)*16 + 16
      ITRL(I1) = ORF(ITRL(I1),TWO(I2))
   50 CALL WRTTRL (ITRL)
C
C     CLOSE SCR1
C
      IF (APRESS.GE.0 .OR. ATEMP.GE.0) CALL CLOSE (SCR1,1)
      IF (KAPERR .EQ. 1) APRESS = -1
      IF (KATERR .EQ. 1) ATEMP  = -1
C
C     SET IFAIL TO INDICATE ALG MODULE FAILED. CONDITIONAL JUMP BASED
C     ON VALUE OF IFAIL IS PERFORMED AFTER EXITING FROM ALG MODULE.
C
      IF (APRESS.EQ.-1 .AND. ATEMP.EQ.-1) IFAIL = -1
C
C     NEW CASE CONTROL DATA BLOCK
C     OPEN CASECC AND COPY ALL SUBCASES WITH CHANGES MADE TO
C     STATIC AND THERMAL LOAD ID-S
C
      IFILE = CASECC
      CALL OPEN (*901,CASECC,IZ(IBUF1),RDREW)
      CALL FWDREC (*902,CASECC)
      CALL GOPEN (CASECA,IZ(IBUF2),WRTREW)
   60 CALL READ (*70,*65,CASECC,IZ,LEFT,1,NWDS)
   65 IZX = 4
      IZ(IZX) = IDP
      IZX = 7
      IZ(IZX) = IDT
      CALL WRITE (CASECA,IZ,NWDS,1)
      GO TO 60
   70 CALL CLOSE (CASECC,1)
      CALL CLOSE (CASECA,1)
      ITRL(1) = CASECC
      CALL RDTRL (ITRL)
      ITRL(1) = CASECA
      CALL WRTTRL (ITRL)
      GO TO 999
  901 CALL MESAGE (-1,IFILE,NAME)
      GO TO 999
  902 CALL MESAGE (-2,IFILE,NAME)
      GO TO 999
  999 RETURN
C
 2001 FORMAT (A25,' - ALG MODULE - AERODYNAMIC PRESSURES REQUESTED VIA',
     1       ' PARAM APRESS, BUT NOUT3=0 IN AERODYNAMIC INPUT', /41X,
     2       'OR AERODYNAMIC CALCULATION FAILED. REQUEST IGNORED.')
 2002 FORMAT (A25,' - ALG MODULE - AERODYNAMIC TEMPERATURES REQUESTED ',
     1       'VIA PARAM ATEMP, BUT NOUT3=0 IN AERODYNAMIC INPUT' ,/41X,
     2       'OR AERODYNAMIC CALCULATION FAILED. REQUEST IGNORED.')
      END
