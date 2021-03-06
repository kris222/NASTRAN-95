      SUBROUTINE ADR
C
C     AERODYNAMIC DATA RECOVERY   -  FORCE OUTPUT BY SET SELECTION
C
C     DMAP
C     FLUTTER
C     ADR  CPHIH1,CASEZZ,QKHL,CLAMAL1,SPLINE,SILA,USETA/PKF/C,N,BOV/C,
C          N,MACH=0.0/C,N,APP $
C     DYNAMICS
C     ADR  UHVT1,CASECC,QKHL,TOL1,SPLINE,SILA,USETA/PKF/V,N,BOV/C,Y,
C          MACH=0.0/C,N,APP $
C
      INTEGER         SYSBUF,OUT,CASECC,DISP,QKHL,LOAD,SPLINE,SILA,
     1                USETA,IZ(1),PKF,APP,FLUT,FREQ,SCR1,SCR2,SCR3,SCR4,
     2                MCB(7)
      REAL            MACH
      CHARACTER       UFM*23,UWM*25,UIM*29
      COMMON /XMSSG / UFM,UWM,UIM
      COMMON /BLANK / BOV,MACH,APP
      COMMON /SYSTEM/ SYSBUF,OUT
      COMMON /CONDAS/ PI,TWOPI
      COMMON /UNPAKX/ IOUT,INN,NNN,INCR1
      COMMON /PACKX / ITI,ITO,II,NN,INCR
      COMMON /ZZZZZZ/ Z(1)
      EQUIVALENCE     (Z(1),IZ(1))
      DATA    IAERO / 176/
      DATA    FLUT  / 4HFLUT/, FREQ /4HFREQ/
      DATA    DISP  / 101/ , CASECC /102/ , QKHL /103/ , LOAD /104/
      DATA    SPLINE/ 105/ , SILA   /106/ , USETA/107/ , PKF  /201/
      DATA    SCR1  / 301/ , SCR2   /302/ , SCR3 /303/ , SCR4 /304/
C
C
C     BUILD    P    =  Q    *  U
C               KF      KH      H
C     WHERE  QKH INTERPOLATED FOR A EIGENVALUE OR FREQUENCY - MACH DEP.
C            UH  - EIGENVALUE OR FREQUENCY
C
C
C     INITIALIZE  - LOOK FOR A REQUEST
C
      IF (APP.EQ.FLUT .OR. APP.EQ.FREQ) GO TO 5
      GO TO 1000
    5 NCORE  = KORSZ(Z)
      IBUF1  = NCORE - SYSBUF
      CALL OPEN (*1000,CASECC,IZ(IBUF1),0)
      CALL FWDREC (*1000,CASECC)
      CALL READ (*1000,*10,CASECC,Z,IBUF1,0,NW)
   10 IF (IZ(IAERO) .EQ. 0) GO TO 1000
      CALL CLOSE (CASECC,1)
C
C     BUILD INTERPOLATED MATRIX FROM QHKL ON SCR1
C     DEPENDENT LIST
C     IF CLAMAL1 PICK UP FREQUENCY FROM OFP TABLE
C     IF TOL1    PICK UP FREQUENCY FROM HEADER
C     INDEPENDENT LIST ON QKHL
C
      CALL OPEN (*1000,LOAD,IZ(IBUF1),0)
      IF (APP .EQ. FLUT) GO TO 30
C
C     TOL1 = LOAD
C
      MCB(1) = CASECC
      CALL RDTRL (MCB)
      CALL READ (*1000,*1000,LOAD,IZ,-2,0,NFREQ)
      CALL READ (*1000,*20,LOAD,IZ,IBUF1,0,NFREQ)
      GO TO 999
   20 NLOAD = MCB(2)
      GO TO 60
C
C     CLAMAL1 = LOAD
C
   30 CALL FWDREC (*1000,LOAD)
      CALL FWDREC (*1000,LOAD)
      CALL READ (*1000,*40,LOAD,IZ,IBUF1,0,NFREQ)
      GO TO 999
   40 NFREQ = NFREQ/6
      IF(BOV .EQ. 0.0) GO TO 997
      DO 50 I = 1,NFREQ
      K     =  I*6 - 1
      Z(I)  = Z(K)/(TWOPI*BOV)
   50 CONTINUE
      NLOAD = 1
