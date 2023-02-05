<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:d="https://www.devever.net/ns/dedoc"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="1.0">

  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="processing-instruction('xml-stylesheet')"/>

  <!-- Bookmark Generation -->
  <xsl:template match="d:sec" mode="bookmark">
    <fo:bookmark>
      <xsl:choose>
        <xsl:when test="@xml:id">
          <xsl:attribute name="internal-destination">
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@secno">
          <xsl:attribute name="internal-destination">
            <xsl:value-of select="@secno"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <fo:bookmark-title><xsl:value-of select="d:hdr"/></fo:bookmark-title>
      <xsl:apply-templates select="d:sec" mode="bookmark"/>
    </fo:bookmark>
  </xsl:template>

  <!-- Table of Contents -->
  <xsl:template match="d:sec" mode="toc">
    <fo:block margin-left="5mm">
      <fo:block text-align-last="justify">
        <fo:basic-link>
          <xsl:choose>
            <xsl:when test="@xml:id">
              <xsl:attribute name="internal-destination">
                <xsl:value-of select="@xml:id"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@secno">
              <xsl:attribute name="internal-destination">
                <xsl:value-of select="@secno"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select="d:hdr" mode="toc"/>
          <fo:leader leader-pattern="dots"/>
          <fo:page-number-citation>
            <xsl:choose>
              <xsl:when test="@xml:id">
                <xsl:attribute name="ref-id">
                  <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="@secno">
                <xsl:attribute name="ref-id">
                  <xsl:value-of select="@secno"/>
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
          </fo:page-number-citation>
        </fo:basic-link>
      </fo:block>
      <xsl:apply-templates select="d:sec" mode="toc"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="node() | @*" mode="toc">
    <xsl:apply-templates select="node() | @*" mode="toc"/>
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

  <!-- Document Superstructure -->
  <xsl:template match="/d:doc">
    <fo:root xml:lang="en">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="PageMaster.Content-left">
          <fo:region-body margin-left="6.5mm" margin-right="6.5mm" margin-top="15mm" margin-bottom="6.5mm"/>
          <fo:region-before region-name="Content-left-before" extent="5mm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="PageMaster.Content-right">
          <fo:region-body margin-left="6.5mm" margin-right="6.5mm" margin-top="15mm" margin-bottom="6.5mm"/>
          <fo:region-before region-name="Content-right-before" extent="5mm"/>
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="PageMaster.Content">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference master-reference="PageMaster.Content-left" odd-or-even="even"/>
            <fo:conditional-page-master-reference master-reference="PageMaster.Content-right" odd-or-even="odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:simple-page-master master-name="Normal.Content-left" page-height="297mm" page-width="210mm"
                               margin-top="10mm" margin-bottom="20mm" margin-left="25mm" margin-right="25mm">
          <fo:region-body margin-top="10mm"/>
          <fo:region-before extent="10mm"/>
          <fo:region-after margin="15mm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
              <dc:title><xsl:value-of select="d:docctl/d:title"/></dc:title>
              <dc:creator>...</dc:creator>
              <dc:description>...</dc:description>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
      </fo:declarations>

      <fo:bookmark-tree>
        <xsl:apply-templates match="//d:sec" mode="bookmark"/>
      </fo:bookmark-tree>

      <fo:page-sequence master-reference="PageMaster.Content" force-page-count="odd">
        <fo:title><xsl:apply-templates select="d:docctl/d:title"/></fo:title>
        <fo:static-content flow-name="Content-left-before">
          <fo:block font-size="10pt" margin-left="6.5mm" margin-right="6.5mm" margin-top="6.5mm">
            <fo:table>
              <fo:table-column column-number="1" column-width="10mm"/>
              <fo:table-column column-number="2"/>
              <fo:table-body text-align="start" start-indent="0" end-indent="0">
                <fo:table-row>
                  <fo:table-cell text-align="left">
                    <fo:block><fo:page-number/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <fo:block><xsl:apply-templates select="//d:doc/d:docctl/d:title/node()"/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="Content-right-before">
          <fo:block font-size="10pt" margin-left="6.5mm" margin-right="6.5mm" margin-top="6.5mm">
            <fo:table>
              <fo:table-column column-number="1"/>
              <fo:table-column column-number="2" column-width="10mm"/>
              <fo:table-body text-align="start" start-indent="0" end-indent="0">
                <fo:table-row>
                  <fo:table-cell text-align="left">
                    <fo:block><xsl:apply-templates select="//d:doc/d:docctl/d:title/node()"/></fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <fo:block><fo:page-number/></fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
          <fo:block font-family="Helvetica" font-size="10pt">
            <fo:block break-before="page">
              <fo:block font-weight="bold">
                Table of Contents
              </fo:block>
              <xsl:apply-templates mode="toc"/>
            </fo:block>
            <fo:block break-before="page">
              <xsl:apply-templates/>
            </fo:block>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="d:docctl"/>

  <!-- Structural Constructs: Sections -->
  <xsl:template match="d:sec">
    <fo:block>
      <xsl:attribute name="id"><xsl:choose><xsl:when test="@xml:id"><xsl:value-of select="@xml:id"/></xsl:when><xsl:when test="@secno"><xsl:value-of select="@secno"/></xsl:when></xsl:choose></xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:sec/d:hdr">
    <fo:block font-weight="bold" margin-top="2.5mm">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Block Constructs: Paragraph -->
  <xsl:template match="d:p">
    <fo:block text-align="justify" margin-left="0" margin-top="1.5mm" margin-bottom="1.5mm"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <!-- Block Constructs: Unordered List -->
  <xsl:template match="d:ul">
    <fo:list-block provisional-distance-between-starts="15mm" provisional-label-separation="5mm" margin-bottom="2mm">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="d:ul/d:li">
    <fo:list-item>
      <fo:list-item-label start-indent="5mm" end-indent="label-end()">
        <fo:block>— </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Block Constructs: Ordered List -->
  <xsl:template match="d:ol">
    <fo:list-block margin-bottom="2mm">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="d:ol/d:li">
    <fo:list-item>
      <fo:list-item-label start-indent="5mm" end-indent="label-end()">
        <fo:block><xsl:number format="1."/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Block Constructs: Dictionary -->
  <xsl:template match="d:dict">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:dice">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:dick">
    <fo:block font-weight="bold" margin-left="5mm">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="d:dicb">
    <fo:block margin-left="7.5mm">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Block Constructs: Listing -->
  <xsl:template match="d:listing">
    <fo:block font-family="Courier" linefeed-treatment="preserve" white-space-treatment="preserve" white-space-collapse="false"
              margin-left="5mm">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Inline Constructs: em -->
  <xsl:template match="d:em">
    <fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
  </xsl:template>

  <!-- Inline Constructs: tt -->
  <xsl:template match="d:tt">
    <fo:inline font-family="Courier"><xsl:apply-templates/></fo:inline>
  </xsl:template>

</xsl:stylesheet>
