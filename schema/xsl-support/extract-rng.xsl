<?xml version="1.0" encoding="UTF-8"?>
<!--
  This XSL stylesheet extracts a RNG schema in XML form from an XML input.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:r="http://relaxng.org/ns/structure/1.0"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">href="rng.xsl" type="text/xsl"</xsl:processing-instruction>
    <r:grammar ns="https://www.devever.net/ns/dedoc" datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
      <xsl:apply-templates select="//r:start"/>
      <xsl:apply-templates select="//r:define"/>
    </r:grammar>
  </xsl:template>

  <xsl:template match="//r:*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>

  <xsl:template match="h:span[contains(@class,'rng-lint')]"/>

  <xsl:template match="@*">
    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
  </xsl:template>
</xsl:stylesheet>
