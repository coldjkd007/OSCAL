<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"

  xpath-default-namespace="http://scap.nist.gov/schema/oscal"
  xmlns="http://scap.nist.gov/schema/oscal"
  exclude-result-prefixes="xs"
  version="2.0">
  
<!-- Looks at an OSCAL 'strawman' document and produces an abstracted
     representation (reduced 'examplotron') of the document. -->
  
  <xsl:output indent="yes"/>
  
  
  <xsl:template match="/*">
    <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
      <xsl:call-template name="descend"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="descend">
    <xsl:param name="parents" select="."/>
    <xsl:param name="children" select="*"/>
    <xsl:for-each-group select="$children" group-by="string-join((name(.),@name),'-')">
      <xsl:variable name="ubiquitous" select="empty($parents except current-group()/..)"/>
        <xsl:element name="{name(.)}" namespace="{namespace-uri(/*)}">
          <xsl:if test="$ubiquitous and not(name(.)=('p','list'))">
            <xsl:attribute name="GIVEN">ALWAYS</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="@name | @flag"/>
          <xsl:call-template name="descend">
            <xsl:with-param name="parents" select="current-group()"/>
            <xsl:with-param name="children"
              select="current-group()[not(self::p|self::list)]/*"/>
          </xsl:call-template>
          <xsl:if test="exists(current-group()/(@name|@flag)) and exists(text()[matches(.,'\S')])">
            <xsl:for-each-group select="current-group()" group-by="normalize-space()">
              <VALUE>
                <xsl:value-of select="current-grouping-key()"/>
              </VALUE>
            </xsl:for-each-group>
          </xsl:if>
        </xsl:element>
      <!--</xsl:for-each-group>-->
    </xsl:for-each-group>
  </xsl:template>
  
</xsl:stylesheet>