C
C     CALL ADRI TO BUILD  (AFTER ADRI FREQUENCY*2PI*BOV IS IN Z AT EVERY
C     OTHER SLOT 0.0 ,W FOR NFREQ*2
C
   60 CALL CLOSE (LOAD,1)
      CALL ADRI (Z,NFREQ,NCORE,QKHL,SCR1,SCR2,SCR3,SCR4,NROW,NCOL,NOGO)
      IF (NOGO .NE. 0) GO TO 1000
C
C     SCR1 NOW HAS QKH INTERPOLATED    NROW*NCOL(ROW5)  NFREQ(COLUMNS)
C
      IPQ   = NFREQ*2 + 1
C
C     BUILD PKF
C
      IOUT  = 3
      ITI   = 3
      ITO   = 3
      INCR  = 1
      INCR1 = 1
      MCB(1)= DISP
      CALL RDTRL (MCB)
      IF (MCB(1) .LT.    0) GO TO 1000
      IF (MCB(3) .NE. NCOL) GO TO 998
      NNS1  = NROW*NCOL
      II    = 1
      NN    = NROW
      INN   = 1
      IBUF2 = IBUF1 - SYSBUF
      CALL GOPEN (PKF,Z(IBUF2),1)
      IBUF3 = IBUF2 - SYSBUF
      CALL GOPEN (DISP,Z(IBUF3),0)
      CALL GOPEN (SCR1,Z(IBUF1),0)
      MCB(1) = PKF
      MCB(2) = 0
      MCB(3) = NN
      MCB(6) = 0
      MCB(7) = 0
      NTERMS = NNS1*2
      NTERMD = NCOL*2
      NTERMA = NROW*2
      IPD    = IPQ + NTERMS
      IPA    = IPD + NTERMD
      NEXT   = IPA + NTERMA
      IF (NEXT .GT. IBUF3) GO TO 999
      DO 150 I = 1,NLOAD
      DO 140 J = 1,NFREQ
C
C     UNPACK INTERPOLATED MATRIX COLUMN THEN DISP VECTOR  MULTIPLY AND
C     PACK OUT
C
      NNN = NNS1
      CALL UNPACK (*70,SCR1,Z(IPQ))
C
C     MULTIPLY BACK BY FREQUENCY (K)
C
      DO 71 L = 1,NTERMS,2
      M = J*2
      Z(IPQ+L) = Z(IPQ+L)*Z(M)
   71 CONTINUE
      GO TO 75
   70 CALL ZEROC (Z(IPQ),NTERMS)
   75 NNN = NCOL
      CALL UNPACK (*80,DISP,Z(IPD))
      GO TO 90
   80 CALL ZEROC (Z(IPD),NTERMD)
   90 CALL GMMATC (Z(IPD),1,NCOL,0,Z(IPQ),NCOL,NROW,0,Z(IPA))
      CALL PACK (Z(IPA),PKF,MCB)
  140 CONTINUE
      IF (I .EQ. NLOAD) GO TO 150
      CALL REWIND (SCR1)
      CALL SKPREC (SCR1,1)
  150 CONTINUE
      CALL CLOSE  (SCR1,1)
      CALL CLOSE  (DISP,1)
      CALL CLOSE  (PKF, 1)
      CALL WRTTRL (MCB)
      CALL DMPFIL (-PKF,Z(IPQ),IBUF3-IPQ)
C
C     PUT FREQUENCY BACK TO ORIGINAL VALUE
C
      DO 160 I = 1,NFREQ
      Z(I) = Z(I*2)/(TWOPI*BOV)
  160 CONTINUE
C
C     PRINT RESULTS
C
      CALL ADRPRT (CASECC,PKF,SPLINE,SILA,USETA,Z,NFREQ,NCORE,NLOAD)
C
C     STOP  CLOSE ALL POSSIBLE OPENS
C
 1000 CALL CLOSE (CASECC,1)
      CALL CLOSE (LOAD  ,1)
      CALL CLOSE (PKF   ,1)
      CALL CLOSE (DISP  ,1)
      RETURN
C
C     ERROR MESSAGES
C
  999 CALL MESAGE (8,0,NAM)
      GO TO 1000
  998 CALL MESAGE (7,0,NAM)
      GO TO 1000
  997 WRITE  (OUT,9970) UIM
 9970 FORMAT (A29,' 2272, NO FLUTTER CALCULATIONS CAN BE MADE IN ',
     1        'MODULE ADR SINCE BOV = 0.0.')
      GO TO 1000
      END
