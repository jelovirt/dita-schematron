<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="ditamsg schold iso xsl xs"
                version="2.0"><!--xmlns:svrl="http://purl.oclc.org/dsdl/svrl"-->

  <xsl:import href="iso-schematron-xslt2/iso_schematron_skeleton_for_saxon.xsl"/>

  <xsl:variable name="msgprefix">DOTS</xsl:variable>
  
  <xsl:template match="/">
    <messages>
      <xsl:for-each select="descendant::iso:report | descendant::iso:assert">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="@role = 'warning'">WARN</xsl:when>
            <xsl:when test="@role = 'error'">ERROR</xsl:when>
            <xsl:otherwise>
              [<xsl:value-of select="@role"/>]
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <message>
          <xsl:attribute name="id">
            <xsl:value-of select="$msgprefix"/>
            <xsl:value-of select="format-number(position(), '000')"/>
            <xsl:value-of select="substring($type, 1, 1)"/>
          </xsl:attribute>
          <xsl:attribute name="type" select="$type"/>
          <reason>
            <xsl:apply-templates mode="message"/>
          </reason>
          <response/>
        </message>
      </xsl:for-each>
    </messages>
  </xsl:template>

  <!-- message -->
  
  <xsl:template match="iso:dir | iso:emph | iso:span" mode="message" >
    <xsl:apply-templates mode="message"/>
  </xsl:template>
  
  <xsl:template match="iso:value-of | iso:name" mode="message" >
    <xsl:text>%</xsl:text>
    <xsl:number level="single" count="iso:value-of | iso:name"></xsl:number>
  </xsl:template>

  <xsl:template match="text()" mode="message">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="iso:*" mode="message" priority="-2" />
  
  <xsl:template match="*" mode="message" priority="-3">
    <xsl:if test="not($allow-foreign = 'false')"> 
      <xsl:copy-of select="." />
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
