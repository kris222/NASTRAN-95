
# OS Specific Commands

DELETE = del
#LNX DELETE = rm

# GNU Fortran

FC = gfortran

FFLAGS += -g -w
FFLAGS += -fno-range-check
FFLAGS += -fno-automatic
FFLAGS += -fcray-pointer

# NASTRAN library

LIBNASTRAN = ..\mis\libnastran.a

# NASTRAN Objects

NASTRANOBJ += bldpk.o bldpki.o bldpkn.o
NASTRANOBJ += bpack.o bunpak.o bunpk.o
NASTRANOBJ += btstrp.o
NASTRANOBJ += corwds.o
NASTRANOBJ += dbmalb.o
NASTRANOBJ += dbmdia.o
NASTRANOBJ += dbmdmp.o
NASTRANOBJ += dbmfdp.o
NASTRANOBJ += dbmint.o
NASTRANOBJ += dbmio.o
NASTRANOBJ += dbmlbk.o
NASTRANOBJ += dbmnam.o
NASTRANOBJ += dbmmov.o
NASTRANOBJ += dbmrel.o
NASTRANOBJ += dbmrlb.o
NASTRANOBJ += dbmstf.o
NASTRANOBJ += dbmmgr.o
NASTRANOBJ += defcor.o
NASTRANOBJ += dsblpk.o
NASTRANOBJ += dsbpnk.o
NASTRANOBJ += dsbrc1.o
NASTRANOBJ += dscpos.o
NASTRANOBJ += dsclos.o dsopen.o
NASTRANOBJ += dsefwr.o
NASTRANOBJ += dsinqr.o
NASTRANOBJ += dsfwr1.o
NASTRANOBJ += dsgefl.o
NASTRANOBJ += dsgncl.o
NASTRANOBJ += dsgnop.o
NASTRANOBJ += dsgnrd.o dsgnwr.o
NASTRANOBJ += dshxdd.o dshxdp.o
NASTRANOBJ += dsiodd.o
NASTRANOBJ += dsipk1.o
NASTRANOBJ += dsmsg.o dsmsg1.o
NASTRANOBJ += dsocff.o dsopff.o
NASTRANOBJ += dsprcl.o
NASTRANOBJ += dsread.o dswrit.o
NASTRANOBJ += dsrdmb.o dsrdnb.o dsrdpb.o
NASTRANOBJ += dsrlse.o
NASTRANOBJ += dssdcb.o
NASTRANOBJ += dssend.o
NASTRANOBJ += dssize.o
NASTRANOBJ += dsskfb.o dsskff.o dsskrc.o
NASTRANOBJ += dsspos.o
NASTRANOBJ += dsupkc.o
NASTRANOBJ += dswrnb.o
NASTRANOBJ += dswrt1.o
NASTRANOBJ += dsxfsz.o
NASTRANOBJ += dummy.o
NASTRANOBJ += emgsoc.o
NASTRANOBJ += endget.o endgtb.o endput.o
NASTRANOBJ += eof.o
NASTRANOBJ += errtrc.o
NASTRANOBJ += exfort.o
NASTRANOBJ += forwrt.o
NASTRANOBJ += getstb.o getstr.o geturn.o
NASTRANOBJ += gnfiat.o
NASTRANOBJ += intpk.o intpki.o
NASTRANOBJ += k2b.o
NASTRANOBJ += khrbcd.o khrfn1.o khrfn4.o
NASTRANOBJ += nasopn.o
NASTRANOBJ += numtyp.o
NASTRANOBJ += putstr.o
NASTRANOBJ += rectyp.o
NASTRANOBJ += rdblk.o
NASTRANOBJ += rfopen.o
NASTRANOBJ += sgino.o
NASTRANOBJ += skpfil.o
NASTRANOBJ += sofio.o
NASTRANOBJ += umffd.o
NASTRANOBJ += wrtblk.o wrtfmt.o
NASTRANOBJ += zblpki.o zntpki.o

NASTRANOBJ += bckrec.o fwdrec.o
NASTRANOBJ += close.o open.o qopen.o rewind.o
NASTRANOBJ += filpos.o savpos.o
NASTRANOBJ += pack.o unpack.o
NASTRANOBJ += read.o write.o
NASTRANOBJ += klock.o tdate.o
NASTRANOBJ += cputim.o nastim.o waltim.o

