      SUBROUTINE DESVEL
C
C     DESVAL COMPUTES DESIGN VELOCITY AND ACCELERATION SPECTRA FOR
C     DDAM. THE ASSUMUED FORM FOR VELOCITY IS
C
C                            VELB + W
C        VEL = VELI * VELA * --------
C                            VELC + W
C
C     WHERE VELI IS VEL1,VEL2,OR VEL3 FOR TH 1,2,3, DIRECTIONS
C         W IS THE EFFECTIVE WEIGHT = MATRIX EFFW/1000.
C         VEL,VELA ARE IN LENGTH/SECOND
C     MATRIX SSDV WILL BE OUTPUT
C     DESIGN ACCELERATIONS HAVE THE SAME FORM AS VELOCITY EXCEPT FOR
C     ONE CASE WHERE
C         ACC = ACCI*ACCA*(ACCB+W)*(ACCC+W)/(ACCD+W)**2
C
C     WHERE ACC IS IN G-S AND W IS AS ABOVE
C     IF ACCD IA ZERO, ACC HAS THE SAME FORM AS VEL
C     MATRICES ACC AND VEL*OMEGA/G WILL BE OUTPUT FOR COMPARISON
C     PURPOSES
C     IN ADDITION, DATA BLOCK MINAC WILL CONTAIN THE MINIMUM
C     OF ACCE*GG VS. VEL*OMEGA FOR USE IN COMPUTING STATIC LOADS
C *** ALL VELOCITY PARAMETERS MUST BE PUT ON PARAM BULK DATA CARDS,
C                             ----
C     I.E.,VEL1,VEL2,VEL3,VELA,VELB,VELC. ACCELERATION PARAMETERS ARE
C     DEFAULTED TO ZERO AND NEED NOT BE ON PARAM CARDS IF NOT WANTED.
C
C     DESVEL   EFFW,OMEGA / SSDV,ACC,VWG,MINAC,MINOW2 / C,Y,GG=386.4/
C              C,Y,VEL1/C,Y,VEL2/C,Y,VEL3/C,Y,VELA/C,Y,VELB/C,Y,VELC/
C              C,Y,ACC1=0./C,Y,ACC2=0./C,Y,ACC3=0./C,Y,ACCA=0./
C              C,Y,ACCB=0./C,Y,ACCC=0./C,Y,ACCD=0.
C
      LOGICAL         ZERO
      INTEGER         BUF1,BUF2,BUF3,EFFW,OMEGA,SSDV,ACC,VWG,SYSBUF,
     1                BUF4,MCB4(7),BUF5,MCB5(7)
      DIMENSION       NAM(2),MCB1(7),MCB2(7),MCB3(7),IZ(1)
      CHARACTER       UFM*23,UWM*25,UIM*29
      COMMON /XMSSG / UFM,UWM,UIM
      COMMON /UNPAKX/ JOUT,III,NNN,JNCR
      COMMON /PACKX / IIN,IOUT,II,NN,INCR
      COMMON /SYSTEM/ SYSBUF,IPRINT
      COMMON /BLANK / GG,VEL1,VEL2,VEL3,VELA,VELB,VELC,ACC1,ACC2,ACC3,
     1                ACCA,ACCB,ACCC,ACCD
      COMMON /ZZZZZZ/ Z(1)
      EQUIVALENCE     (Z(1),IZ(1))
      DATA    EFFW  , OMEGA,SSDV,ACC,VWG,MINAC,MINOW2 /
     1        101   , 102  ,201 ,202,203,204  ,205    /
      DATA    NAM   / 4HDESV,4HEL  /
C
      ZERO  = .FALSE.
      LCORE = KORSZ(Z)
      BUF1  = LCORE - SYSBUF + 1
      BUF2  = BUF1 - SYSBUF
      BUF3  = BUF2 - SYSBUF
      BUF4  = BUF3 - SYSBUF
      BUF5  = BUF4 - SYSBUF
      LCORE = BUF5 - 1
      IF (LCORE .LE. 0) CALL MESAGE (-8,0,NAM)
C
      JOUT = 1
      IIN  = 1
      IOUT = 1
      INCR = 1
      JNCR = 1
      II   = 1
      III  = 1
C
C     UNPACK AND STORE EFFW AND OMEGA
C
      MCB1(1) = EFFW
      CALL RDTRL (MCB1)
      NCOL = MCB1(2)
      NROW = MCB1(3)
      NNN  = NROW
      NN   = NNN
      NTOT = NCOL*NROW
      NALL = NTOT+NNN
C
      IF (LCORE .LT. (NCOL+6)*NNN) CALL MESAGE (-8,0,NAM)
      CALL GOPEN (EFFW,Z(BUF1),0)
      DO 20 I = 1,NCOL
      JJ = (I-1)*NNN
      CALL UNPACK (*10,EFFW,Z(JJ+1))
      GO TO 20
   10 DO 15 J = 1,NNN
   15 Z(JJ+J) = 0.
C
   20 CONTINUE
      CALL CLOSE (EFFW,1)
      CALL GOPEN (OMEGA,Z(BUF1),0)
      CALL UNPACK (*30,OMEGA,Z(NTOT+1))
      GO TO 50
   30 DO 40 I = 1,NNN
   40 Z(NTOT+I) = 0.
