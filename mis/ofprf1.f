      SUBROUTINE OFPRF1(IX,L1,L2,L3,L4,L5,POINT)
C*****
C  SETS HEADER LINE FORMATS FOR REAL FORCES SORT1
C*****
      INTEGER C, POINT
      COMMON/OFPB5/ C(10)
      IX = C(POINT)
      L1 = C(POINT+1)
      L2 = C(POINT+2)
      L3 = C(POINT+3)
      L4 = C(POINT+4)
      L5 = C(POINT+5)
      RETURN
      END
