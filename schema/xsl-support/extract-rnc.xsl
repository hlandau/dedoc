<?xml version="1.0" encoding="UTF-8"?>
<!--
  This XSL stylesheet extracts a RNG schema in RNC (compact) form
  from an XML input containing hybrid RNG-RNC elements.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:r="http://relaxng.org/ns/structure/1.0"
    version="1.0">
  <xsl:output method="text" encoding="UTF-8" indent="no"/>
  <xsl:template match="/">default namespace dedoc = "https://www.devever.net/ns/dedoc"
namespace bib = "https://www.devever.net/ns/bib"
namespace mml = "http://www.w3.org/1998/Math/MathML"
namespace xlink = "http://www.w3.org/1999/xlink"
namespace local = ""
<xsl:apply-templates/></xsl:template>
  <xsl:template match="r:start" xml:space="preserve"><xsl:apply-templates mode="rng"/>
</xsl:template>
  <xsl:template match="r:define" xml:space="preserve"><xsl:apply-templates mode="rng"/>
</xsl:template>
  <xsl:template match="*" mode="rng"><xsl:apply-templates mode="rng"/></xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
