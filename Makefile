NAME=kafka
VERSION=0.8.1.1
DIST=$(NAME)-$(VERSION).tbz2
DEST=$(shell pwd)
SOURCEDIR=$(DEST)
BUILDDIR=$(DEST)
SRCRPMDIR=$(DEST)
RPMDIR=$(DEST)
RPM_WITH_DIRS = rpmbuild --define "_sourcedir $(SOURCEDIR)" \
            --define "_builddir $(BUILDDIR)" \
            --define "_srcrpmdir $(SRCRPMDIR)" \
            --define "_rpmdir $(RPMDIR)"
dist:
	@printf " * criando pacote ... "
	@date > dist.log
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@mkdir $(DEST)/$(NAME)-$(VERSION)
	wget -c http://ftp.unicamp.br/pub/apache/kafka/0.8.1.1/kafka_2.9.2-0.8.1.1.tgz
	@tar -vzxf kafka_2.9.2-0.8.1.1.tgz
	@mv kafka_2.9.2-0.8.1.1 $(DEST)/$(NAME)-$(VERSION)/kafka
	@cp -R service/* $(DEST)/$(NAME)-$(VERSION)/
	@(cd $(DEST) ; tar  -jcvf $(DEST)/$(DIST) $(TAR_EXCLUDE) $(NAME)-$(VERSION))  >> dist.log 2>&1
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@printf "feito.\n"

prep: dist
	$(RPM_WITH_DIRS) -bp $(NAME).spec

rpm: dist
	$(RPM_WITH_DIRS) -ba $(NAME).spec

srpm: dist
	$(RPM_WITH_DIRS) -bs $(NAME).spec

clean:
	@printf " * limpando ('%s')\n" "$(DEST)/$(DIST)"
	@rm -f dist.log $(DEST)/$(DIST)
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@rm -rf noarch i386 i686 x86_64
	@rm -f *.src.rpm
