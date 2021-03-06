      SUBROUTINE TERMSD (NNODE,GPTH,EPNORM,EGPDT,IORDER,MMN,BTERMS)
C
C     DOUBLE PRECISION ROUTINE TO CALCULATE B-MATRIX TERMS
C     FOR ELEMENTS  QUAD4, QUAD8 AND TRIA6.
C
C     THE INPUT FLAG LETS THE SUBROUTINE SWITCH BETWEEN QUAD4,
C     QUAD8 AND TRIA6 VERSIONS
C
C     ELEMENT TYPE FLAG (LTYPFL) = 1  FOR QUAD4,
C                                = 2  FOR TRIA6 (NOT AVAILABLE),
C                                = 3  FOR QUAD8 (NOT AVAILABLE).
C
C     THE OUTPUT CONSISTS OF THE DETERMINANT OF THE JACOBIAN
C     (DETJ), SHAPE FUNCTIONS AND THEIR DERIVATIVES. THE OUTPUT
C     PARAMETER, BADJAC, IS AN INTERNAL LOGICAL FLAG TO THE CALLING
C     ROUTINE INDICATING THAT THE JACOBIAN IS NOT CORRECT.
C     PART OF THE INPUT IS PASSED TO THIS SUBROUTINE THROUGH THE
C     INTERNAL COMMON BLOCK  /COMJAC/.
C
      LOGICAL          BADJAC
      INTEGER          MMN(1),LTYPFL,IORDER(1),INDEX(3,3)
      REAL             EGPDT(4,1),EPNORM(4,1)
      DOUBLE PRECISION XI,ETA,ZETA,DETJ,SHP(8),JACOB(3,3),DSHPX(8),
     1                 DSHPE(8),DSHP(16),TSHP(8),TDSHP(16),BTERMS(1),
     2                 DUM,TEMP,EPS,TIE(9),TJ(3,3),VN(3),CJAC,GPTH(1),
     3                 TH,GRIDC(3,8)
      COMMON /COMJAC/  XI,ETA,ZETA,DETJ,BADJAC,LTYPFL
      COMMON /CJACOB/  CJAC(19)
      EQUIVALENCE      (DSHPX(1),DSHP(1)), (DSHPE(1),DSHP(9) )
      EQUIVALENCE      (VN(1)   ,CJAC(8)), (TIE(1)  ,CJAC(11))
      EQUIVALENCE      (TH      ,CJAC(1))
C
      EPS = 1.0D-15
      BADJAC = .FALSE.
C
      GO TO (10,30,20), LTYPFL
C
C     QUAD4 VERSION
C
   10 NGP = 4
      CALL Q4SHPD (XI,ETA,SHP,DSHP)
      GO TO 40
C
C     QUAD8 VERSION
C
   20 NGP = 8
      GO TO 40
C
C     TRIA6 VERSION
C
   30 NGP = 6
C
   40 DO 50 I = 1,NGP
      TSHP (I  ) = SHP(I)
      TDSHP(I  ) = DSHP(I)
   50 TDSHP(I+8) = DSHP(I+NGP)
      DO 60 I = 1,NGP
      IO = IORDER(I)
      SHP (I  ) = TSHP(IO)
      DSHP(I  ) = TDSHP(IO)
   60 DSHP(I+8) = TDSHP(IO+8)
C
      TH = 0.0D0
      DO 70 I = 1,NNODE
      TH = TH + GPTH(I)*SHP(I)
      DO 70 J = 1,3
      J1 = J + 1
      GRIDC(J,I) = EGPDT(J1,I) + ZETA*GPTH(I)*EPNORM(J1,I)*0.5D0
   70 CONTINUE
C
      DO 80 I = 1,2
      II = (I-1)*8
      DO 80 J = 1,3
      TJ(I,J) = 0.0D0
      DO 80 K = 1,NNODE
      TJ(I,J) = TJ(I,J) + DSHP(K+II)*GRIDC(J,K)
   80 CONTINUE
C
      DO 90 I = 1,3
      TJ(3,I) = 0.0D0
      DO 90 J = 1,NNODE
   90 TJ(3,I) = TJ(3,I) + 0.5D0*GPTH(J)*SHP(J)*EPNORM(I+1,J)
C
      DO 100 I = 1,3
      DO 100 J = 1,3
      IF (DABS(TJ(I,J)) .LT. EPS) TJ(I,J) = 0.0D0
  100 CONTINUE
C
C     SET UP THE TRANSFORMATION FROM THIS INTEGRATION POINT C.S.
C     TO THE ELEMENT C.S.  TIE
C
      VN(1) = TJ(1,2)*TJ(2,3) - TJ(2,2)*TJ(1,3)
      VN(2) = TJ(2,1)*TJ(1,3) - TJ(1,1)*TJ(2,3)
      VN(3) = TJ(1,1)*TJ(2,2) - TJ(2,1)*TJ(1,2)
C
      TEMP = DSQRT(VN(1)*VN(1) + VN(2)*VN(2) + VN(3)*VN(3))
C
      TIE(7) = VN(1)/TEMP
      TIE(8) = VN(2)/TEMP
      TIE(9) = VN(3)/TEMP
C
      TEMP = DSQRT(TIE(8)*TIE(8) + TIE(9)*TIE(9))
C
      TIE(1) = TIE(9)/TEMP
      TIE(2) = 0.0D0
      TIE(3) =-TIE(7)/TEMP
C
      TIE(4) = TIE(8)*TIE(3)
      TIE(5) = TEMP
      TIE(6) =-TIE(1)*TIE(8)
C
      CALL INVERD (3,TJ,3,DUM,0,DETJ,ISING,INDEX)
C
C
C     NOTE - THE INVERSE OF JACOBIAN HAS BEEN STORED IN TJ
C            UPON RETURN FROM INVERD.
C
      IF (ISING.EQ.1 .AND. DETJ.GT.0.0D0) GO TO 110
      BADJAC = .TRUE.
      GO TO 150
C
  110 CONTINUE
C
      DO 120 I = 1,3
      II = (I-1)*3
      DO 120 J = 1,3
      JACOB(I,J) = 0.0D0
      DO 120 K = 1,3
      IK = II + K
  120 JACOB(I,J) = JACOB(I,J) + TIE(IK)*TJ(K,J)
C
C     MULTIPLY THE INVERSE OF THE JACOBIAN BY THE TRANSPOSE
C     OF THE ARRAY CONTAINING DERIVATIVES OF THE SHAPE FUNCTIONS
C     TO GET THE TERMS USED IN THE ASSEMBLY OF THE B MATRIX.
C     NOTE THAT THE LAST ROW CONTAINS THE SHAPE FUNCTION VALUES.
C
      NODE3 = NNODE*3
      DO 130 I = 1,NNODE
  130 BTERMS(NODE3+I) = SHP(I)*JACOB(3,3)
C
      DO 140 I = 1,3
      II = (I-1)*NNODE
      DO 140 J = 1,NNODE
      IJ = II + J
      BTERMS(IJ) = 0.0D0
      DO 140 K = 1,2
      IK = (K-1)*8
  140 BTERMS(IJ) = BTERMS(IJ) + JACOB(I,K)*DSHP(IK+J)
  150 RETURN
      END
