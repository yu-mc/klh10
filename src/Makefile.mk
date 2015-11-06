# KLH10 Makefile.
# $Id: Makefile.mk,v 2.6 2002/03/21 09:44:05 klh Exp $
#
#  Copyright � 1992, 1993, 2001 Kenneth L. Harrenstien
#  All Rights Reserved
#
#  This file is part of the KLH10 Distribution.  Use, modification, and
#  re-distribution is permitted subject to the terms in the file
#  named "LICENSE", which contains the full text of the legal notices
#  and should always accompany this Distribution.
#
#  This software is provided "AS IS" with NO WARRANTY OF ANY KIND.
#
#  This notice (including the copyright and warranty disclaimer)
#  must be included in all copies or derivations of this software.
#
#####################################################################

# KLH10 Makefile scheme
#
# <dist>/src/
# 	Makefile - Top-level makefile for in-src build (not recommended)
# 	Makefile.mk - All generic rules and definitions
# 	Mk-<plat>.mk - Platform-specific definitions
# 
# <dist>/bld/<plat>
# 	Makefile -> ../../src/Mk-<plat>.mk
# 		(or local version thereof)
# 	[any locally munged .h files]
# 
# Each top-level makefile should define at least the following:
# 	SRC = <location of source dir>
# 
#####################################################################


# Basic default definitions.
#	Normally these will be overridden by build-specific make
#	invocations, by both or either of:
#	(1) concatenation of a platform-specific makefile of the
#		form "Mk-<plat>.mk"
#		(the most recent defs override these defaults)
#	(2) command line definitions, which override those from any files.

# Generic compile/link flags
#	Suitable for plain vanilla Unix but normally overridden.
CC = cc
CFLAGS = -c -I. -I$(SRC)
CFLAGS_AUX =
CFLAGS_LINT =
LINKER = $(CC)
LDFLAGS =
LDOUTF = -o
LIBS = 

# Variables specific to this makefile setup
#	SRC and MAKE_CENV are normally overridden.
SRC = ../../src
MAKE_CENV = 
CENVFLAGS =
CONFFLAGS =
CONFFLAGS_AUX =

MAKER = make -f $(SRC)/Makefile.mk $(MAKE_CENV)
BUILDMOD = $(CC) $(CFLAGS) $(CFLAGS_AUX) \
	$(CENVFLAGS) $(CONFFLAGS) $(CONFFLAGS_AUX)


## Default if no target given to make.
##
default:
	@echo 'Intended to be invoked from a bld/<conf>/ directory, look'
	@echo 'at bld/*/Makefile for examples.'

## Default if no target given to bld/<conf> invocation
##
usage:
	@echo 'Use "make <target>", eg "make base-kl"'
	@echo 'Normally the target is one of these 3 base configs:'
	@echo '  base-kl      KL10 version for TOPS (kn10-kl and utils)'
	@echo '  base-ks      KS10 version for TOPS (kn10-ks and utils)'
	@echo '  base-ks-its  KS10 version for ITS  (kn10-ks and utils)'
	@echo 'Or these utilities:'
	@echo '  tapedd    Tape copy & conversion'
	@echo '  vdkfmt    Virtual disk copy & conversion'
	@echo '  wxtest    Test w10_t internals'
	@echo '  enaddr    Show and manage ether interfaces'
	@echo 'Or these actions:'
	@echo '  clean     Clean binaries from build directory'
	@echo '  install   Install binaries in $$KLH10_HOME'

## Help for makefile debugging
##
showdefs:
	@echo "Showing target defs:"
	@echo "SRC = $(SRC)"
	@echo "MAKER = $(MAKER)"
	@echo "CFLAGS = $(CFLAGS)"
	@echo "CFLAGS_AUX = $(CFLAGS_AUX)"
	@echo "CENVFLAGS = $(CENVFLAGS)"
	@echo "CONFFLAGS = $(CONFFLAGS)"
	@echo "CONFFLAGS_AUX = $(CONFFLAGS_AUX)"
	@echo "BUILDMOD = $(BUILDMOD)"


# Generally applicable rules

