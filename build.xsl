<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://purl.oclc.org/dsdl/schematron"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:e="http://github.com/jelovirt/dita-schematron"
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

  <xsl:variable name="root" select="/" as="document-node()"/>
  <xsl:variable name="phases" select="distinct-values(sch:schema/sch:pattern/@e:phases/tokenize(., '\s+'))"/>  

  <xsl:template match="/">
    <xsl:for-each select="($phases, '')">
      <xsl:variable name="phase" select="."/>
      <xsl:for-each select="(1.1, 1.2)">
        <xsl:variable name="dita-version" select="."/>
        <xsl:for-each select="('xslt1', 'xslt2')">
          <xsl:variable name="queryBinding" select="."/>
          <xsl:result-document href="{replace(document-uri($root),
                                              '(.+)\.(.+)',
                                              concat('$1-',
                                                     format-number($dita-version, '#.0'),
                                                     '-for-', $queryBinding,
                                                     if (string-length($phase) ne 0) then concat('-', $phase) else '',
                                                     '.$2'))}">
            <xsl:apply-templates select="$root/node()">
              <xsl:with-param name="version" select="$dita-version" as="xs:decimal" tunnel="yes"/>
              <xsl:with-param name="queryBinding" select="$queryBinding" as="xs:string" tunnel="yes"/>
              <xsl:with-param name="phase" select="$phase" as="xs:string" tunnel="yes"/>
            </xsl:apply-templates>
          </xsl:result-document>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="sch:pattern[not(@abstract = 'true')]">
    <xsl:param name="phase" as="xs:string" tunnel="yes"/>
    <xsl:if test="string-length($phase) eq 0 or (some $i in tokenize(@e:phases, '\s+') satisfies $i eq $phase)">
      <xsl:element name="{name()}">
        <xsl:apply-templates select="@* | node()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:param name="version" as="xs:decimal" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="@e:ditaVersions">
        <xsl:if test="e:matches(@e:ditaVersions, $version)">
          <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | node()"/>
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}">
          <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sch:schema">
    <xsl:param name="version" as="xs:decimal" tunnel="yes"/>
    <xsl:param name="queryBinding" as="xs:string" tunnel="yes"/>
    <xsl:param name="phase" as="xs:string" tunnel="yes"/>
    
    <xsl:text>&#xA;</xsl:text>
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
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:if test="$queryBinding">
        <xsl:attribute name="queryBinding" select="if ($queryBinding eq 'xslt1') then 'xslt' else $queryBinding"/>
      </xsl:if>
      <title>
        <xsl:text>Schematron schema for DITA </xsl:text>
        <xsl:value-of select="format-number($version, '#.0')"/>
      </title>
      <p>
        <xsl:text>Version </xsl:text>
        <xsl:value-of select="$release.version"/>
        <xsl:text> released </xsl:text>
        <xsl:value-of select="format-date(current-date(), '[Y]-[M01]-[D01]')"/>
        <xsl:text>.</xsl:text>
      </p>
      <xsl:if test="string-length($phase) eq 0">
        <xsl:for-each select="$phases">
          <phase id="{.}">
            <xsl:for-each select="$root/sch:schema/sch:pattern[some $i in tokenize(@e:phases, '\s+') satisfies $i eq current()]">
              <active pattern="{@id}"/>
            </xsl:for-each>
          </phase>
        </xsl:for-each>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="@defaultPhase">
    <xsl:param name="phase" as="xs:string" tunnel="yes"/>
    <xsl:if test="string-length($phase) eq 0">
      <xsl:copy/>
    </xsl:if>
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
  
  <xsl:template match="@*">
    <xsl:attribute name="{name()}" select="normalize-space(.)"/>
  </xsl:template>
    
</xsl:stylesheet>
