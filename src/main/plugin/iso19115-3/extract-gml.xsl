<?xml version="1.0" encoding="UTF-8"?>
<!-- FIXME: GML namespace in gex: elements will be different to those
  used under the gml: namespace required by geotools. For the time
  being create a default GML parser and not a GML3.2 parser. -->
<xsl:stylesheet version="2.0" 
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:gml32="http://www.opengis.net/gml/3.2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="no" method="xml"/>

  <xsl:template match="/" priority="2">
    <gml:GeometryCollection>
      <xsl:apply-templates/>
    </gml:GeometryCollection>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template
    match="gex:EX_BoundingPolygon[string(gex:extentTypeCode/gco:Boolean) != 'false' and string(gex:extentTypeCode/gco:Boolean) != '0']"
    priority="2">
    <xsl:for-each select="gex:polygon/gml32:*">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="gex:EX_GeographicBoundingBox" priority="2">
    <xsl:variable name="w" select="./gex:westBoundLongitude/gco:Decimal/text()"/>
    <xsl:variable name="e" select="./gex:eastBoundLongitude/gco:Decimal/text()"/>
    <xsl:variable name="n" select="./gex:northBoundLatitude/gco:Decimal/text()"/>
    <xsl:variable name="s" select="./gex:southBoundLatitude/gco:Decimal/text()"/>
    <xsl:if test="$w!='' and $e!='' and $n!='' and $s!=''">
      <gml:Polygon>
        <gml:exterior>
          <gml:LinearRing>
            <gml:coordinates><xsl:value-of select="$w"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$n"/>, <xsl:value-of select="$e"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$s"/>, <xsl:value-of select="$w"/>,<xsl:value-of select="$n"/></gml:coordinates>
          </gml:LinearRing>
        </gml:exterior>
      </gml:Polygon>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*[namespace-uri()='http://www.opengis.net/gml/3.2' and ancestor::gex:EX_BoundingPolygon]">
    <xsl:variable name="name" select="concat('gml:',local-name())"/>
    <xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  
  <xsl:template match="*[namespace-uri()='http://www.opengis.net/gml/3.2' and ancestor::gex:EX_BoundingPolygon]">
    <xsl:variable name="name" select="concat('gml:',local-name())"/>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
         <xsl:when test="count(*)>0">
           <xsl:apply-templates select="@*|*"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
