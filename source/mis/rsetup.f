      SUBROUTINE RSETUP (LVL,LVLS1,LVLS2,NACUM,IDIM)
C
C     THIS ROUTINE IS USED ONLY IN BANDIT MODULE
C
C     SETUP COMPUTES THE REVERSE LEVELING INFO FROM LVLS2 AND STORES
C     IT INTO LVLS2.  NACUM(I) IS INITIALIZED TO NODES/ITH LEVEL FOR
C     NODES ON THE PSEUDO-DIAMETER OF THE GRAPH.  LVL IS INITIALIZED TO
C     NON-ZERO FOR NODES ON THE PSEUDO-DIAM AND NODES IN A DIFFERENT
C     COMPONENT OF THE GRAPH.
C
      DIMENSION        NACUM(1), LVL(1),   LVLS1(1), LVLS2(1)
      COMMON /BANDB /  DUM3B(3), NGRID
      COMMON /BANDG /  N,        IDPTH
C
C     IDIM=NUMBER OF LEVELS IN A GIVEN COMPONENT.
C     NACUM IS DIMENSIONED TO IDIM IN SIZE
C
C     DIMENSION EXCEEDED  . . .  STOP JOB.
C
      IF (IDPTH.LE.IDIM)  GO TO 20
      NGRID=-3
      RETURN
C
   20 DO 30 I=1,IDPTH
   30 NACUM(I)=0
      DO 140 I=1,N
      LVL(I)=1
      LVLS2(I)=IDPTH+1-LVLS2(I)
      ITEMP=LVLS2(I)
      IF (ITEMP.GT.IDPTH) GO TO 140
      IF (ITEMP.NE.LVLS1(I)) GO TO 100
      NACUM(ITEMP)=NACUM(ITEMP)+1
      GO TO 140
  100 LVL(I)=0
  140 CONTINUE
      RETURN
      END
