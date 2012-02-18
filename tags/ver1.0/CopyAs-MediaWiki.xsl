<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tomboy="http://beatniksoftware.com/tomboy"
		xmlns:size="http://beatniksoftware.com/tomboy/size"
		xmlns:link="http://beatniksoftware.com/tomboy/link"
                version='1.0'>

<!--
        This xsl file is written for Tomboy Notes for use with the Copy-As plugin.
        It extends support to MediaWiki format conversions, and works with the
        Tomboy-LaTeX plugin.
        
        References:
        - Tomboy Notes http://projects.gnome.org/tomboy/
        - Copy-As plugin http://code.google.com/p/tomboy-copy-as/
        - Tomboy-LaTeX plugin http://www.reitwiessner.de/programs/tomboy-latex.html

        Released under GNU Lesser GPL, 2010, Daivd Gaden. Based on CopyAs-Trac.xsl.
-->

<xsl:output method="text" indent="no" />
<!--xsl:preserve-space elements="*" /-->

<xsl:param name="font" />
<xsl:param name="export-linked" />
<xsl:param name="export-linked-all" />
<xsl:param name="root-note" />

<xsl:param name="newline" select="'&#xA;'" />

<xsl:variable name="indent" select=""/>
<xsl:variable name="inhdr" select="0"/>

<xsl:template match="/"><xsl:apply-templates select="tomboy:note"/></xsl:template>

<xsl:template match="text()"><xsl:param name="inhdr" select="0"/><xsl:call-template name="softbreak"><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:template>

<xsl:template name="softbreak">
    <xsl:param name="inhdr" select="0"/>
    <xsl:param name="txt" select="."/>
    <xsl:variable name="temp" select="concat($txt, '')"/>
    <xsl:variable name="txtbit" select="substring($temp,1,1)"/>
    <xsl:variable name="txtbit2" select="substring($temp,2,1)"/>
    <xsl:choose>
        <xsl:when test="contains($txtbit,'\')">
            <xsl:choose>

<xsl:when test="contains($txtbit2,'[')">&lt;math&gt;<xsl:if test="string-length($txt)&gt;2"><xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring($temp,3)"/><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:if></xsl:when>

<xsl:when test="contains($txtbit2,']')">&lt;/math&gt;<xsl:if test="string-length($txt)&gt;2"><xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring($temp,3)"/><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:if></xsl:when>

<xsl:otherwise><xsl:value-of select="$txtbit"/><xsl:if test="string-length($txt)&gt;1"><xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring($temp,2)"/><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:if></xsl:otherwise>

            </xsl:choose>

        </xsl:when>
<xsl:when test="contains($txtbit, '&#xA;')"><xsl:if test="$inhdr=0"><xsl:value-of select="$txtbit"/></xsl:if><xsl:if test="string-length($txt)&gt;1"><xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring($temp,2)"/><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:if></xsl:when>
<xsl:otherwise><xsl:value-of select="$txtbit"/><xsl:if test="string-length($txt)&gt;1"><xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring($temp,2)"/><xsl:with-param name="inhdr" select="$inhdr"/></xsl:call-template></xsl:if></xsl:otherwise>

    </xsl:choose>

</xsl:template>

<xsl:template match="tomboy:note"><xsl:apply-templates select="tomboy:text"/></xsl:template>

<!--<xsl:template match="tomboy:text">== <xsl:value-of select="/tomboy:note/tomboy:title"/> ==
<xsl:apply-templates select="node()" />
</xsl:template>-->

<xsl:template match="tomboy:note/tomboy:text/*[1]/text()[1]">== <xsl:value-of select="substring-before(., $newline)"/> ==
<xsl:call-template name="softbreak"><xsl:with-param name="txt" select="substring-after(., $newline)"/>
</xsl:call-template></xsl:template>

<xsl:template match="tomboy:bold">'''<xsl:apply-templates select="node()"/>'''</xsl:template>

<xsl:template match="tomboy:italic">''<xsl:apply-templates select="node()"/>''</xsl:template>

<xsl:template match="tomboy:strikethrough">&lt;s&gt;<xsl:apply-templates select="node()"/>&lt;/s&gt;</xsl:template>

<xsl:template match="tomboy:highlight">'''<xsl:apply-templates select="node()"/>'''</xsl:template>

<xsl:template match="size:small">
==== <xsl:apply-templates select="node()"><xsl:with-param name="inhdr" select="1"/></xsl:apply-templates> ====
</xsl:template>

<xsl:template match="size:large">
=== <xsl:apply-templates select="node()"><xsl:with-param name="inhdr" select="1"/></xsl:apply-templates> ===
</xsl:template>

<xsl:template match="size:huge">
== <xsl:apply-templates select="node()"><xsl:with-param name="inhdr" select="1"/></xsl:apply-templates> ==
</xsl:template>

<xsl:template match="link:url">[<xsl:value-of select="node()"/>]</xsl:template>

<xsl:template match="link:internal">[[<xsl:value-of select="node()"/>]]</xsl:template>


<xsl:template match="tomboy:list">
<xsl:param name="indent"/>
<xsl:param name="inhdr" select="1"/>
<xsl:apply-templates select="tomboy:list-item">
	<xsl:with-param name="indent" select="$indent"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="tomboy:list-item">
<xsl:param name="indent"/>
<xsl:value-of select="'&#xA;'"/>
<xsl:value-of select="$indent"/>*<xsl:apply-templates select="node()"><xsl:with-param name="indent" select="concat($indent,'*')"/><xsl:with-param name="inhdr" select="1"/></xsl:apply-templates>
</xsl:template>

<!-- FixedWidth.dll Plugin -->
<xsl:template match="tomboy:monospace">&lt;tt&gt;<xsl:apply-templates select="node()"/>&lt;/tt&gt;</xsl:template>

</xsl:stylesheet>

