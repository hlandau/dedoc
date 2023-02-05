<?xml version="1.0" encoding="UTF-8"?>
<!--
  This XSL stylesheet allows a RNG XML schema file to be displayed
  in human readable form, including in browsers directly using
  a browser's XSLT support.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:r="http://relaxng.org/ns/structure/1.0"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/">
    <h:html lang="en" xml:lang="en">
      <h:head>
        <h:title>RELAX NG Schema for <xsl:value-of select="/r:grammar/@ns"/></h:title>
        <style type="text/css"><![CDATA[

        ]]></style>
      </h:head>
      <h:body>
        <xsl:apply-templates/>
      </h:body>
    </h:html>
  </xsl:template>

  <xsl:template match="/r:grammar">
    <xsl:copy>
      <h:h1>RELAX NG Schema for <h:a><xsl:attribute name="href"><xsl:value-of select="@ns"/></xsl:attribute><xsl:value-of select="@ns"/></h:a></h:h1>
      <h:p>This document is a RELAX NG schema file.</h:p>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:define">
    <xsl:copy>
      <h:section>
        <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
        <h:h2><xsl:value-of select="@name"/></h:h2>
        <xsl:apply-templates/>
      </h:section>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="nsmap">
    <xsl:param name="ns"/>
    <xsl:choose>
      <xsl:when test="$ns='http://www.w3.org/1998/Math/MathML'">mml:</xsl:when>
      <xsl:when test="$ns='http://www.w3.org/1999/xlink'">xlink:</xsl:when>
      <xsl:otherwise>???:</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ename">
    <xsl:choose>
      <xsl:when test="r:anyName">*</xsl:when>
      <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
      <xsl:when test="r:nsName"><xsl:call-template name="nsmap"><xsl:with-param name="ns" select="r:nsName/@ns"/></xsl:call-template>*</xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="nsmap"><xsl:with-param name="ns" select="r:name/@ns"/></xsl:call-template>
        <xsl:apply-templates select="r:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:element">
    <xsl:copy>
      an element “<xsl:call-template name="ename"/>” containing:
      <h:ul>
        <xsl:for-each select="*[local-name() != 'name' and local-name() != 'anyName' and local-name() != 'nsName']">
          <h:li><xsl:apply-templates select="."/></h:li>
        </xsl:for-each>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:attribute">
    <xsl:copy>
      an attribute “<xsl:call-template name="ename"/>” containing:
      <h:ul>
        <xsl:for-each select="*[local-name() != 'name' and local-name() != 'anyName' and local-name() != 'nsName']">
          <h:li><xsl:apply-templates select="."/></h:li>
        </xsl:for-each>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:choice">
    <xsl:copy>
      one of the following:
      <h:ul>
        <xsl:for-each select="*">
          <h:li><xsl:apply-templates select="."/></h:li>
        </xsl:for-each>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:zeroOrMore">
    <xsl:copy>
      zero or more of:
      <h:ul>
        <h:li><xsl:apply-templates/></h:li>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:interleave">
    <xsl:copy>
      interleaving of:
      <h:ul>
        <h:li><xsl:apply-templates/></h:li>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:optional">
    <xsl:copy>
      optionally:
      <h:ul>
        <h:li><xsl:apply-templates/></h:li>
      </h:ul>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:value">
    <xsl:copy>“<h:code><xsl:apply-templates/></h:code>”</xsl:copy>
  </xsl:template>

  <xsl:template match="r:data">
    <xsl:copy>data of type <h:tt><xsl:value-of select="@type"/></h:tt></xsl:copy>
  </xsl:template>

  <xsl:template match="r:ref">
    <xsl:copy>
      <h:a><xsl:attribute name="href">#<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></h:a>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:text">
    <xsl:copy>text</xsl:copy>
  </xsl:template>

  <xsl:template match="node() | @*"><xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy></xsl:template>

</xsl:stylesheet>
