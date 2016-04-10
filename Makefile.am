## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = man data src

dist_doc_DATA = \
	README \
	COPYING \
	AUTHORS \
	ChangeLog \
	INSTALL \
	NEWS


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(docdir)

-include $(top_srcdir)/git.mk

GITIGNOREFILES = *.srt *.ass .anjuta/ .anjuta_sym_db.db Debug/ Optimized/ aclocal.m4 compile config.h.in depcomp install-sh missing test-driver *.tar.gz

