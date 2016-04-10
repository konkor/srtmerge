dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(srtmerge, 1.0)

dnl this line lets you enable/disable verbose with --disable-silent-rules
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AC_PROG_CC

dnl Check for vala
AM_PROG_VALAC([0.10.0])

PKG_CHECK_MODULES(SRTMERGE, [gtk+-3.0 ])

AC_OUTPUT([
Makefile
src/Makefile
data/icons/Makefile
data/images/Makefile
data/Makefile
man/Makefile
])
