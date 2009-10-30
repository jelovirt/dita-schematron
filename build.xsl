<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns="http://purl.oclc.org/dsdl/schematron"
      xmlns:sch="http://purl.oclc.org/dsdl/schematron"
      xmlns:e="http://dita-schematron.github.com/"
      exclude-result-prefixes="xs e sch"
      version="2.0">

  <xsl:param name="release.version"/>

  <xsl:strip-space elements="*"/>

  <xsl:key name="pattern" match="sch:pattern[@id]" use="@id"/>
  
  <xsl:function name="e:matches" as="xs:boolean">
    <xsl:param name="ditaVersions" as="attribute(e:ditaVersions)"/>
    <xsl:param name="version" as="xs:decimal"/>
    <xsl:sequence select="some $v in for $i in tokenize($ditaVersions, '\s+')
                                     return xs:decimal($i)
                          satisfies $v eq $version"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="root" select="/" as="document-node()"/>
    <xsl:for-each select="(1.1, 1.2)">
      <xsl:result-document href="{replace(document-uri($root),
                                          '(.+)\.(.+)',
                                          concat('$1-',
                                                 format-number(., '#.0'),
                                                 '.$2'))}">
        <xsl:apply-templates select="$root/node()">
          <xsl:with-param name="version" select="." as="xs:decimal" tunnel="yes" />
        </xsl:apply-templates>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:param name="version" as="xs:decimal" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="@e:ditaVersions">
        <xsl:if test="e:matches(@e:ditaVersions, $version)">
          <xsl:call-template name="copy"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="copy"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sch:schema">
    <xsl:param name="version" as="xs:decimal" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <title>
        <xsl:text>Schematron schema for DITA </xsl:text>
        <xsl:value-of select="format-number($version, '#.0')"/>
      </title>
      <p>
        <xsl:text>Version </xsl:text>
        <xsl:value-of select="$release.version"/>
        <xsl:text>. released </xsl:text>
        <xsl:value-of select="format-date(current-date(), '[Y]-[M01]-[D01]')"/>
        <xsl:text>.</xsl:text>
      </p>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sch:active">
    <xsl:param name="version" as="xs:decimal" tunnel="yes"/>
    <xsl:variable name="ref" select="key('pattern', @pattern)"/>
    <xsl:choose>
      <xsl:when test="$ref[@e:ditaVersions] and
                      not(e:matches($ref/@e:ditaVersions, $version))"/>
      <xsl:otherwise>
        <xsl:call-template name="copy"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@e:*" priority="100"/>

  <xsl:template match="comment()" priority="100"/>

  <xsl:template match="text()">
    <xsl:if test="preceding-sibling::* and not(normalize-space(substring(., 1, 1)))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and not(normalize-space(substring(., string-length(.), 1)))">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="node() | @*" name="copy" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
    
</xsl:stylesheet>