# It would be nice to use the .c.o inference rule for all the .o files,
# but the DECOSF "make" chokes when sources are in a different directory,
# never even invoking .c.o at all.  Their /usr/bin/posix/make loses too
# because its MAKEARGS macro prevents recursive makes from accepting
# args with spaces in them.
#
# Thus, for max portability every module target must have explicit
# build commands, and due to the same DECOSF lossage cannot use $<
# in those commands.  Sigh!

.SUFFIXES: $(SUFFIXES) .i

.c.o:
	$(BUILDMOD) $<

.c.s:
	$(BUILDMOD) -S $<

.c.i:
	$(BUILDMOD) -E $<  > $*.i

# Don't flush these files if interrupted.
#	Currently no intermediate source files are generated, so
#	this can be empty, but hang on to last binary anyway.
.PRECIOUS: kn10-ks kn10-kl


#######################################################################	
##
##	Define sources constituting the KLH10.  I have not bothered
##	to derive a full set of dependencies for each module since
##	there are too many possible combinations; safest to always
##	recompile everything.
##
##	Also, note the KS and KL have two independent module lists in order
##	to allow controlling the order in which modules are loaded; this
##	can help improve locality.

# Generic header files

CONFS = cenv.h klh10.h word10.h wfio.h fecmd.h feload.h \
	kn10mac.h kn10def.h kn10pag.h kn10clk.h kn10dev.h kn10ops.h \
	opcods.h opdefs.h osdsup.h \
	dvcty.h dvuba.h dvrh11.h dvlhdh.h dvdz11.h dvch11.h \
	dvrh20.h dvrpxx.h dvtm03.h dvni20.h dvhost.h dvlites.h \
	vmtape.h vdisk.h

# Modules needed for KL10 version.

OFILES_KL = klh10.o prmstr.o fecmd.o feload.o wfio.o osdsup.o \
	kn10cpu.o kn10pag.o kn10clk.o opdata.o kn10ops.o \
	inmove.o inhalf.o inblsh.o intest.o \
	infix.o  inflt.o  inbyte.o injrst.o \
	inexts.o inio.o   kn10dev.o 	\
	dvcty.o  dvdte.o	\
	vdisk.o  dvrpxx.o dvrh20.o	\
	vmtape.o dvtm03.o	\
	dvni20.o dpsup.o	\
	dvhost.o dvlites.o

# Modules needed for KS10 version.

OFILES_KS = klh10.o prmstr.o fecmd.o feload.o wfio.o osdsup.o \
	kn10cpu.o kn10pag.o kn10clk.o opdata.o kn10ops.o \
	inmove.o inhalf.o inblsh.o intest.o \
	infix.o  inflt.o  inbyte.o injrst.o \
	inexts.o inio.o   kn10dev.o dvuba.o  \
	dvcty.o  			\
	vdisk.o  dvrpxx.o dvrh11.o	\
	vmtape.o dvtm03.o	\
	dvlhdh.o dvdz11.o dvch11.o \
	dpsup.o \
	dvhost.o dvlites.o

# Device Processes (DPs) built concurrently with KN10

DPROCS_KL = dprpxx dptm03 dpni20
DPROCS_KS = dprpxx dptm03
DPROCS_KSITS = dprpxx dptm03 dpimp


# Base utility programs, independent of KN10
# (there are others not included in the base configs)

BASE_UTILS = wfconv tapedd vdkfmt wxtest
ALL_UTILS  = $(BASE_UTILS) udlconv uexbconv enaddr


############################################################
##	KLH10 config - helper definitions
##

# Subflags for fully synchronous time emulation
#	These are good for debugging, or on a slow machine.
TSYNCFLAGS = \
	-DKLH10_RTIME_SYNCH=1 \
	-DKLH10_ITIME_SYNCH=1 \
	-DKLH10_QTIME_SYNCH=1

# Subflags for fully OS-interrupt-driven time emulation
#	These are best for high performance on a fast machine.
TINTFLAGS = \
	-DKLH10_RTIME_OSGET=1 \
	-DKLH10_ITIME_INTRP=1 \
	-DKLH10_QTIME_OSVIRT=1

# Subflags for synchronous polling versions of certain device drivers.
#	These are good for debugging.
DSYNCFLAGS = \
	-DKLH10_IMPIO_INT=0 \
	-DKLH10_CTYIO_INT=0

