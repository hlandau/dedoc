<?xml version="1.0" encoding="UTF-8"?>
<!--

  XSL stylesheet used to postprocess the initial XHTML output of the
  dedoc.scm script into the final XHTML output.

  The initial XHTML output (dedoc-pre.xhtml):
    - contains RNG XML and XHTML only

  This transform
    - adds RNC annotation to the RNG XML, creating hybrid RNG-RNC XML
    - generates a table of contents

-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:r="http://relaxng.org/ns/structure/1.0"
    version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <!-- Transform inline RNG to RNC -->
  <xsl:template match="r:define">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:div class="rng-define">
        <xsl:attribute name="id">def.<xsl:value-of select="@name"/></xsl:attribute>
        <h:span class="rng-define-name rng-lint"><xsl:value-of select="@name"/></h:span><h:span class="rng-lint"> = </h:span><xsl:apply-templates/>
        <h:span class="rng-lint" xml:space="preserve">&#10;</h:span>
      </h:div>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:ref">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-ref rng-lint"><h:a><xsl:attribute name="href">#def.<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></h:a></h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:zeroOrMore">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-zeroOrMore">
        <xsl:apply-templates/><h:span class="rng-lint">*</h:span>
      </h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:interleave">
    <xsl:param name="indent" select="''"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-interleave">
        <xsl:for-each select="node()">
          <xsl:apply-templates select="."><xsl:with-param name="indent" select="concat($indent, '  ')"/></xsl:apply-templates>
          <xsl:if test="position() != last()"><h:span class="rng-lint"> &amp;
<xsl:value-of select="$indent"/></h:span></xsl:if>
        </xsl:for-each>
      </h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:choice">
    <xsl:param name="indent" select="''"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-choice">
        <h:span class="rng-lint">(</h:span>
        <xsl:for-each select="node()">
          <xsl:apply-templates select="."><xsl:with-param name="indent" select="concat($indent, '  ')"/></xsl:apply-templates>
          <xsl:if test="position() != last()"><h:span class="rng-lint"> | </h:span></xsl:if>
        </xsl:for-each>
        <h:span class="rng-lint">)</h:span>
      </h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="nsmap">
    <xsl:param name="ns"/>
    <xsl:choose>
      <xsl:when test="$ns='http://www.w3.org/1998/Math/MathML'">mml:</xsl:when>
      <xsl:when test="$ns='http://www.w3.org/1999/xlink'">xlink:</xsl:when>
      <xsl:when test="$ns='https://www.devever.net/ns/dedoc'">dedoc:</xsl:when>
      <xsl:when test="$ns=''">local:</xsl:when>
      <xsl:otherwise>???:</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ename">
    <xsl:choose>
      <xsl:when test="r:anyName"><xsl:apply-templates select="r:anyName"/></xsl:when>
      <xsl:when test="@name"><h:span class="rng-lint"><xsl:value-of select="@name"/></h:span></xsl:when>
      <xsl:when test="r:nsName"><xsl:apply-templates select="r:nsName"/></xsl:when>
      <xsl:when test="r:choice"><xsl:apply-templates select="r:choice"/></xsl:when>
      <xsl:otherwise>
        <h:span class="rng-lint"><xsl:call-template name="nsmap"><xsl:with-param name="ns" select="r:name/@ns"/></xsl:call-template></h:span>
        <xsl:apply-templates select="r:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:anyName"><xsl:copy><h:span class="rng-lint">*</h:span><xsl:apply-templates/></xsl:copy></xsl:template>
  <xsl:template match="r:nsName"><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-lint"><xsl:call-template name="nsmap"><xsl:with-param name="ns" select="@ns"/></xsl:call-template>*</h:span><xsl:apply-templates/></xsl:copy></xsl:template>
  <xsl:template match="r:except"><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-lint"> - </h:span><xsl:call-template name="ename"/></xsl:copy></xsl:template>

  <xsl:template match="r:element">
    <xsl:param name="indent" select="''"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-element">
        <h:span class="rng-lint">element </h:span><xsl:call-template name="ename"/><h:span class="rng-lint"> {
</h:span>
        <xsl:for-each select="node()[local-name() != 'name' and local-name() != 'nsName' and local-name() != 'anyName']">
          <xsl:value-of select="concat($indent, '  ')"/><xsl:apply-templates select="."><xsl:with-param name="indent" select="concat($indent, '  ')"/></xsl:apply-templates>
          <xsl:if test="position() != last()"><h:span class="rng-lint">,
</h:span></xsl:if>
        </xsl:for-each>
        <h:span class="rng-lint" xml:space="preserve">
<xsl:value-of select="$indent"/>}</h:span></h:span></xsl:copy>
  </xsl:template>

  <xsl:template match="r:attribute">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-attribute">
        <h:span class="rng-lint">attribute </h:span><xsl:call-template name="ename"/><h:span class="rng-lint"> {</h:span>
        <xsl:apply-templates select="node()[local-name() != 'name' and local-name() != 'nsName' and local-name() != 'anyName']"/>
        <h:span class="rng-lint">}</h:span>
      </h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:data">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <h:span class="rng-data">
        <h:span class="rng-lint">xsd:<xsl:value-of select="@type"/></h:span>
      </h:span>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="r:optional">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/><h:span class="rng-lint">?</h:span></xsl:copy>
  </xsl:template>

  <xsl:template match="r:value"><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-lint">"</h:span><xsl:apply-templates/><h:span class="rng-lint">"</h:span></xsl:copy></xsl:template>

  <xsl:template match="r:empty"><xsl:param name="indent" select="''"/><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-lint">empty</h:span><xsl:apply-templates/></xsl:copy></xsl:template>

  <xsl:template match="r:text"><xsl:param name="indent" select="''"/><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-lint">text</h:span><xsl:apply-templates/></xsl:copy></xsl:template>

  <xsl:template match="r:start"><xsl:copy><xsl:apply-templates select="@*"/><h:span class="rng-start"><h:span class="rng-lint">start = </h:span><xsl:apply-templates/></h:span></xsl:copy></xsl:template>

  <!-- Generate TOC -->
  <xsl:template match="h:body">
    <xsl:copy>
      <xsl:apply-templates select="h:h1"/>
      <h:div class="toc">
        <h:h2>Table of Contents</h:h2>
        <h:ul>
          <xsl:apply-templates select="h:section" mode="toc"/>
        </h:ul>
      </h:div>
      <xsl:apply-templates select="*[local-name() != 'h1']"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="h:section" mode="toc">
    <h:li>
      <xsl:apply-templates select="(h:h2 | h:h3 | h:h4 | h:h5)" mode="toc"/>
      <h:ul>
        <xsl:apply-templates select="h:section" mode="toc"/>
      </h:ul>
    </h:li>
  </xsl:template>

  <xsl:template match="h:h2 | h:h3 | h:h4 | h:h5" mode="toc">
    <h:a><xsl:if test="../@id"><xsl:attribute name="href">#<xsl:value-of select="../@id"/></xsl:attribute></xsl:if><xsl:apply-templates/></h:a>
  </xsl:template>

  <!-- Default Passthrough -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
