      SUBROUTINE FVRS1D (BASE,BASE1,INDEX,NFX)
C
      COMPLEX BASE(3,NFX),BASE1(3,NFX)
C
      DIMENSION INDEX(NFX)
C
      DO 100 I=1,NFX
      LOC =INDEX(I)
      DO 10 L=1,3
  10  BASE1(L,I)=BASE(L,LOC)
 100  CONTINUE
C
C-----RETURN BASE1 TO BASE
C
      DO 200 I=1,NFX
      DO 110 L=1,3
 110  BASE(L,I)=BASE1(L,I)
 200  CONTINUE
      RETURN
      END