# Subflags for interrupt-driven versions of certain device drivers.
#	These are best for high performance.
DINTFLAGS  = \
	-DKLH10_IMPIO_INT=1 \
	-DKLH10_CTYIO_INT=1


####################################################################
##
##	Basic KN10 configurations
##

kn10-ks: $(OFILES_KS)
	$(LINKER) $(LDFLAGS) $(LDOUTF) kn10-ks $(OFILES_KS) $(LIBS)

kn10-kl: $(OFILES_KL)
	$(LINKER) $(LDFLAGS) $(LDOUTF) kn10-kl $(OFILES_KL) $(LIBS)


####################################################################
##	Auxiliary action targets

clean:
	@rm -f  kn10-ks kn10-kl *.o \
		$(DPROCS_KL) $(DPROCS_KS) $(DPROCS_KSITS) \
		$(ALL_UTILS)


# Install.  This should really use a shell script instead.
#
install-unix:
	@echo "Copying binaries into ${KLH10_HOME}"
	@-rm -rf ${KLH10_HOME}/flushed
	@-mkdir  ${KLH10_HOME}/flushed
	@if [ -x ${KLH10_HOME}/kn10-ks ]; then \
		mv ${KLH10_HOME}/kn10-ks ${KLH10_HOME}/flushed; fi
	@if [ -x ${KLH10_HOME}/kn10-kl ]; then \
		mv ${KLH10_HOME}/kn10-kl ${KLH10_HOME}/flushed; fi
	@if [ -x ${KLH10_HOME}/dprpxx ]; then \
		mv ${KLH10_HOME}/dprpxx ${KLH10_HOME}/flushed; fi
	@if [ -x ${KLH10_HOME}/dptm03 ]; then \
		mv ${KLH10_HOME}/dptm03 ${KLH10_HOME}/flushed; fi
	@if [ -x ${KLH10_HOME}/dpni20 ]; then \
		mv ${KLH10_HOME}/dpni20 ${KLH10_HOME}/flushed; fi
	@if [ -x ${KLH10_HOME}/dpimp  ]; then \
		mv ${KLH10_HOME}/dpimp  ${KLH10_HOME}/flushed; fi
	@if [ -x kn10-ks  ]; then cp -p kn10-ks  ${KLH10_HOME}/; fi
	@if [ -x kn10-kl  ]; then cp -p kn10-kl  ${KLH10_HOME}/; fi
	@if [ -x dprpxx   ]; then cp -p dprpxx   ${KLH10_HOME}/; fi
	@if [ -x dptm03   ]; then cp -p dptm03   ${KLH10_HOME}/; fi
	@if [ -x dpni20   ]; then cp -p dpni20   ${KLH10_HOME}/; fi
	@if [ -x dpimp    ]; then cp -p dpimp    ${KLH10_HOME}/; fi
	@if [ -x enaddr   ]; then cp -p enaddr   ${KLH10_HOME}/; fi
	@if [ -x tapedd   ]; then cp -p tapedd   ${KLH10_HOME}/; fi
	@if [ -x udlconv  ]; then cp -p udlconv  ${KLH10_HOME}/; fi
	@if [ -x uexbconv ]; then cp -p uexbconv ${KLH10_HOME}/; fi
	@if [ -x vdkfmt   ]; then cp -p vdkfmt   ${KLH10_HOME}/; fi
	@if [ -x wfconv   ]; then cp -p wfconv   ${KLH10_HOME}/; fi
	@if [ -x wxtest   ]; then cp -p wxtest   ${KLH10_HOME}/; fi
	@echo "Done!"

####################################################################
##	Specific KLH10 configurations
##	
##	Provided as a convenience, not intended to satisfy all
##	possible platforms or configurations.