C
   50 CALL CLOSE (OMEGA,1)
      NMODES = NROW
      NDIR   = NCOL
C
      CALL GOPEN (SSDV,Z(BUF1),1)
      CALL GOPEN (ACC,Z(BUF2),1)
      CALL GOPEN (VWG,Z(BUF3),1)
      CALL GOPEN (MINAC,Z(BUF4),1)
      CALL GOPEN (MINOW2,Z(BUF5),1)
C
      MCB1(1) = SSDV
      MCB1(2) = 0
      MCB1(3) = NROW
      MCB1(4) = 2
      MCB1(5) = 1
      MCB1(6) = 0
      MCB1(7) = 0
      MCB2(1) = ACC
      MCB2(2) = 0
      MCB2(3) = NROW
      MCB2(4) = 2
      MCB2(5) = 1
      MCB2(6) = 0
      MCB2(7) = 0
      MCB3(1) = VWG
      MCB3(2) = 0
      MCB3(3) = NROW
      MCB3(4) = 2
      MCB3(5) = 1
      MCB3(6) = 0
      MCB3(7) = 0
      MCB4(1) = MINAC
      MCB4(2) = 0
      MCB4(3) = NROW
      MCB4(4) = 2
      MCB4(5) = 1
      MCB4(6) = 0
      MCB4(7) = 0
      MCB5(1) = MINOW2
      MCB5(2) = 0
      MCB5(3) = NROW
      MCB5(4) = 2
      MCB5(5) = 1
      MCB5(6) = 0
      MCB5(7) = 0
C
      DO 130 I = 1,NDIR
      IPT = (I-1)*NNN
      DO 120 J = 1,NMODES
C
C     EFFECTIVE WEIGHT FOR JTH MODE IN ITH DIRECTION (IN 1000-S)
C
      EFWT = Z(IPT+J)/1000.
      GO TO (60,70,80), I
   60 VELI = VEL1
      ACCI = ACC1
      GO TO 90
   70 VELI = VEL2
      ACCI = ACC2
      GO TO 90
   80 VELI = VEL3
      ACCI = ACC3
C
   90 VEL = VELI*VELA*(VELB+EFWT)/(VELC+EFWT)
      IF (ACCD .NE. 0.) GO TO 100
      ACCE = ACCI*ACCA*(ACCB+EFWT)/(ACCC+EFWT)
      GO TO 110
C
  100 ACCE = ACCI*ACCA*(ACCB+EFWT)*(ACCC+EFWT)/(ACCD+EFWT)**2
C
  110 OMEG = Z(NTOT+J)
      VWOG = VEL*OMEG/GG
C
C     VELOCITIES FOR ITH DIRECTION ARE IN Z(NALL+1)-Z(NALL+NNN)
C     ACCELERATIONS ARE IN NEXT NNN LOCATIONS, VWOG IN 3RD NNN
C     MAXIMUM OF VEL*OMEG OR ACCE*GG IS IN 4TH NNN
C
      Z(NALL      +J) = VEL
      Z(NALL+ NNN +J) = ACCE
      Z(NALL+2*NNN+J) = VWOG
      Z(NALL+3*NNN+J) = GG*AMIN1(ACCE,VWOG)
      IF (ABS(OMEG) .LT. 0.01) GO TO 125
      Z(NALL+4*NNN+J) = Z(NALL+3*NNN+J)/OMEG**2
      GO TO 120
C
C     IN DDAM, THERE SHOULD BE NO RIGID BODY MODES.ZERO THE RESPONSE.
C
  125 Z(NALL+4*NNN+J) = 0.
      ZERO = .TRUE.
C
C     GET ANOTHER MODE FOR THIS DIRECTION
C
  120 CONTINUE
C
C     PACK RESULTS FOR THIS DIRECTION
C
      CALL PACK (Z(NALL      +1),SSDV,MCB1)
      CALL PACK (Z(NALL+NNN  +1),ACC,MCB2)
      CALL PACK (Z(NALL+2*NNN+1),VWG,MCB3)
      CALL PACK (Z(NALL+3*NNN+1),MINAC,MCB4)
      CALL PACK (Z(NALL+4*NNN+1),MINOW2,MCB5)
C
C     GET ANOTHER DIRECTION
C
  130 CONTINUE
C
C     DONE
C
      CALL CLOSE  (SSDV,1)
      CALL CLOSE  (ACC,1)
      CALL CLOSE  (VWG,1)
      CALL CLOSE  (MINAC,1)
      CALL CLOSE  (MINOW2,1)
      CALL WRTTRL (MCB1)
      CALL WRTTRL (MCB2)
      CALL WRTTRL (MCB3)
      CALL WRTTRL (MCB4)
      CALL WRTTRL (MCB5)
C
      IF (.NOT.ZERO) RETURN
      WRITE  (IPRINT,135) UIM
  135 FORMAT (A29,', CIRCULAR FREQUENCY LESS THAN .01 IS ENCOUNTERED ',
     1       'IN DDAM.', /5X,'MAXIMUM RESPONSE FOR THAT MODE IS SET TO',
     2       ' ZERO. DDAM SHOULD HAVE NO RIGID BODY MODES.')
      RETURN
      END
