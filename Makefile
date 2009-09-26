GARNAME = gnubatch
GARVERSION = 1.1
CATEGORIES = server
GARCOMPILER = GNU

DESCRIPTION = Brief description
define BLURB
  Long description
endef

MASTER_SITES = http://ftp.gnu.org/gnu/gnubatch/
DISTFILES  = $(GARNAME)-$(GARVERSION).tar.gz

PATCHFILES = $(shell cd files; ls *.patch)

# We define upstream file regex so we can be notifed of new upstream software release
UFILES_REGEX = $(GARNAME)-(\d+(?:\.\d+)*).tar.gz

# If the url used to check for software update is different of MASTER_SITES, then 
# uncomment the next line. Otherwise it is set by default to the value of MASTER_SITES
# UPSTREAM_MASTER_SITES = 

CONFIGURE_ARGS  = $(DIRPATHS)
CONFIGURE_ARGS += --with-spool-directory=/var/opt/csw/gnubatch
CONFIGURE_ARGS += --sysconfdir=/etc/opt/csw

BUILD_ENV   = RCGIMODES=

TEST_SCRIPTS =

REQUIRED_PKGS_CSWgnubatch = CSWcswclassutils CSWfconfig CSWftype2 CSWglib2 CSWgtk2 CSWlibatk CSWlibcairo CSWpango

# Installation
CSWUG = gnubatch:gnubatch:GNUBatch:/var/opt/csw/gnubatch:/bin/bash::
CSWUGD = $(INSTALLISADIR)/opt/csw/etc/pkg/CSW$(GARNAME)

# From src/Makefile
USERBINS	:=	gbch-charge gbch-cichange gbch-cilist gbch-hols gbch-jchange \
			gbch-jdel gbch-jlist gbch-jstat gbch-q gbch-quit gbch-r \
			gbch-rr gbch-start gbch-uchange gbch-ulist gbch-user gbch-var \
			gbch-vlist
# From src/gtk/Makefile
USERBINS	+=	gbch-xq gbch-xr gbch-xuser

# From src/Makefile
NOSETUBINS	:=	gbch-filemon
# From src/gtk/Makefile
NOSETUBINS	+=	gbch-xfilemon
# From src/gtk/Makefile (NOSETUSYSBINS)
NOSETUBINS	+=	bgtksave

# From src/Makefile
SUIDROOTBINS	:=	btsched btexec btpwchk btmdisp xbnetserv
# From src/gtk/Makefile
SUIDROOTBINS	+=	bgtkldsv

SUIDBTBINS	:=	jobdump
TTYGRPBINS	:=	btwrite dosbtwrite

# Covert the strings to something more awk friendly
USERBINS	:=	$(shell echo $(USERBINS)|tr " " "|")
NOSETUBINS	:=	$(shell echo $(NOSETUBINS)|tr " " "|")
SUIDROOTBINS	:=	$(shell echo $(SUIDROOTBINS)|tr " " "|")
SUIDBTBINS	:=	$(shell echo $(SUIDBTBINS)|tr " " "|")
TTYGRPBINS	:=	$(shell echo $(TTYGRPBINS)|tr " " "|")

PROTOTYPE_FILTER  = awk '$$$$3 ~ /\/CSWgnubatch\/cswusergroup$$$$/ { $$$$2 = "cswusergroup" }; \
/$(USERBINS)/{               $$$$4="4755"; $$$$5="gnubatch" } \
/$(NOSETUBINS)/{                           $$$$5="gnubatch" } \
/$(SUIDROOTBINS)/{           $$$$4="4755"; $$$$5="root" } \
/$(SUIDBTBINS)/{             $$$$4="4755"; $$$$5="gnubatch" } \
/$(TTYGRPBINS)/{             $$$$4="2755"; $$$$5="gnubatch" } \
/\/var\/opt\/csw\/gnubatch/{               $$$$5="gnubatch"; $$$$6="gnubatch" } \
{ print }'

SPKG_CLASSES = none cswusergroup

include gar/category.mk

pre-install-modulated:
	mkdir -p $(DESTDIR)/opt/csw/share/gnubatch/help

post-install-modulated:
	@( gmkdir -p $(CSWUGD); echo "$(CSWUG)" > $(CSWUGD)/cswusergroup; )
	@$(MAKECOOKIE)
