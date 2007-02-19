#
# Layer Two Tunneling Protocol Daemon
# Copyright (C)1998 Adtran, Inc.
#
# Mark Spencer <markster@marko.net>
#
# This is free software.  You may distribute it under
# the terms of the GNU General Public License,
# version 2, or at your option any later version.
#
# Note on debugging flags:
# -DDEBUG_ZLB shows all ZLB exchange traffic
# -DDEBUG_HELLO debugs when hello messages are sent
# -DDEBUG_CLOSE debugs call and tunnel closing
# -DDEBUG_FLOW debugs flow control system
# -DDEBUG_FILE debugs file format
# -DDEBUG_AAA debugs authentication, accounting, and access control
# -DDEBUG_PAYLOAD shows info on every payload packet
# -DDEBUG_CONTROL shows info on every control packet and the l2tp-control pipe
# -DDEBUG_PPPD shows the command line of pppd
# -DDEBUG_HIDDEN debugs hidden AVP's
# -DDEBUG_ENTROPY debug entropy generation
# -DDEBUG_CONTROL_XMIT
# -DDEBUG_MAGIC
# -DDEBUG_FLOW_MORE
#
# -DTEST_HIDDEN makes Assigned Call ID sent as a hidden AVP
#
DFLAGS= -g -O2 -DDEBUG_PPPD
#DFLAGS= -g -DDEBUG_HELLO -DDEBUG_CLOSE -DDEBUG_FLOW -DDEBUG_PAYLOAD -DDEBUG_CONTROL -DDEBUG_CONTROL_XMIT -DDEBUG_FLOW_MORE -DDEBUG_MAGIC -DDEBUG_ENTROPY -DDEBUG_HIDDEN -DDEBUG_PPPD -DDEBUG_AAA -DDEBUG_FILE -DDEBUG_FLOW -DDEBUG_HELLO -DDEBUG_CLOSE -DDEBUG_ZLB
#
# Uncomment the next line for Linux
#
OSFLAGS= -DLINUX
#
# Uncomment the following to use the kernel interface under Linux
# This requires the pppol2tp-linux-2.4.27.patch patch from contrib
#
#OSFLAGS+= -DUSE_KERNEL
#
# Uncomment the next line for FreeBSD
#
#OSFLAGS= -DFREEBSD
#
# Uncomment the next line for Solaris. For solaris, at least,
# we don't want to specify -I/usr/include because it is in
# the basic search path, and will over-ride some gcc-specific
# include paths and cause problems.
#
#CC=gcc
#OSFLAGS= -DSOLARIS
#OSLIBS= -lnsl -lsocket
#
# Feature flags
#
# Comment the following line to disable xl2tpd maintaining IP address
# pools to pass to pppd to control IP address allocation

FFLAGS= -DIP_ALLOCATION

CFLAGS+= $(DFLAGS) -O2 -fno-builtin -Wall -DSANITY $(OSFLAGS) $(FFLAGS)
HDRS=l2tp.h avp.h misc.h control.h call.h scheduler.h file.h aaa.h md5.h
OBJS=xl2tpd.o pty.o misc.o control.o avp.o call.o network.o avpsend.o scheduler.o file.o aaa.o md5.o
SRCS=${OBJS:.o=.c} ${HDRS}
#LIBS= $(OSLIBS) # -lefence # efence for malloc checking
EXEC=xl2tpd
BINDIR=/usr/sbin
MANDIR=/usr/share/man
all: $(EXEC)

clean:
	rm -f $(OBJS) $(EXEC)

$(EXEC): $(OBJS) $(HDRS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

romfs:
	$(ROMFSINST) /bin/$(EXEC)

install: ${EXEC}
	install -D --mode=0755 ${EXEC} ${DESTDIR}/${BINDIR}/${EXEC}
	install -d --mode=0755 ${DESTDIR}/${MANDIR}/man{5,8}
	install --mode=0644 doc/xl2tpd.8 ${DESTDIR}/${MANDIR}/man8/
	install --mode=0644 doc/xl2tpd.conf.5 doc/l2tp-secrets.5 \
		${DESTDIR}${MANDIR}/man5/

TAGS:	${SRCS}
	etags ${SRCS}
