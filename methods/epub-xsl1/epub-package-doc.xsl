<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:d="https://www.devever.net/ns/dedoc"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:h="http://www.w3.org/1999/xhtml"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/">
    <opf:package version="2.0" xml:lang="en" unique-identifier="uuid">
      <metadata>
        <!--dc:identifier id="uuid" opf:scheme="uuid">...</dc:identifier-->

        <xsl:if test="//d:doc/@xml:lang">
          <dc:language><xsl:value-of select="//d:doc/@xml:lang"/></dc:language>
        </xsl:if>

        <dc:title><xsl:value-of select="/h:html/h:head/h:title"/></dc:title>
        <!--<dc:creator>...</dc:creator>

        <dc:description>...</dc:description>

        <meta property="dcterms:modified">...</meta>
        <dc:date>...</dc:date>-->
      </metadata>
      <manifest>
        <item id="main" href="main.xhtml" media-type="application/xhtml+xml"/>
        <item href="dedoc-xhtml.css" media-type="text/css"/>
      </manifest>
      <spine>
        <itemref idref="main"/>
      </spine>
    </opf:package>
  </xsl:template>

</xsl:stylesheet>
