man_MANS = hello.1
BUILT_SOURCES = hello.1.html

$(BUILT_SOURCES):hello.1
	man2html hello.1 > hello.1.html

CLEANFILES: *.o $(BUILT_SOURCES)
