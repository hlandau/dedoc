<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="https://www.devever.net/ns/dedoc"
    xmlns:t="https://www.devever.net/ns/dtexml"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/">
    <t:dtexml>
      <t:cmd name="documentclass"><t:oarg>a4paper</t:oarg><t:marg>article</t:marg></t:cmd>
      <t:env name="document">
        <xsl:apply-templates select="/d:doc/d:docbody" />
      </t:env>
    </t:dtexml>
  </xsl:template>

  <xsl:template match="d:docctl"/>

  <xsl:template match="d:sec/d:sec/d:sec">
    <t:cmd name="subsubsection"><t:marg><xsl:apply-templates select="d:hdr/d:title"/></t:marg></t:cmd>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="d:sec/d:sec">
    <t:cmd name="subsection"><t:marg><xsl:apply-templates select="d:hdr/d:title"/></t:marg></t:cmd>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="d:sec">
    <t:cmd name="section"><t:marg><xsl:apply-templates select="d:hdr/d:title"/></t:marg></t:cmd>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:hdr"/>

  <xsl:template match="d:p" xml:space="preserve"><xsl:apply-templates/>
  
</xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
