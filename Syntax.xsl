<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">

  <!-- <!DOCTYPE html> -->
  <xsl:output method="html" encoding="UTF-8" doctype-system="about:legacy-compat"/>

  <xsl:template match="/">
    <html>
      <link href="Syntax.css" rel="stylesheet"/>
      <xsl:element name="link">
        <xsl:attribute name="href">
          <xsl:value-of select="syntax/@language"/>.css</xsl:attribute>
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
      </xsl:element>
      <body>
        <h1>
          <xsl:value-of select="syntax/@language"/>
        </h1>
        <fieldset>
          <legend><span id="toggle-guide" onclick="toggleGuide(this)">[Hide]</span> Style Guide</legend>
          <div class="guide">
            <div class='comment'>Comment Line</div>
          </div>
          <div class="guide">
            <span class='nonterminal'>NonTerminal Symbol</span>
          </div>
          <div class="guide">
            <span class='terminal'>Case-Sensitive Terminal String</span>
          </div>
          <div class="guide">
            <span class='case-insensitive terminal'>Case-Insensitive Terminal String</span>
          </div>
          <div class="guide">
            <a href="http://unicode.org/cldr/utility/list-unicodeset.jsp" target="_blank">
              <span class='regular terminal'>Unicode Regular Expression</span>
            </a>
          </div>
          <div class="guide">
            <span class='optional'>Optional Sequence</span>
          </div>
          <div class="guide">
            <span class='repeated'>Repeated Sequence</span>
          </div>
          <div class="guide">
            <span class='exception'>Exception</span>
          </div>
        </fieldset>
        <xsl:for-each select="syntax/*">
          <xsl:choose>
            <xsl:when test="name()='comment'">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <table>
                <xsl:apply-templates select="."/>
              </table>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <script><![CDATA[
          window.onload = function () {
            var fieldset = document.getElementsByTagName('fieldset')[0];
            fieldset.style.width = fieldset.offsetWidth + 'px';
            toggleGuide(document.getElementById('toggle-guide'));
          }
          function toggleGuide(button) {
            var guides = button.parentNode.parentNode.getElementsByTagName('div');
            var toggle = guides[0].style.display == 'none' ? 'block' : 'none';
            for (i=0; i < guides.length; i++) {
              guides[i].style.display = toggle;
            }
            button.textContent = toggle == 'none' ? '[Show]' : '[Hide]';
          }
        ]]></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rule">
    <tr>
      <td class="rule">
        <xsl:element name="a">
          <xsl:attribute name="id">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:element name="span">
            <xsl:attribute name="class">nonterminal</xsl:attribute>
            <xsl:value-of select="@name"/>
          </xsl:element>
        </xsl:element>
      </td>
      <td>
        <xsl:apply-templates select="comment"/>
      </td>
    </tr>
    <xsl:apply-templates select="definition"/>
  </xsl:template>

  <xsl:template match="definition">
    <tr>
      <td class="definition">
        <xsl:apply-templates select="node()[not(self::comment)]"/>
      </td>
      <td>
        <xsl:apply-templates select="comment"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="repeated">
    <span class="repeated">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="optional">
    <span class="optional">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="nonterminal">
    <xsl:element name="a">
      <xsl:attribute name="href">#<xsl:value-of select="@name"/></xsl:attribute>
      <span class='nonterminal'><xsl:value-of select="@name"/></span>
    </xsl:element>
  </xsl:template>

  <xsl:template match="terminal">
    <xsl:choose>
      <xsl:when test="@type='regular'">
        <xsl:element name="a">
          <xsl:attribute name="href">http://unicode.org/cldr/utility/list-unicodeset.jsp?a=<xsl:value-of select="text()"/></xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <span class='regular terminal'><xsl:value-of select="text()"/></span>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@type='case-insensitive'">
        <span class="case-insensitive terminal"><xsl:value-of select="text()"/></span>
      </xsl:when>
      <xsl:otherwise>
        <span class="terminal"><xsl:value-of select="text()"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="exception">
    <span class="exception">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="comment">
    <div class="comment">
      <xsl:value-of select="text()" disable-output-escaping="yes"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
