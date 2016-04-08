## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(SRTMERGE_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = srtmerge

srtmerge_SOURCES = \
	srtmerge.vala config.vapi title.vala text.vala srtmerge-window.vala processing.vala debug.vala file-source.vala custom-file-chooser.vala font.vala

srtmerge_VALAFLAGS =  \
	--pkg gtk+-3.0

#	-g  --save-temps


srtmerge_LDFLAGS = \
	-Wl,--export-dynamic

srtmerge_LDADD = $(SRTMERGE_LIBS)




