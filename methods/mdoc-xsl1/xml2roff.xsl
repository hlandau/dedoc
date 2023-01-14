<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="https://www.devever.net/ns/roff"
    version="1.0">
  <xsl:output method="text" encoding="UTF-8" indent="no"/>

  <xsl:template match="/f:roff" xml:space="preserve"><xsl:for-each select="* | text()"><xsl:apply-templates select="."/></xsl:for-each></xsl:template>

  <xsl:template name="escape-text-3"><xsl:param name="text"/><xsl:choose><xsl:when test="$text=''"><xsl:value-of select="$text"/></xsl:when><xsl:when test="contains($text,'&amp;')"><xsl:value-of select="substring-before($text,'&amp;')"/>\*(Am<xsl:call-template name="escape-text"><xsl:with-param name="text" select="substring-after($text,'&amp;')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise></xsl:choose></xsl:template>

  <xsl:template name="escape-text-2"><xsl:param name="text"/><xsl:choose><xsl:when test="$text=''"><xsl:value-of select="$text"/></xsl:when><xsl:when test="contains($text,'.')"><xsl:call-template name="escape-text-3"><xsl:with-param name="text" select="substring-before($text,'.')"/></xsl:call-template>\N'46'<xsl:call-template name="escape-text"><xsl:with-param name="text" select="substring-after($text,'.')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="escape-text-3"><xsl:with-param name="text" select="$text"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:template>

  <xsl:template name="escape-text"><xsl:param name="text"/><xsl:choose><xsl:when test="$text=''"><xsl:value-of select="$text"/></xsl:when><xsl:when test="contains($text,'\')"><xsl:call-template name="escape-text-2"><xsl:with-param name="text" select="substring-before($text,'\')"/></xsl:call-template>\N'92'<xsl:call-template name="escape-text"><xsl:with-param name="text" select="substring-after($text,'\')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="escape-text-2"><xsl:with-param name="text" select="$text"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:template>


  <xsl:template name="escape-arg-2"><xsl:param name="text"/><xsl:choose><xsl:when test="$text=''"><xsl:value-of select="$text"/></xsl:when><xsl:when test="contains($text,'&amp;')"><xsl:value-of select="substring-before($text,'&amp;')"/>\*(Am<xsl:call-template name="escape-arg"><xsl:with-param name="text" select="substring-after($text,'&amp;')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise></xsl:choose></xsl:template>

  <xsl:template name="escape-arg"><xsl:param name="text"/><xsl:choose><xsl:when test="$text=''"><xsl:value-of select="$text"/></xsl:when><xsl:when test="contains($text,'\')"><xsl:call-template name="escape-arg-2"><xsl:with-param name="text" select="substring-before($text,'\')"/></xsl:call-template>\N'92'<xsl:call-template name="escape-arg"><xsl:with-param name="text" select="substring-after($text,'\')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="escape-arg-2"><xsl:with-param name="text" select="$text"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:template>

  <xsl:template match="f:r/text()" xml:space="preserve"><xsl:call-template name="escape-arg"><xsl:with-param name="text" select="."/></xsl:call-template></xsl:template>

  <xsl:template match="text()" xml:space="preserve"><xsl:call-template name="escape-text"><xsl:with-param name="text" select="."/></xsl:call-template>
</xsl:template>

  <xsl:template match="f:r" xml:space="preserve">.<xsl:value-of select="@t"/> <xsl:apply-templates/>
</xsl:template>
  <xsl:template match="f:e" xml:space="preserve">\<xsl:value-of select="@t"/></xsl:template>

<xsl:template match="f:block" xml:space="preserve">.<xsl:value-of select="@o"/>
<xsl:apply-templates/>.<xsl:value-of select="@c"/>
</xsl:template>

</xsl:stylesheet>
