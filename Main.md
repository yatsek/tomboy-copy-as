# Introduction #

Tomboy Copy As is an add-in that let you copy a note to the clipboard in the format of some common wiki systems - currently Trac and PmWiki.


# Installation #

**Download the CopyAs-x.x.dll from the Downloads tab** Copy it into the .config/tomboy/addins directory in your home directory
**rename it to just CopyAs.dll** Restart Tomboy

# Usage #

In a fresh install, you have one new menu Copy As in the Tool menu in each Note window.
Th Copy As menu contains the two sub menus Trac and PmWiki. Select any of the menus to copy in the selected format to the clipboard. Then open your wiki page and paste the text there.

# Edit or Create your own copy format #

Wen you installed CopyAs add-in it created the files CopyAs-Trac.xsl and CopyAs-PmWiki.xsl to .tomboy/addins. You can edit these files, add new ones with other names for Trac and PmWiki. You can delete files, but if you delete all of them the initial files will be recreated there.