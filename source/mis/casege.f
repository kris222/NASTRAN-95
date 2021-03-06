      SUBROUTINE CASEGE
C
C GENERATES IDENTICAL SUBCASES LMODES*NDIR TIMES FOR DDAM
C
C     CASEGEN  CASECC/CASEDD/C,Y,LMODES/V,N,NDIR/V,N,NMODES $
C    EQUIV CASEDD,CASECC  $
C
      INTEGER BUF1,BUF2,SYSBUF,CASECC,CASEDD
      DIMENSION IZ(1),NAM(2),MCB(7)
      COMMON/SYSTEM/SYSBUF
      COMMON/BLANK/LMODES,NDIR,NMODES
      COMMON/ZZZZZZ/Z(1)
      EQUIVALENCE (Z(1),IZ(1))
      DATA CASECC,CASEDD/101,201/
      DATA NAM/4HCASE,4HGE  /
C
      LCORE=KORSZ(Z)
      BUF1=LCORE-SYSBUF+1
      BUF2=BUF1-SYSBUF
      LCORE=BUF2-1
      IF(LCORE.LE.0)GO TO 1008
C
      CALL GOPEN(CASECC,Z(BUF1),0)
      CALL GOPEN(CASEDD,Z(BUF2),1)
      CALL READ (*1002,*10,CASECC,Z,LCORE,0,IWORDS)
      GO TO 1008
   10 IF(LMODES.GT.NMODES)LMODES=NMODES
      ITOT=LMODES*NDIR
      DO 20 I=1,ITOT
      IZ(1)=I
      CALL WRITE(CASEDD,Z,IWORDS,1)
   20 CONTINUE
      CALL CLOSE(CASECC,1)
      CALL CLOSE(CASEDD,1)
      MCB(1)=CASECC
      CALL RDTRL(MCB)
      MCB(1)=CASEDD
      MCB(2)=ITOT
      CALL WRTTRL(MCB)
      RETURN
C
 1002 CALL MESAGE(-2,CASECC,NAM)
 1008 CALL MESAGE(-8,0,NAM)
      RETURN
      END