# Standard setup for KS ITS
#
base-ks-its:
	$(MAKER) kn10-ks $(DPROCS_KSITS) $(BASE_UTILS) udlconv \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KS=1	\
		-DKLH10_SYS_ITS=1	\
		-DKLH10_EVHS_INT=1	\
			-DKLH10_DEV_DPTM03=1 \
			-DKLH10_DEV_DPRPXX=1 \
			-DKLH10_DEV_DPIMP=1 \
		-DKLH10_SIMP=0 \
		-DKLH10_NET_TUN=SYS_FREEBSD \
		-DKLH10_MEM_SHARED=1 \
		$(TINTFLAGS) \
		$(DINTFLAGS) \
		-DKLH10_APRID_SERIALNO=4097 -DKLH10_DEVMAX=12 \
		-DKLH10_CLIENT=\\\"MyITS\\\" \
		$(CONFFLAGS_AUX) \
		-DVMTAPE_ITSDUMP=1 "


# Standard setup for KS (TOPS-20, maybe TOPS-10)
#
base-ks:
	$(MAKER) kn10-ks $(DPROCS_KS) $(BASE_UTILS) \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KS=1	\
		-DKLH10_SYS_T20=1	\
		-DKLH10_EVHS_INT=1	\
			-DKLH10_DEV_DPTM03=1 \
			-DKLH10_DEV_DPRPXX=1 \
		-DKLH10_MEM_SHARED=1 \
		$(TINTFLAGS) \
		$(DINTFLAGS) \
		-DKLH10_APRID_SERIALNO=4097 -DKLH10_DEVMAX=12 \
		-DKLH10_CLIENT=\\\"MyKS\\\" \
		$(CONFFLAGS_AUX) "

# Standard setup for KL (TOPS-10 and TOPS-20)
#
base-kl:
	$(MAKER) kn10-kl $(DPROCS_KL) $(BASE_UTILS) uexbconv \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KLX=1	\
		-DKLH10_SYS_T20=1	\
		-DKLH10_EVHS_INT=1	\
			-DKLH10_DEV_DPNI20=1 \
			-DKLH10_DEV_DPTM03=1 \
			-DKLH10_DEV_DPRPXX=1 \
		-DKLH10_MEM_SHARED=1	\
		-DKLH10_RTIME_OSGET=1	\
		-DKLH10_ITIME_INTRP=1	\
		-DKLH10_CTYIO_INT=1	\
		-DKLH10_APRID_SERIALNO=3600 \
		-DKLH10_CLIENT=\\\"MyKL\\\" \
		$(CONFFLAGS_AUX) "

####################################################################
##	Lintish versions to see how many compiler warnings we can generate
##
lint-ks-its:
	$(MAKER) kn10-ks $(DPROCS_KSITS) $(BASE_UTILS) udlconv \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX) $(CFLAGS_LINT)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = $(CONFFLAGS) $(CONFFLAGS_AUX)"

lint-ks:
	$(MAKER) kn10-ks $(DPROCS_KS) $(BASE_UTILS) \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX) $(CFLAGS_LINT)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = $(CONFFLAGS) $(CONFFLAGS_AUX)"

lint-kl:
	$(MAKER) kn10-kl $(DPROCS_KL) $(BASE_UTILS) uexbconv \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX) $(CFLAGS_LINT)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = $(CONFFLAGS) $(CONFFLAGS_AUX)"


####################################################################
##	KLH10 versions for diagnostics and debugging.
##

# "Port"-friendly KS, for helping port to a new platform.
#	Simplest possible configuration:
#	No shared memory
#	No device subprocs
#	No realtime interrupts or clock - synchronous emulation
port-ks:
	$(MAKER) kn10-ks $(BASE_UTILS) \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KS=1	\
		-DKLH10_SYS_T20=1	\
		-DKLH10_RTIME_SYNCH=1	\
		-DKLH10_APRID_SERIALNO=4097 -DKLH10_DEVMAX=12 \
		-DKLH10_CLIENT=\\\"MyKS\\\" \
		$(CONFFLAGS_AUX) "


# Build KL0 with KI paging, for running diagnostics.
#	Two versions, one synch and one realtime.
#	Note: The diags tend to fail miserably when faced with a KLX using KI
#	paging, so don't try that.

