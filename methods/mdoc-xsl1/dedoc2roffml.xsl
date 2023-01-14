<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="https://www.devever.net/ns/dedoc"
    xmlns:f="https://www.devever.net/ns/roff"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/d:sec">
    <f:roff><!--
    --><f:r t="Dd">$Mdocdate: May 26 2019 $</f:r><!--
    --><f:r t="Dt" xml:space="preserve"><xsl:apply-templates select="d:hdr/d:title"/> <xsl:value-of select="@man-section"/></f:r><!--
    --><f:r t="Os"/><!--
    --><f:r t="Sh">NAME</f:r><!--
    --><f:r t="Nm"><xsl:apply-templates select="d:hdr/d:title"/></f:r><!--
    --><f:r t="Nd">format manual pages</f:r><!--
    --><xsl:apply-templates/></f:roff>
  </xsl:template>

  <xsl:template match="d:sec">
    <f:r t="Sh"><xsl:apply-templates select="d:hdr/d:title"/></f:r>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:p"><f:r t="Pp"/><xsl:apply-templates/></xsl:template>

  <xsl:template match="d:hdr"/>

</xsl:stylesheet>
