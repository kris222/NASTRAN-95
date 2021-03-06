      SUBROUTINE RENAME (NAME1,NAME2,Z,NZ,ITEST)
C
C     THIS ROUTINE RENAMES SUBSTRUCTURE NAME1 TO NAME2. SOF ITEMS EQSS,
C     BGSS, CSTM, LODS, LOAP AND PLTS ARE REWRITTEN TO REFLECT THE NEW
C     NAME.  THESE ITEMS ARE CHANGED FOR NAME1 AND ANY HIGHER LEVEL
C     SUBSTRUCTURE FOR WHICH NAME1 IS A COMPONENT.  NO CHANGES ARE MADE
C     TO SECONDARY SUBSTRUCTURES OF NAME1 WHICH RETAIN THEIR ORIGINAL
C     NAMES.  ALSO NO CHANGES ARE MADE TO THE SOLUTION DATA (ITEM SOLN)
C     FOR SUBSTRUCTURE NAME1 OR ANY HIGHER LEVEL SUBSTRUCTURES.
C
C     VALUES RETURNED IN ITEST ARE
C        1 - NORMAL RETURN
C        4 - SUBSTRUCTURE NAME1 DOES NOT EXIST
C       10 - SUBSTRUCTURE NAME2 ALREADY EXISTS
C
      EXTERNAL        ANDF
      LOGICAL         DITUP    ,MDIUP    ,HIGHER
      INTEGER         NAME1(2) ,NAME2(2) ,NAME(2)  ,NAMEH(2)  ,Z(2)    ,
     1                          EOG      ,BLANK    ,PS        ,ANDF    ,
     2                NAMSUB(2)
      CHARACTER       UFM*23   ,UWM*25   ,UIM*29
      COMMON /XMSSG / UFM      ,UWM      ,UIM
      COMMON /ITEMDT/ NITEM    ,ITEMS(7,1)
      COMMON /SOF   / DITDUM(6),IODUM(8) ,MDIDUM(4),NXTDUM(15),DITUP   ,
     1                MDIUP
      COMMON /SYSTEM/ SYSBUF, NOUT
      COMMON /ZZZZZZ/ BUF(1)
      DATA    PS    / 1 /
      DATA    EOG   / 4H$EOG/, BLANK /4H    /
      DATA    NAMSUB/ 4HRENA,4HME  /
C
C
C     CHECK IF NAME2 ALREADY EXISTS
C
      CALL FDSUB (NAME2,IND)
      IF (IND .NE. -1) GO TO 1000
C
C     CHANGE DIT ENTRY FOR SUBSTRUCTURE NAME1
C
      CALL FDSUB (NAME1,IND)
      IF (IND .LT. 0) GO TO 1100
      CALL FDIT (IND,IDIT)
      IF (NAME1(1).NE.BUF(IDIT) .OR. NAME1(2).NE.BUF(IDIT+1)) GO TO 1200
      BUF(IDIT  ) = NAME2(1)
      BUF(IDIT+1) = NAME2(2)
      DITUP   = .TRUE.
C
      NAME(1) = NAME2(1)
      NAME(2) = NAME2(2)
      HIGHER  = .FALSE.
C
C     CHANGE TABLE ITEMS WHICH CONTAIN SUBSTRUCTRUE NAME
C     SUBSTRUCTURE NAME.
C     HIGHER = .FALSE. - WE ARE WORKING WITH SUBSTRUCTURE NAME1
C     HIGHER = .TRUE.  - WE ARE WORKING WITH A SUBSTRUCTURE FOR
C                        WHICH NAME1 IS A COMPONENT
C
   10 CALL FDSUB (NAME,IND)
      CALL FMDI (IND,IMDI)
      IPS = ANDF(BUF(IMDI+PS),1023)
      DO 100 ITM = 1,NITEM
      IF (ITEMS(2,ITM) .GT. 0) GO TO 100
      ITEM = ITEMS(1,ITM)
      INUM = ITEMS(3,ITM)/1000000
      ILOC = (ITEMS(3,ITM) - INUM*1000000)/1000
      INCR =  ITEMS(3,ITM) - INUM*1000000 - ILOC*1000
