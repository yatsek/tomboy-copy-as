<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tomboy="http://beatniksoftware.com/tomboy"
		xmlns:size="http://beatniksoftware.com/tomboy/size"
		xmlns:link="http://beatniksoftware.com/tomboy/link"
                version='1.0'>

<xsl:output method="text" indent="no" />
<!--xsl:preserve-space elements="*" /-->

<xsl:param name="font" />
<xsl:param name="export-linked" />
<xsl:param name="export-linked-all" />
<xsl:param name="root-note" />

<xsl:param name="newline" select="'&#xA;'" />

<xsl:variable name="indent" select=""/>

<xsl:template match="/">
	<xsl:apply-templates select="tomboy:note"/>
</xsl:template>

<xsl:template match="text()">
   <xsl:call-template name="softbreak"/>
</xsl:template>

<xsl:template name="softbreak">
	<xsl:param name="text" select="."/>
	<xsl:choose>
		<xsl:when test="contains($text, '&#x2028;')">
			<xsl:value-of select="substring-before($text, '&#x2028;')"/>
			<xsl:value-of select="'\\&#xA;'"/>
			<xsl:call-template name="softbreak">
				<xsl:with-param name="text" select="substring-after($text, '&#x2028;')"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains($text, '&#xA;&#xA;')">
			<xsl:value-of select="substring-before($text, '&#xA;&#xA;')"/>
			<xsl:value-of select="'&#xA;&#xA;'"/>
			<xsl:call-template name="softbreak">
				<xsl:with-param name="text" select="substring-after($text, '&#xA;&#xA;')"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains($text, '&#xA;')">
			<xsl:value-of select="substring-before($text, '&#xA;')"/>\\&#xA;<xsl:call-template name="softbreak">
				<xsl:with-param name="text" select="substring-after($text, '&#xA;')"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tomboy:note">
<xsl:apply-templates select="tomboy:text"/>
</xsl:template>

<xsl:template match="tomboy:text">
<xsl:apply-templates select="node()" />
</xsl:template>

<xsl:template match="tomboy:note/tomboy:text/*[1]/text()[1]">
!<xsl:value-of select="substring-before(., $newline)"/>
<xsl:value-of select="substring-after(., $newline)"/>
</xsl:template>

<xsl:template match="tomboy:bold">'''<xsl:apply-templates select="node()"/>'''</xsl:template>

<xsl:template match="tomboy:italic">''<xsl:apply-templates select="node()"/>''</xsl:template>

<xsl:template match="tomboy:strikethrough">{-<xsl:apply-templates select="node()"/>-}</xsl:template>

<xsl:template match="tomboy:highlight">'''<xsl:apply-templates select="node()"/>'''</xsl:template>

<xsl:template match="size:small">[-<xsl:apply-templates select="node()"/>-]</xsl:template>

<xsl:template match="size:large">[+<xsl:apply-templates select="node()"/>+]</xsl:template>

<xsl:template match="size:huge">[++<xsl:apply-templates select="node()"/>++]</xsl:template>

<xsl:template match="link:url">[[<xsl:value-of select="node()"/>]]</xsl:template>

<xsl:template match="tomboy:list">
<xsl:param name="indent"/>
<xsl:apply-templates select="tomboy:list-item">
	<xsl:with-param name="indent" select="$indent"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="tomboy:list-item">
<xsl:param name="indent"/>
<xsl:value-of select="'&#xA;'"/>
<xsl:value-of select="$indent"/>* <xsl:apply-templates select="node()"><xsl:with-param name="indent" select="concat($indent,'  ')"/></xsl:apply-templates>
</xsl:template>

<!-- FixedWidth.dll Plugin -->
<xsl:template match="tomboy:monospace">
@@<xsl:apply-templates select="node()"/>@@
</xsl:template>

</xsl:stylesheet>

