      SUBROUTINE AMGT1D (AJJ,TSONX,TAMACH,TREDF,NSTNS2)
C
C     TRANSONIC INTERPOLATION CODE FOR SWEPT TURBOPROPS.
C
      INTEGER SLN
      INTEGER TSONX(1)
C
      COMPLEX AJJ(NSTNS2,1)
C
      DIMENSION TAMACH(1),TREDF(1)
C
      COMMON /TAMG1L/IREF,MINMAC,MAXMAC,NLINES,NSTNS,REFSTG,REFCRD,
     1               REFMAC,REFDEN,REFVEL,REFSWP,SLN,NSTNSX,STAG,
     2               CHORD,DCBDZB,BSPACE,MACH,DEN,VEL,SWEEP,AMACH,
     3               REDF,BLSPC,AMACHR,TSONIC
      COMMON /AMGMN /MCB(7),NROW,DUM(2),REFC,SIGMA,RFREQ
C
      NUMM = 2 * NSTNS2 * NSTNS2
      DO 100 NLINE = 1,NLINES
      IF(TSONX(NLINE).EQ. 0) GO TO 100
      NS = 0
      IF(NLINE .EQ. 1) GO TO 90
      IF(TAMACH(NLINE) .GE. 1.0) GO TO 20
C       SUBSONIC
      IF(NLINE . EQ.2) NLINE1=1
      IF(NLINE . EQ.2) GO TO 93
   17 NLINE1 = NLINE -2
      NLINE2 = NLINE -1
      GO TO 70
C        SUPERSONIC
   20 IF( NLINE .EQ. NLINES) GO TO 17
      NS =1
      GO TO 90
   30 IF(NLINE1 .EQ. 0) GO TO 17
      IF(NLINE2 .NE. 0) GO TO 70
      NLINE2 = NLINE1
      NLINE1 = NLINE-1
   70 CALL INTERT(NLINE,NLINE1,NLINE2,NUMM,AJJ,TAMACH)
      GO TO 100
C       SEARCH FOR 1ST--2--KNOWN STREAMLINES
   90 NLINE1 = 0
   93 NLINE2 = 0
      NNLINE = NLINE + 1
      DO 96  I=NNLINE,NLINES
      IF(NLINE2 .NE. 0)  GO TO 97
      IF(TSONX(I).NE. 0) GO TO 96
      IF(NLINE1 .EQ. 0)  NLINE1 = I
      IF(NLINE1 .NE. I)  NLINE2 = I
   96 CONTINUE
   97 IF(NS .EQ. 0) GO TO 70
      GO TO 30
  100 CONTINUE
      RETURN
      END
