## Process this file with automake to produce Makefile.in

# the source files are separate so we can test them later
srtmerge_sources = \
	srtmerge.vala \
	title.vala \
	text.vala \
	srtmerge-window.vala \
	processing.vala \
	debug.vala \
	file-source.vala \
	custom-file-chooser.vala \
	font.vala \
	source-entry.vala 

AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	-DIMAGE_DIR=\""$(pkgdatadir)/images"\" \
	$(SRTMERGE_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = srtmerge

# the main.vala contains the main() entry point
srtmerge_SOURCES = \
	main.vala \
	config.vapi \
	$(srtmerge_sources)

# the config.vapi can be loaded as a pkg
# --pkg config --vapidir .
srtmerge_VALAFLAGS =  \
	--pkg gtk+-3.0 
#	-g --save-temps

srtmerge_CFLAGS =  \
	$(AM_CFLAGS)

srtmerge_CPPFLAGS =  \
	$(AM_CPPFLAGS)

srtmerge_LDFLAGS = \
	-Wl,--export-dynamic

srtmerge_LDADD = $(SRTMERGE_LIBS)

### Unit tests for SrtMerge
### to run $ make check
TESTS = tests_srtmerge
check_PROGRAMS = tests_srtmerge

# the entry point and test methods for the test program
tests_srtmerge_SOURCES =  \
	$(srtmerge_sources) \
	tests.vala
	
tests_srtmerge_VALAFLAGS = \
	--pkg gtk+-3.0 \
	-g 
#	--vapidir .

tests_srtmerge_LDFLAGS = \
	$(srtmerge_LDFLAGS)

tests_srtmerge_LDADD = \
	$(srtmerge_LDADD)
	
tests_srtmerge_CPPFLAGS = \
	$(AM_CPPFLAGS)
	
tests_srtmerge_CFLAGS = \
	$(AM_CFLAGS)

EXTRA_DIST = $(ui_DATA)

CLEANFILES = \
	$(srtmerge_SOURCES:.vala=.c) \
	*.stamp \
	*.log \
	*.trs \
	tests.c

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

-include $(top_srcdir)/git.mk