# KL0 with KI paging - synchronous, good for debugging with diagnostics.
#	NOTE: CFLAGS for this one should be set up for NO optimization!!!
kl0i-sync:
	$(MAKER) kn10-kl $(DPROCS_KL) \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KL0=1	\
		-DKLH10_SYS_T10=1	\
		-DKLH10_PAG_KI=1	\
		-DKLH10_EVHS_INT=1	\
			-DKLH10_DEV_DPNI20=1 \
			-DKLH10_DEV_DPTM03=1 \
			-DKLH10_DEV_DPRPXX=1 \
		-DKLH10_RTIME_SYNCH=1	\
		-DKLH10_ITIME_SYNCH=1	\
		-DKLH10_CTYIO_INT=0 \
		$(CONFFLAGS_AUX) "

# KL0 with KI paging - Realtime & optimized, good for timing diagnostics.
#
kl0i-rtmopt:
	$(MAKER) kn10-kl $(DPROCS_KL) \
	    "SRC = $(SRC)" \
	    "CC = $(CC)" \
	    "CFLAGS = $(CFLAGS) $(CFLAGS_AUX)" \
	    "LDFLAGS = $(LDFLAGS)" \
	    "LIBS = $(LIBS)" \
	    "CENVFLAGS = $(CENVFLAGS)" \
	    "CONFFLAGS = \
		-DKLH10_CPU_KL0=1	\
		-DKLH10_SYS_T10=1	\
		-DKLH10_PAG_KI=1	\
		-DKLH10_EVHS_INT=1	\
			-DKLH10_DEV_DPNI20=1 \
			-DKLH10_DEV_DPTM03=1 \
			-DKLH10_DEV_DPRPXX=1 \
		-DKLH10_RTIME_OSGET=1	\
		-DKLH10_ITIME_INTRP=1	\
		-DKLH10_CTYIO_INT=0 \
		$(CONFFLAGS_AUX) "


####################################################################
##	Device Process (DP) programs
##
##	These cannot be made individually - they are expected to be
##	built as byproducts of building the KLH10, in order to share
##	a common set of config parameters.
##

# --------- RPXX disk drive subprocess
#
dprpxx.o: $(SRC)/dprpxx.c $(SRC)/dprpxx.h $(SRC)/dpsup.h $(SRC)/vdisk.c
	$(BUILDMOD) $(SRC)/dprpxx.c

dprpxx: dprpxx.o dpsup.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) dprpxx dprpxx.o dpsup.o $(LIBS)


# --------- TM03 tape drive subprocess
#
dptm03.o: $(SRC)/dptm03.c $(SRC)/dptm03.h $(SRC)/dpsup.h $(SRC)/vmtape.c
	$(BUILDMOD) $(SRC)/dptm03.c

OFILES_DPTM03=dptm03.o dpsup.o wfio.o prmstr.o

dptm03: $(OFILES_DPTM03)
	$(LINKER) $(LDFLAGS) $(LDOUTF) dptm03 $(OFILES_DPTM03) $(LIBS)


# --------- NI20 Network Interface subprocess (KL only)
#
dpni20.o: $(SRC)/dpni20.c $(SRC)/dpni20.h $(SRC)/dpsup.h
	$(BUILDMOD) $(SRC)/dpni20.c

dpni20: dpni20.o dpsup.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) dpni20 dpni20.o dpsup.o $(LIBS)


# --------- IMP subprocess (ITS KS only; counterpart for dvlhdh)
#
dpimp.o: $(SRC)/dpimp.c $(SRC)/dpimp.h $(SRC)/dpsup.h
	$(BUILDMOD) $(SRC)/dpimp.c

dpimp: dpimp.o dpsup.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) dpimp dpimp.o dpsup.o $(LIBS)


####################################################################
##		UTILITIES
##
##	These can be built independently, and normally do not require
##	any CONFFLAGS.
##

## TAPEDD - Tape device-to-device copy
##	Needs CONFFLAGS just for optional VMTAPE_ITSDUMP.
##
tapedd.o: $(SRC)/tapedd.c $(SRC)/vmtape.c $(SRC)/vmtape.h
	$(CC) $(CFLAGS) $(CENVFLAGS) $(CONFFLAGS) $(SRC)/tapedd.c

tapedd: tapedd.o wfio.o prmstr.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) tapedd tapedd.o wfio.o prmstr.o $(LIBS)


