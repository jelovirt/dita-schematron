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

  <xsl:output indent="no"/>

  <xsl:variable name="msgprefix">DOTS</xsl:variable>
  <xsl:variable name="message-newline">false</xsl:variable>

  <xsl:template match="*" mode="stylesheetbody">
    <axsl:import href="../../../xsl/common/output-message.xsl"/>
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template name="process-prolog">
    <axsl:variable name="msgprefix">DOTS</axsl:variable>
  </xsl:template>

  <xsl:template name="process-assert">
    <xsl:param name="test"/>
    <xsl:param name="diagnostics"/>
    <xsl:param name="properties"/>
    <xsl:param name="id"/>
    <xsl:param name="flag"/>
    <!-- "Linkable" parameters -->
    <xsl:param name="role"/>
    <xsl:param name="subject"/>
    <!-- "Rich" parameters -->
    <xsl:param name="fpi"/>
    <xsl:param name="icon"/>
    <xsl:param name="lang"/>
    <xsl:param name="see"/>
    <xsl:param name="space"/>

    <axsl:call-template name="output-message">
      <axsl:with-param name="msgnum">
        <xsl:number format="000" level="any" count="iso:report | iso:assert"/>
      </axsl:with-param>
      <axsl:with-param name="msgsev">
        <xsl:choose>
          <xsl:when test="$role = 'warning'">W</xsl:when>
          <xsl:when test="$role = 'error'">E</xsl:when>
        </xsl:choose>
      </axsl:with-param>
      <xsl:if test="iso:value-of | iso:name">
        <axsl:with-param name="msgparams">
          <xsl:apply-templates mode="param"/>
        </axsl:with-param>
      </xsl:if>
    </axsl:call-template>
  </xsl:template>
  
  <xsl:template name="process-report">
    <xsl:param name="id"/>
    <xsl:param name="test"/>
    <xsl:param name="diagnostics"/>
    <xsl:param name="flag"/>
    <xsl:param name="properties"/>
    <!-- "Linkable" parameters -->
    <xsl:param name="role"/>
    <xsl:param name="subject"/>
    <!-- "Rich" parameters -->
    <xsl:param name="fpi"/>
    <xsl:param name="icon"/>
    <xsl:param name="lang"/>
    <xsl:param name="see"/>
    <xsl:param name="space"/>

    <axsl:call-template name="output-message">
      <axsl:with-param name="msgnum">
        <xsl:number format="000" level="any" count="iso:report | iso:assert"/>
      </axsl:with-param>
      <axsl:with-param name="msgsev">
        <xsl:choose>
          <xsl:when test="$role = 'warning'">W</xsl:when>
          <xsl:when test="$role = 'error'">E</xsl:when>
        </xsl:choose>
      </axsl:with-param>
      <xsl:if test="iso:value-of | iso:name">
       <axsl:with-param name="msgparams">
         <xsl:apply-templates mode="param"/>
       </axsl:with-param>
      </xsl:if>
    </axsl:call-template>
  </xsl:template>

  <!-- params -->
  
  <xsl:template match="iso:value-of | iso:name" mode="param">
    <xsl:text>%</xsl:text>
    <xsl:number level="single" count="iso:value-of | iso:name"/>
    <xsl:text>=</xsl:text>
    <xsl:apply-templates select="." mode="text"/>
    <xsl:if test="following-sibling::iso:value-of | following-sibling::iso:name">
      <xsl:text>;</xsl:text>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="node()" mode="param" priority="-2" />
  
  <xsl:template name="process-value-of">
    <xsl:param name="select"/>
    <axsl:value-of select="{$select}"/>
  </xsl:template>

  <xsl:template name="process-name">
    <xsl:param name="name"/>
    <axsl:value-of select="{$name}"/>    
  </xsl:template>
  
</xsl:stylesheet>