# Block Data

BDDIR = ..\bd
BDOBJ += $(BDDIR)\dpdcbd.o
BDOBJ += $(BDDIR)\exiobd.o
BDOBJ += $(BDDIR)\flbbd.o
BDOBJ += $(BDDIR)\gp3bd.o
BDOBJ += $(BDDIR)\gptabd.o
BDOBJ += $(BDDIR)\ifp3bd.o
BDOBJ += $(BDDIR)\ifx1bd.o
BDOBJ += $(BDDIR)\ifx2bd.o
BDOBJ += $(BDDIR)\ifx3bd.o
BDOBJ += $(BDDIR)\ifx4bd.o
BDOBJ += $(BDDIR)\ifx5bd.o
BDOBJ += $(BDDIR)\ifx6bd.o
BDOBJ += $(BDDIR)\ifx7bd.o
BDOBJ += $(BDDIR)\itembd.o
BDOBJ += $(BDDIR)\of1pbd.o
BDOBJ += $(BDDIR)\of2pbd.o
BDOBJ += $(BDDIR)\of3pbd.o
BDOBJ += $(BDDIR)\of3sbd.o
BDOBJ += $(BDDIR)\of4pbd.o
BDOBJ += $(BDDIR)\of5pbd.o
BDOBJ += $(BDDIR)\of6pbd.o
BDOBJ += $(BDDIR)\of7pbd.o
BDOBJ += $(BDDIR)\of7sbd.o
BDOBJ += $(BDDIR)\of8pbd.o
BDOBJ += $(BDDIR)\of9pbd.o
BDOBJ += $(BDDIR)\ofp1bd.o
BDOBJ += $(BDDIR)\ofp5bd.o
BDOBJ += $(BDDIR)\ofsnbd.o
BDOBJ += $(BDDIR)\ofssbd.o
BDOBJ += $(BDDIR)\pla4bd.o
BDOBJ += $(BDDIR)\plotbd.o
BDOBJ += $(BDDIR)\readbd.o
BDOBJ += $(BDDIR)\sdr2bd.o
BDOBJ += $(BDDIR)\semdbd.o
BDOBJ += $(BDDIR)\sma1bd.o
BDOBJ += $(BDDIR)\sma2bd.o
BDOBJ += $(BDDIR)\ta1abd.o
BDOBJ += $(BDDIR)\tabfbd.o
BDOBJ += $(BDDIR)\vdrbd.o

# Fortran 77 Text Routines
# https://github.com/OdonataResearchLLC/Text77

TEXT77 = text77.o

# Free to Fixed field Objects

FFOBJ += dbmstf.o
FFOBJ += dummy.o
FFOBJ += k2b.o khrbcd.o khrfn1.o
FFOBJ += errtrc.o
FFOBJ += cputim.o waltim.o

# Default target

default:	nastran.exe

all:	nastran.exe chkfil.exe ff.exe nastplot.exe

# Specific targets

nastran.exe:	nastran.f90 $(NASTRANOBJ) $(BDOBJ) $(TEXT77)
	$(FC) $(FFLAGS) -o $@ $< $(NASTRANOBJ) $(BDOBJ) $(TEXT77) $(LIBNASTRAN)

chkfil.exe:	chkfil.f
	$(FC) $(FFLAGS) -o $@ $<

ff.exe:	ff.f $(FFOBJ)
	$(FC) $(FFLAGS) -o $@ $< $(FFOBJ) $(LIBNASTRAN)

nastplot.exe:	nastplot.f
	$(FC) $(FFLAGS) -o $@ $<

# Template rules

%.o:	%.f
	$(FC) $(FFLAGS) -c -o $@ $<

# Phony rules

.PHONY:	clean distclean

distclean:	clean
	-$(DELETE) nastran.exe
	-$(DELETE) chkfil.exe
	-$(DELETE) ff.exe
	-$(DELETE) nastplot.exe

clean:
	-$(DELETE) *.o
	-$(DELETE) $(BDDIR)\*.o
