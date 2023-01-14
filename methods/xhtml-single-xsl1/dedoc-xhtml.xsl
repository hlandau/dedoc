<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:d="https://www.devever.net/ns/dedoc"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/">
    <h:html lang="en">
      <h:head>
        <h:link rel="stylesheet" href="dedoc-xhtml.css"/>
        <h:title><xsl:apply-templates select="/d:doc/d:docctl/d:title/text()"/></h:title>
      </h:head>
      <h:body>
        <h:div class="toc">
          <h:h2>Table of Contents</h:h2>
          <h:ul>
            <xsl:apply-templates select="node() | @*" mode="toc"/>
          </h:ul>
        </h:div>
        <xsl:copy>
          <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
      </h:body>
    </h:html>
  </xsl:template>

  <xsl:template match="d:sec" mode="toc">
    <h:li><h:a><xsl:choose><xsl:when test="@xml:id"><xsl:attribute name="href">#<xsl:value-of select="@xml:id"/></xsl:attribute></xsl:when><xsl:when test="@secno"><xsl:attribute name="href">#<xsl:value-of select="@secno"/></xsl:attribute></xsl:when></xsl:choose><xsl:apply-templates select="d:hdr" mode="toc"/></h:a>
      <h:ul>
        <xsl:apply-templates select="d:sec" mode="toc"/>
      </h:ul>
    </h:li>
  </xsl:template>

  <xsl:template match="node() | @*" mode="toc">
    <xsl:apply-templates select="node() | @*" mode="toc" />
  </xsl:template>

  <xsl:template match="d:sec/d:hdr" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>
  <xsl:template match="d:sec/d:hdr/d:secno" mode="toc">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="d:sec/d:hdr/d:lint" mode="toc">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="d:sec/d:hdr/d:title" mode="toc">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="d:hdr" mode="hdr">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:sec">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <h:section>
        <xsl:choose><xsl:when test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:when><xsl:when test="@secno"><xsl:attribute name="id"><xsl:value-of select="@secno"/></xsl:attribute></xsl:when></xsl:choose>
        <h:h2><xsl:apply-templates select="d:hdr" mode="hdr"/></h:h2>
        <xsl:apply-templates select="*[local-name() != 'hdr']" />
      </h:section>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:sec/d:sec">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <h:section>
        <xsl:choose><xsl:when test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:when><xsl:when test="@secno"><xsl:attribute name="id"><xsl:value-of select="@secno"/></xsl:attribute></xsl:when></xsl:choose>
        <h:h3><xsl:apply-templates select="d:hdr" mode="hdr"/></h:h3>
        <xsl:apply-templates select="*[local-name() != 'hdr']" />
      </h:section>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:sec/d:sec/d:sec">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <h:section>
        <xsl:choose><xsl:when test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:when><xsl:when test="@secno"><xsl:attribute name="id"><xsl:value-of select="@secno"/></xsl:attribute></xsl:when></xsl:choose>
        <h:h4><xsl:apply-templates select="d:hdr" mode="hdr"/></h:h4>
        <xsl:apply-templates select="*[local-name() != 'hdr']" />
      </h:section>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:sec/d:sec/d:sec/d:sec">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <h:section>
        <xsl:choose><xsl:when test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:when><xsl:when test="@secno"><xsl:attribute name="id"><xsl:value-of select="@secno"/></xsl:attribute></xsl:when></xsl:choose>
        <h:h5><xsl:apply-templates select="d:hdr" mode="hdr"/></h:h5>
        <xsl:apply-templates select="*[local-name() != 'hdr']" />
      </h:section>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:docctl">
    <h:template hidden="">
      <xsl:copy>
        <xsl:apply-templates select="node() | @*"/>
      </xsl:copy>
    </h:template>
  </xsl:template>

  <xsl:template match="d:p">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:p><xsl:apply-templates/></h:p>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="d:listing">
    <xsl:copy><xsl:apply-templates select="@*"/><h:pre><xsl:apply-templates/></h:pre></xsl:copy>
  </xsl:template>

  <xsl:template match="d:tt">
    <xsl:copy><xsl:apply-templates select="@*"/><h:tt><xsl:apply-templates/></h:tt></xsl:copy>
  </xsl:template>

  <xsl:template match="d:ul">
    <xsl:copy><xsl:apply-templates select="@*"/><h:ul><xsl:apply-templates/></h:ul></xsl:copy>
  </xsl:template>
  <xsl:template match="d:ol">
    <xsl:copy><xsl:apply-templates select="@*"/><h:ol><xsl:apply-templates/></h:ol></xsl:copy>
  </xsl:template>
  <xsl:template match="d:li">
    <xsl:copy><xsl:apply-templates select="@*"/><h:li><xsl:apply-templates/></h:li></xsl:copy>
  </xsl:template>

  <xsl:template match="d:dict">
    <xsl:copy><xsl:apply-templates select="@*"/><h:dl><xsl:apply-templates/></h:dl></xsl:copy>
  </xsl:template>

  <xsl:template match="d:dice">
    <xsl:copy><xsl:apply-templates select="@*"/><xsl:apply-templates/></xsl:copy>
  </xsl:template>

  <xsl:template match="d:dick">
    <xsl:copy><xsl:apply-templates select="@*"/><h:dt><xsl:apply-templates/></h:dt></xsl:copy>
  </xsl:template>

  <xsl:template match="d:dicb">
    <xsl:copy><xsl:apply-templates select="@*"/><h:dd><xsl:apply-templates/></h:dd></xsl:copy>
  </xsl:template>

  <xsl:template match="d:em">
    <xsl:copy><xsl:apply-templates select="@*"/><h:em><xsl:apply-templates/></h:em></xsl:copy>
  </xsl:template>

  <xsl:template match="d:figure">
    <xsl:copy><xsl:apply-templates select="@*"/><h:figure><h:figcaption><xsl:apply-templates select="d:hdr"/></h:figcaption><xsl:apply-templates select="*[local-name() != 'hdr']"/></h:figure></xsl:copy>
  </xsl:template>

  <!-- Default Passthrough -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
