<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:slurm="http://slurm.romulusetrem.us"
  xmlns:f="http://slurm.romulusetrem.us/function"
  xmlns:t="http://slurm.romulusetrem.us/type"
  xmlns:v="http://slurm.romulusetrem.us/variable"
  exclude-result-prefixes="slurm f t v xsl">

  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/slurm:script">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html>&#xa;</xsl:text>
    <html>
      <head>
        <title>Slurm</title>
        <script src="slurm.js"></script>
      </head>
      <body>
        <script>
          <xsl:text>&#xa;</xsl:text>
          <xsl:apply-templates/>
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="f:*[slurm:type]">
    <xsl:text>// </xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text> :: </xsl:text>
    <xsl:for-each select="slurm:type/t:*">
      <xsl:value-of select="local-name()"/>
      <xsl:if test="not(position()=last())">
        <xsl:text> -> </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>function </xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>(</xsl:text>
    <xsl:for-each select="slurm:type/t:*[not(position()=last())]">
      <xsl:value-of select="concat('$',position()-1)"/>
    </xsl:for-each>
    <xsl:text>) {&#xa;</xsl:text>
    <xsl:apply-templates select="slurm:match">
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:apply-templates>
    <xsl:text>}&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="f:*">
    <xsl:value-of select="local-name()"/>
    <xsl:text>(</xsl:text>
    <xsl:for-each select="*">
      <xsl:apply-templates select="."/>
      <xsl:if test="not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="slurm:match">
    <xsl:param name="indent"/>
    <xsl:value-of select="$indent"/>
    <xsl:if test="preceding-sibling::slurm:match">
      <xsl:text>} else </xsl:text>
    </xsl:if>
    <xsl:text>if (</xsl:text>
    <xsl:apply-templates select="slurm:pattern"/>
    <xsl:text>) {&#xa;</xsl:text>
    <xsl:apply-templates select="slurm:value">
      <xsl:with-param name="indent" select="concat($indent,'  ')"/>
    </xsl:apply-templates>
    <xsl:if test="not(following-sibling::slurm:match)">
      <xsl:value-of select="$indent"/>
      <xsl:text>}&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="slurm:pattern">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="concat('$',position()-1)"/>
    <xsl:text> === </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
    <xsl:if test="not(position()=last())">
      <xsl:text> &amp;&amp; </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="slurm:value">
    <xsl:param name="indent"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>return </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;&#xa;</xsl:text>
  </xsl:template>

  <xsl:template name="infix">
    <xsl:param name="op"/>
    <xsl:text>(</xsl:text>
    <xsl:for-each select="*">
      <xsl:apply-templates select="."/>
      <xsl:if test="not(position()=last())">
        <xsl:value-of select="concat(' ',$op,' ')"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="slurm:mul">
    <xsl:call-template name="infix">
      <xsl:with-param name="op" select="'*'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="slurm:sub">
    <xsl:call-template name="infix">
      <xsl:with-param name="op" select="'-'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="t:*">
    <xsl:value-of select="normalize-space()"/>
  </xsl:template>

  <xsl:template match="v:*">
    <xsl:value-of select="local-name()"/>
  </xsl:template>

  <xsl:template match="slurm:script/*
    [not(starts-with(namespace-uri(),'http://slurm.romulusetrem.us'))]">
    <xsl:text>document.body.appendChild(slurm.$</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>));&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="slurm:*/text()"/>

  <xsl:template match="text()">
    <xsl:if test="normalize-space()!=''">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="normalize-space()"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:transform>
