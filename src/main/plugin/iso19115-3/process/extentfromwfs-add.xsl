<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-iso19115-3="http://geonetwork-opensource.org/xsl/functions/profiles/iso19115-3"
                exclude-result-prefixes="#all" version="2.0">

  <xsl:import href="../layout/utility-fn.xsl"/>


  <!-- WFS Url and layerName (mandatory) -->
  <!-- eg. http://140.79.20.100:9080/geoserver/wfs and iwsfootprint_PFI_2209 --> 
  <xsl:param name="url" select="'http://140.79.20.100:9080/geoserver/wfs'"/>
  <xsl:param name="layerName" select="'iwsfootprint_PFI_2209'"/>

  <xsl:variable name="separator" select="'\|'"/>

  <xsl:variable name="mainLang"
                select="if (/mdb:MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue) then /mdb:MD_Metadata/mdb:defaultLocale/*/lan:language/*/@codeListValue else 'eng'"
                as="xs:string"/>

  <xsl:variable name="useOnlyPTFreeText"
                select="count(//*[lan:PT_FreeText and not(gco:CharacterString)]) > 0"
                as="xs:boolean"/>

  <xsl:variable name="wfsUrl" select="concat($url,'?request=GetFeature&amp;version=2.0.0&amp;service=WFS&amp;typeName=',$layerName,'&amp;srsName=urn:x-ogc:def:crs:EPSG:4326')"/>
  <xsl:variable name="wfsResponse" select="document($wfsUrl)"/>
    

  <xsl:template match="mri:MD_DataIdentification|
                      *[@gco:isoType='mri:MD_DataIdentification']|
                      srv:SV_ServiceIdentification">

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="mri:citation"/>
      <xsl:apply-templates select="mri:abstract"/>
      <xsl:apply-templates select="mri:purpose"/>
      <xsl:apply-templates select="mri:credit"/>
      <xsl:apply-templates select="mri:status"/>
      <xsl:apply-templates select="mri:pointOfContact"/>
      <xsl:apply-templates select="mri:spatialRepresentationType"/>
      <xsl:apply-templates select="mri:spatialResolution"/>
      <xsl:apply-templates select="mri:temporalResolution"/>
      <xsl:apply-templates select="mri:topicCategory"/>

      <xsl:choose>
        <xsl:when test="$wfsResponse != ''">
          <xsl:call-template name="fill"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="mri:extent"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="mri:additionalDocumentation"/>
      <xsl:apply-templates select="mri:processingLevel"/>
      <xsl:apply-templates select="mri:resourceMaintenance"/>

      <xsl:apply-templates select="mri:graphicOverview"/>

      <xsl:apply-templates select="mri:resourceFormat"/>
      <xsl:apply-templates select="mri:descriptiveKeywords"/>
      <xsl:apply-templates select="mri:resourceSpecificUsage"/>
      <xsl:apply-templates select="mri:resourceConstraints"/>
      <xsl:apply-templates select="mri:associatedResource"/>

      <xsl:apply-templates select="mri:defaultLocale"/>
      <xsl:apply-templates select="mri:otherLocale"/>
      <xsl:apply-templates select="mri:environmentDescription"/>
      <xsl:apply-templates select="mri:supplementalInformation"/>

      <xsl:apply-templates select="srv:*"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template name="fill">
      <xsl:variable name="firstPolygon" select="$wfsResponse/descendant::gml:Polygon[1]"/>
      <mri:extent>
        <gex:EX_BoundingPolygon>
          <gex:polygon>
            <xsl:copy-of select="$firstPolygon" copy-namespaces="no"/>
          </gex:polygon>
        </gex:EX_BoundingPolygon>
      </mri:extent>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>
</xsl:stylesheet>
