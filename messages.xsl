<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                exclude-result-prefixes="iso xsl xs"
                version="2.0">

  <xsl:import href="iso-schematron-xslt2/iso_schematron_skeleton_for_saxon.xsl"/>

  <xsl:variable name="msgprefix">DOTS</xsl:variable>
  
  <xsl:template match="/">
    <xsl:comment>
  Copyright <xsl:value-of select="format-date(current-date(), '[Y]')"/> Jarno Elovirta
      
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
  http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
</xsl:comment>
    <xsl:text>&#xA;</xsl:text>
    <messages>
      <xsl:for-each select="descendant::iso:report | descendant::iso:assert">
        <xsl:variable name="type">
          <xsl:choose>
            <xsl:when test="@role = 'warning'">WARN</xsl:when>
            <xsl:when test="@role = 'error'">ERROR</xsl:when>
            <xsl:otherwise><xsl:message terminate="yes">Unsupported role <xsl:value-of select="@role"/></xsl:message></xsl:otherwise>
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
    <xsl:number level="single" count="iso:value-of | iso:name"/>
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
