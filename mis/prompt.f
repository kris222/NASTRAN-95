      SUBROUTINE PROMPT
C
C     DRIVER FOR  INTERACTIVE MODULE - PROMPT
C
C        PROMPT    //S,N,PEXIT/S,N,PLOT1/S,N,PLOT2/S,N,XYPLOT/
C                    S,N,SCAN1/S,N,SCAN2/DUM1/DUM2/DUM3/DUM4 $
C
      IMPLICIT INTEGER  (A-Z)
      COMMON /BLANK / PARAM(10)
      COMMON /SYSTEM/ KSYSM(100)
      EQUIVALENCE     (NOUT ,KSYSM(2)),  (SOLN ,KSYSM(22)),
     1                (IN   ,KSYSM(4)),  (INTRA,KSYSM(86))
      DATA    P,S,C,B / 1HP, 1HS, 1HC, 1H /
C
      INTRA=IABS(INTRA)
      NOUT = 6
      DO 10 I=1,10
 10   PARAM(I)=0
C
 20   WRITE (NOUT,110)
      READ (IN,130,ERR=20) J
      IF (J.LT.1 .OR. J.GT.6) GO TO 20
      IF (SOLN.EQ.3 .AND. (J.EQ.4 .OR. J.EQ.6)) GO TO 70
      PARAM(J)=-1
      IF (J .EQ. 1) RETURN
 40   WRITE (NOUT,120)
      I=B
      READ (IN,140,END=50) I
 50   IF (I .EQ. B) RETURN
      IF (I .EQ. C) GO TO 60
      IF (I.NE.P .AND. I.NE.S) GO TO 40
      IF (I .EQ. S) INTRA = MOD(INTRA,10)
      IF (I .EQ. P) INTRA = MOD(INTRA,10) + 10
      RETURN
C
 60   PARAM(J)=0
      GO TO 20
 70   WRITE (NOUT,80) J,SOLN
 80   FORMAT (/,' OPTION',I3,' IS NOT AVAILABLE FOR SOLUTION',I3)
      GO TO 20
C
 110  FORMAT (9X,'1. EXIT',
     1       /9X,'2. STRUCTURE PLOTS - UNDEFORMED',
     3       /9X,'3. STRUCTURE PLOTS - DEFORMED',
     4       /9X,'4. XYPLOTS',
     5       /9X,'5. SCAN OUTPUT - SORT1',
     6       /9X,'6. SCAN OUTPUT - SORT2',
     7       //9X,'SELECT ONE OPTION FROM MENU -')
 120  FORMAT (/9X,'OUTPUT TO SCREEN, OR TO PRINTFILE, OR CANCEL OPTION (
     1S/P/C) -')
 130  FORMAT (I1)
 140  FORMAT (A1)
      END