## VDKFMT - Virtual Disk Format & copy
##
vdkfmt.o: $(SRC)/vdkfmt.c $(SRC)/vdisk.c $(SRC)/vdisk.h
	$(CC) $(CFLAGS) $(CENVFLAGS) $(SRC)/vdkfmt.c

vdkfmt: vdkfmt.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) vdkfmt vdkfmt.o $(LIBS)


## WXTEST - word10.h tester
##
wxtest.o: $(SRC)/wxtest.c  $(SRC)/word10.h
	$(CC) $(CFLAGS) $(CENVFLAGS) $(SRC)/wxtest.c

wxtest: wxtest.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) wxtest wxtest.o $(LIBS)


## WFCONV - Word-File Conversion
##
wfconv.o: $(SRC)/wfconv.c $(SRC)/wfio.c $(SRC)/wfio.h $(SRC)/word10.h
	$(CC) $(CFLAGS) $(CENVFLAGS) $(SRC)/wfconv.c

wfconv: wfconv.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) wfconv wfconv.o $(LIBS)


## UDLCONV - DIR.LIST Conversion (of ITS interest only)
##
udlconv.o: $(SRC)/udlconv.c
	$(CC) $(CFLAGS) $(CENVFLAGS) $(SRC)/udlconv.c

udlconv: udlconv.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) udlconv udlconv.o $(LIBS)


## UEXBCONV - Convert .EXB file into .SAV (of KL interest only)
##
uexbconv.o: $(SRC)/uexbconv.c $(SRC)/wfio.c $(SRC)/wfio.h $(SRC)/word10.h
	$(CC) $(CFLAGS) $(CENVFLAGS) $(SRC)/uexbconv.c

uexbconv: uexbconv.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) uexbconv uexbconv.o $(LIBS)


## ENADDR - Ethernet interface test & manipulation
##	    May require CONFFLAGS to force a particular osdnet config.
enaddr.o: $(SRC)/enaddr.c $(SRC)/osdnet.h $(SRC)/osdnet.c
	$(CC) $(CFLAGS) $(CENVFLAGS) $(CONFFLAGS) $(SRC)/enaddr.c

enaddr: enaddr.o
	$(LINKER) $(LDFLAGS) $(LDOUTF) enaddr enaddr.o $(LIBS)


####################################################################
##	KN10 modules.  In order to build into a directory other than the
##	one the sources are located, must specify the location of
##	each and every source file.  Ugh.  Some but not all dependencies
##	are included here.
##
## Sorted alphabetically.
##

dpsup.o: $(SRC)/dpsup.c $(SRC)/dpsup.h
	$(BUILDMOD) $(SRC)/dpsup.c

dvch11.o: $(SRC)/dvch11.c $(SRC)/dvch11.h
	$(BUILDMOD) $(SRC)/dvch11.c

dvcty.o: $(SRC)/dvcty.c $(SRC)/dvcty.h
	$(BUILDMOD) $(SRC)/dvcty.c

dvdte.o: $(SRC)/dvdte.c $(SRC)/dvdte.h
	$(BUILDMOD) $(SRC)/dvdte.c

dvdz11.o: $(SRC)/dvdz11.c $(SRC)/dvdz11.h
	$(BUILDMOD) $(SRC)/dvdz11.c

dvhost.o: $(SRC)/dvhost.c $(SRC)/dvhost.h $(SRC)/dvlites.h
	$(BUILDMOD) $(SRC)/dvhost.c

dvlites.o: $(SRC)/dvlites.c $(SRC)/dvlites.h
	$(BUILDMOD) $(SRC)/dvlites.c

dvlhdh.o: $(SRC)/dvlhdh.c $(SRC)/dvlhdh.h
	$(BUILDMOD) $(SRC)/dvlhdh.c

dvni20.o: $(SRC)/dvni20.c $(SRC)/dvni20.h
	$(BUILDMOD) $(SRC)/dvni20.c

dvrh11.o: $(SRC)/dvrh11.c $(SRC)/dvrh11.h
	$(BUILDMOD) $(SRC)/dvrh11.c

dvrh20.o: $(SRC)/dvrh20.c $(SRC)/dvrh20.h
	$(BUILDMOD) $(SRC)/dvrh20.c

