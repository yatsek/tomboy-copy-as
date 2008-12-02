TOMBOY_DIR=$(HOME)/.tomboy/addins

GetTracText.dll: GetTracText.cs GetTracText.addin.xml
	gmcs -debug -out:GetTracText.dll -define:DEBUG -target:library -pkg:tomboy-addins -r:Mono.Posix GetTracText.cs -resource:GetTracText.addin.xml -resource:GetTracText.xsl

install: GetTracText.dll
	cp GetTracText.dll $(TOMBOY_DIR)

uninstall:
	rm -vf $(TOMBOY_DIR)/GetTracText.dll

clean:
	rm -vf GetTracText.dll GetTracText.dll.mdb