C
C     PROCESS THE FOLLOWING ITEMS
C
C     SUBSTRUCTRUE NAME1
C     DONT PROCESS THE ITEM IF THIS IS A SECONDARY SUBSTRUCTURE
C     AND THE ACTUAL ITEM IS STORED FOR THE PRIMARY (I.E. BGSS,CSTM(
C     HIGHER LEVEL SUBSTRUCTURE
C     DONT PROCESS THE ITEM IF IT IS ACTUALLY STORED FOR THE
C     PRIMARY SUBSTRUCTURE (I.E. BGSS,CSTM)
C
      IF (.NOT.HIGHER .AND. ILOC.EQ.0 .AND. IPS.NE.0) GO TO 100
      IF (HIGHER .AND. ILOC.EQ.0) GO TO 100
C
C     READ ITEM INTO OPEN CORE
C
      IRW = 1
      CALL SFETCH (NAME,ITEM,IRW,ITEST)
      IF (ITEST .NE. 1) GO TO 100
      NCORE = NZ
      ICORE = 1
   20 CALL SUREAD (Z(ICORE),NCORE,NWDS,ITEST)
      IF (ITEST .EQ. 3) GO TO 30
      IF (ITEST .EQ. 1) GO TO 1300
      Z(ICORE+NWDS) = EOG
      ICORE = ICORE + NWDS + 1
      NCORE = NCORE - NWDS - 1
      GO TO 20
   30 NWDS  = ICORE + NWDS - 1
C
C     CHANGE ANY OCCURANCE OF NAME1 WITH NAME2
C
      IF (HIGHER) GO TO 40
C
C     SUBSTRUCTURE NAME1 - NAME SHOULD BE IN WORDS 1 AND 2 OF GROUP 0
C
      IF (Z(1).NE.NAME1(1) .OR. Z(2).NE.NAME1(2)) GO TO 100
      Z(1) = NAME2(1)
      Z(2) = NAME2(2)
C
C     SEARCH THE LIST OF COMPONENT SUBSTRUCTURES FOR NAME1
C
   40 NCOMP = Z(INUM)
      ILOC2 = ILOC + INCR*NCOMP - 1
      DO 50 I = ILOC,ILOC2,INCR
      IF (Z(I).NE.NAME1(1) .OR. Z(I+1).NE.NAME1(2)) GO TO 50
      Z(I  ) = NAME2(1)
      Z(I+1) = NAME2(2)
      GO TO 60
   50 CONTINUE
C
C     DELETE OLD ITEM
C
   60 CALL DELETE (NAME,ITEM,ITEST)
C
C     WRITE NEW ITEM TO SOF
C
      ITEST = 3
      IRW   = 2
      CALL SFETCH (NAME,ITEM,IRW,ITEST)
      ITEST = 3
      CALL SUWRT (Z(1),NWDS,ITEST)
C
  100 CONTINUE
C
C     GET NEXT HIGHER LEVEL SUBSTRUCTURE FOR WHICH NAME1 IS A
C     COMPONENT AND PERFORM SAME PROCEDURE
C
      CALL FNDNXL (NAME,NAMEH)
      IF (NAMEH(1).EQ.BLANK .OR. NAMEH(1).EQ.NAME(1) .AND.
     1    NAMEH(2).EQ.NAME(2)) GO TO 110
      NAME(1) = NAMEH(1)
      NAME(2) = NAMEH(2)
      HIGHER = .TRUE.
      GO TO 10
C
C     NO HIGHER LEVEL SUBSTRUCTURES LEFT - PRINT INFORMATION MESSAGE
C     AND RETURN
C
  110 WRITE  (NOUT,120) UIM,NAME1,NAME2
  120 FORMAT (A29,' 6229, SUBSTRUCTURE ',2A4,' HAS BEEN RENAMED TO ',
     1        2A4)
      ITEST = 1
      RETURN
C
C     ERROR RETURNS
C
C
C     SUBSTRUCTURE NAME2 ALREADY EXIST ON THE SOF
C
 1000 WRITE  (NOUT,1010) UWM,NAME1,NAME2
 1010 FORMAT (A25,' 6230, SUBSTRUCTURE ',2A4,' HAS NOT BEEN RENAMED ',
     1       'BECAUSE ',2A4,' ALREADY EXISTS ON THE SOF.')
      ITEST = 10
      RETURN
C
C     SUBSTRUCTURURE NAME1 DOES NOT EXIST
C
 1100 ITEST = 4
      RETURN
C
C     DIT FORMAT ERROR
C
 1200 CALL ERRMKN (21,5)
C
C     INSUFFICIENT CORE TO HOLD ITEM
C
 1300 CALL SOFCLS
      CALL MESAGE (-8,0,NAMSUB)
      RETURN
      END