dvrpxx.o: $(SRC)/dvrpxx.c $(SRC)/dvrpxx.h
	$(BUILDMOD) $(SRC)/dvrpxx.c

dvtm03.o: $(SRC)/dvtm03.c $(SRC)/dvtm03.h
	$(BUILDMOD) $(SRC)/dvtm03.c

dvuba.o: $(SRC)/dvuba.c $(SRC)/dvuba.h
	$(BUILDMOD) $(SRC)/dvuba.c

fecmd.o: $(SRC)/fecmd.c $(SRC)/fecmd.h
	$(BUILDMOD) $(SRC)/fecmd.c

feload.o: $(SRC)/feload.c $(SRC)/feload.h
	$(BUILDMOD) $(SRC)/feload.c

inblsh.o: $(SRC)/inblsh.c
	$(BUILDMOD) $(SRC)/inblsh.c

inbyte.o: $(SRC)/inbyte.c
	$(BUILDMOD) $(SRC)/inbyte.c

inexts.o: $(SRC)/inexts.c
	$(BUILDMOD) $(SRC)/inexts.c

infix.o: $(SRC)/infix.c
	$(BUILDMOD) $(SRC)/infix.c

inflt.o: $(SRC)/inflt.c
	$(BUILDMOD) $(SRC)/inflt.c

inhalf.o: $(SRC)/inhalf.c
	$(BUILDMOD) $(SRC)/inhalf.c

inio.o: $(SRC)/inio.c
	$(BUILDMOD) $(SRC)/inio.c

injrst.o: $(SRC)/injrst.c
	$(BUILDMOD) $(SRC)/injrst.c

inmove.o: $(SRC)/inmove.c
	$(BUILDMOD) $(SRC)/inmove.c

intest.o: $(SRC)/intest.c
	$(BUILDMOD) $(SRC)/intest.c

kn10clk.o: $(SRC)/kn10clk.c $(SRC)/kn10clk.h
	$(BUILDMOD) $(SRC)/kn10clk.c

kn10cpu.o: $(SRC)/kn10cpu.c $(SRC)/klh10.h $(SRC)/klh10s.h $(SRC)/klh10.c
	$(BUILDMOD) $(SRC)/kn10cpu.c

kn10dev.o: $(SRC)/kn10dev.c $(SRC)/kn10dev.h
	$(BUILDMOD) $(SRC)/kn10dev.c

kn10ops.o: $(SRC)/kn10ops.c $(SRC)/kn10ops.h
	$(BUILDMOD) $(SRC)/kn10ops.c

kn10pag.o: $(SRC)/kn10pag.c $(SRC)/kn10pag.h
	$(BUILDMOD) $(SRC)/kn10pag.c

klh10.o: $(SRC)/klh10.c $(SRC)/klh10.h $(SRC)/klh10s.h
	$(BUILDMOD) $(SRC)/klh10.c

opdata.o: $(SRC)/opdata.c $(SRC)/kn10def.h $(SRC)/opcods.h
	$(BUILDMOD) $(SRC)/opdata.c

osdsup.o: $(SRC)/osdsup.c $(SRC)/osdsup.h
	$(BUILDMOD) $(SRC)/osdsup.c

prmstr.o: $(SRC)/prmstr.c $(SRC)/prmstr.h
	$(BUILDMOD) $(SRC)/prmstr.c

vdisk.o: $(SRC)/vdisk.c $(SRC)/vdisk.h
	$(BUILDMOD) $(SRC)/vdisk.c

vmtape.o: $(SRC)/vmtape.c $(SRC)/vmtape.h
	$(BUILDMOD) $(SRC)/vmtape.c

wfio.o: $(SRC)/wfio.c $(SRC)/wfio.h
	$(BUILDMOD) $(SRC)/wfio.c


####################################################################
##	OLD STUFF
##		Misc crocks kept around just in case.
##

optest: optest.o
	$(LINKER) $(LDFLAGS) -o optest optest.o $(LIBS)


# This is only for munching Alan's ITS DUMP tape info format
dlmunch: dlmunch.o lread.o
	$(LINKER) -o dlmunch dlmunch.o lread.o

####################################################################