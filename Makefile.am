## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = data src

dist_doc_DATA = \
	README \
	COPYING \
	AUTHORS \
	ChangeLog \
	INSTALL \
	NEWS

# The desktop files
#desktopdir = $(datadir)/applications
#desktop_DATA =srtmerge.desktop
#desktopdir = $(datadir)/applications
#desktop_in_files = srtmerge.desktop.in
#desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

#@INTLTOOL_DESKTOP_RULE@

# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(docdir)
