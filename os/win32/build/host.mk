CC=cl
LD=link
P_OS ?= win32
B_OBJEXT ?= tobj

INCLUDES=					\
	/I $(P_PROJDIR)				\
	/I $(P_BASEDIR)/include			\
	/I $(P_BASEDIR)/core/include		\
	/I $(P_BASEDIR)/os/win32/include

EXTRA_CFLAGS += /W3 /D_CRT_SECURE_NO_WARNINGS
ifeq ($(B_DEBUG),0)
EXTRA_CFLAGS += /O2 /Ot /Ox
LDFLAGS =
else
EXTRA_CFLAGS += /Od /D_DEBUG /MTd /Od /Zi /RTC1
LDFLAGS = /DEBUG
endif

all: redfmt redimgbld

%.$(B_OBJEXT): %.c
	$(CC) $(EXTRA_CFLAGS) $(INCLUDES) $< /c /Fo$@

# The redconf.h for the tools #includes the redconf.h from the parent project
# to inherit its settings, so add it as a dependency.
REDPROJHDR ?= $(P_CONFDIR)/redconf.h

include $(P_BASEDIR)/build/reliance.mk

IMGBLDHDR=							\
	$(P_BASEDIR)/os/win32/tools/imgbld/ibheader.h		\
	$(P_BASEDIR)/os/win32/tools/wintlcmn.h
IMGBLDOBJ=							\
	$(P_BASEDIR)/os/win32/tools/imgbld/ibcommon.$(B_OBJEXT)	\
	$(P_BASEDIR)/os/win32/tools/imgbld/ibfse.$(B_OBJEXT)	\
	$(P_BASEDIR)/os/win32/tools/imgbld/ibposix.$(B_OBJEXT)	\
	$(P_BASEDIR)/os/win32/tools/imgbld/imgbld.$(B_OBJEXT)	\
	$(P_BASEDIR)/os/win32/tools/wintlcmn.$(B_OBJEXT)
REDPROJOBJ=							\
	$(IMGBLDOBJ)						\
	$(P_BASEDIR)/os/win32/tools/imgcopy.$(B_OBJEXT)		\
	$(P_BASEDIR)/os/win32/tools/winchk.$(B_OBJEXT)		\
	$(P_BASEDIR)/os/win32/tools/winfmt.$(B_OBJEXT)

$(P_BASEDIR)/os/win32/tools/imgbld/ibcommon.$(B_OBJEXT):	$(P_BASEDIR)/os/win32/tools/imgbld/ibcommon.c $(REDHDR) $(IMGBLDHDR)
$(P_BASEDIR)/os/win32/tools/imgbld/ibfse.$(B_OBJEXT):		$(P_BASEDIR)/os/win32/tools/imgbld/ibfse.c $(REDHDR) $(IMGBLDHDR)
$(P_BASEDIR)/os/win32/tools/imgbld/ibposix.$(B_OBJEXT):		$(P_BASEDIR)/os/win32/tools/imgbld/ibposix.c $(REDHDR) $(IMGBLDHDR)
$(P_BASEDIR)/os/win32/tools/imgbld/imgbld.$(B_OBJEXT):		$(P_BASEDIR)/os/win32/tools/imgbld/imgbld.c $(REDHDR) $(IMGBLDHDR)
$(P_BASEDIR)/os/win32/tools/winfmt.$(B_OBJEXT):			$(P_BASEDIR)/os/win32/tools/winfmt.c $(REDHDR) $(P_BASEDIR)/os/win32/tools/wintlcmn.h
$(P_BASEDIR)/os/win32/tools/wintlcmn.$(B_OBJEXT):		$(P_BASEDIR)/os/win32/tools/wintlcmn.c  $(REDHDR) $(P_BASEDIR)/os/win32/tools/wintlcmn.h

# The redconf.c for the tools #includes the redconf.c from the parent project
# to inherit its settings, so add it as a dependency.
$(P_PROJDIR)/redconf.$(B_OBJEXT):	$(P_CONFDIR)/redconf.c


redfmt: $(P_BASEDIR)/os/win32/tools/winfmt.$(B_OBJEXT) $(P_BASEDIR)/os/win32/tools/wintlcmn.$(B_OBJEXT) $(REDDRIVOBJ) $(REDTOOLOBJ)
	$(LD) $(LDFLAGS) /OUT:$@.exe $^

redimgbld: $(IMGBLDOBJ) $(REDDRIVOBJ) $(REDTOOLOBJ)
	$(LD) $(LDFLAGS) /OUT:$@.exe $^

.phony: clean
clean:
	del /f /q $(subst /,\,$(REDDRIVOBJ) $(REDTOOLOBJ) $(REDPROJOBJ)) 2>NUL
	del /f /q *.ilk *.pdb *.$(B_OBJEXT) *.exe *.suo *.sln 2>NUL

