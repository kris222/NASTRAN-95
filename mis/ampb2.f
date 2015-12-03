      SUBROUTINE AMPB2(A,A11,A12,A21,A22,RP,CP,N1,N2)
C
C     THIS SUBROUTINE IS A GENERAL DRIVER FOR PARTN
C
      INTEGER A11,A12,A21,A22,A,RP,CP,RULE,MCB(20),MCB1(20)
C
      COMMON /PARMEG/MCBA(7),MCBA11(7),MCBA21(7),MCBA12(7),MCBA22(7),
     1 NX,RULE
      COMMON /ZZZZZZ/ IZ(1)
C
C-----------------------------------------------------------------------
C
      MCB(1)=RP
      CALL RDTRL(MCB)
      MCB1(1)=CP
      CALL RDTRL(MCB1)
      NX=KORSZ(IZ)
      RULE=0
      MCBA11(1)=A11
      IF(A11.EQ.0)GO TO 10
      CALL RDTRL(MCBA11)
      IF(MCBA11(1).LE.0)MCBA11(1)=0
   10 CONTINUE
      MCBA21(1)=A21
      IF(A21.LE.0)GO TO 20
      CALL RDTRL(MCBA21)
      IF(MCBA21(1).LE.0)MCBA21(1)=0
   20 CONTINUE
      MCBA12(1)=A12
      IF(A12.EQ.0)GO TO 30
      CALL RDTRL(MCBA12)
      IF(MCBA12(1).LE.0)MCBA12(1)=0
   30 CONTINUE
      MCBA22(1)=A22
      IF(A22.EQ.0)GO TO 40
      CALL RDTRL(MCBA22)
      IF(MCBA22(1).LE.0)MCBA22(1)=0
   40 CONTINUE
      MCBA(1)=A
      CALL RDTRL(MCBA)
      MCBA11(2) = MCBA(2) - MCB(6)
      MCBA11(3) = MCBA(3) -MCB1(6)
      MCBA12(2) = MCBA(2) -MCBA11(2)
      MCBA12(3) = MCBA11(3)
      MCBA21(2) = MCBA11(2)
      MCBA21(3) = MCBA(3) -MCBA11(3)
      MCBA22(2) = MCB(6)
      MCBA22(3) = MCB1(6)
      MCBA11(4)=2
      MCBA21(4)=2
      MCBA12(4)=2
      MCBA22(4)=2
      MCBA11(5)=MCBA(5)
      MCBA21(5)=MCBA(5)
      MCBA12(5)=MCBA(5)
      MCBA22(5)=MCBA(5)
      CALL PARTN(MCB,MCB1,IZ)
      IF(MCBA11(1).GT.0)CALL WRTTRL(MCBA11)
      IF(MCBA21(1).GT.0)CALL WRTTRL(MCBA21)
      IF(MCBA12(1).GT.0)CALL WRTTRL(MCBA12)
      IF(MCBA22(1).GT.0)CALL WRTTRL(MCBA22)
      RETURN
      END
