TOMBOY_DIR=$(HOME)/.config/tomboy/addins

CopyAs.dll: CopyAs.cs CopyAs.addin.xml CopyAs-Trac.xsl CopyAs-PmWiki.xsl
	gmcs -debug -out:CopyAs.dll -define:DEBUG -target:library -pkg:tomboy-addins -pkg:gtk-sharp-2.0 -r:System.Drawing -r:Mono.Posix CopyAs.cs -resource:CopyAs.addin.xml -resource:CopyAs-Trac.xsl -resource:CopyAs-PmWiki.xsl -resource:CopyAs-MediaWiki.xsl -resource:CopyAs-MoinMoin.xsl -resource:CopyAs-Confluence.xsl

install: CopyAs.dll
	cp CopyAs.dll $(TOMBOY_DIR)

uninstall:
	rm -vf $(TOMBOY_DIR)/CopyAs.dll $(TOMBOY_DIR)/CopyAs-*.xsl

clean:
	rm -vf CopyAs.dll CopyAs.dll.mdb
