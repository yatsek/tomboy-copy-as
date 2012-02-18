TOMBOY_DIR=$(HOME)/.tomboy/addins

CopyAs.dll: CopyAs.cs CopyAs.addin.xml CopyAs-Trac.xsl CopyAs-PmWiki.xsl
	gmcs -debug -out:CopyAs.dll -define:DEBUG -target:library -pkg:tomboy-addins -r:Mono.Posix CopyAs.cs -resource:CopyAs.addin.xml -resource:CopyAs-Trac.xsl -resource:CopyAs-PmWiki.xsl

install: CopyAs.dll
	cp CopyAs.dll $(TOMBOY_DIR)

uninstall:
	rm -vf $(TOMBOY_DIR)/CopyAs.dll $(TOMBOY_DIR)/CopyAs-*.xsl

clean:
	rm -vf CopyAs.dll CopyAs.dll.mdb
