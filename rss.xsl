<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
            <channel>
                <title>S8N</title>
                <link>https://buckket.github.io/spacenews/</link>
                <description>Feinste Storys, Big Emotions by Spacesurfer</description>
                <atom:link href="https://buckket.github.io/spacenews/rss.xml" rel="self" type="application/rss+xml" />
                <xsl:for-each select="root/video">
                    <xsl:sort select="@timestamp" order="descending"/>
                    <item>
                        <title><xsl:value-of select="@video"/></title>
                        <link>https://buckket.github.io/spacenews/#<xsl:value-of select="@video"/></link>
                        <guid>https://buckket.github.io/spacenews/#<xsl:value-of select="@video"/></guid>
                        <description>
                            <xsl:for-each select="image">
                                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                                <p>
                                    <xsl:element name="img">
                                        <xsl:attribute name="src">https://buckket.github.io/spacenews/<xsl:value-of select="@filename"/></xsl:attribute>
                                        <xsl:attribute name="alt"><xsl:value-of select="text()"/></xsl:attribute>
                                    </xsl:element>
                                </p>
                                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                            </xsl:for-each>
                        </description>
                    </item>
                </xsl:for-each>
            </channel>
        </rss>
    </xsl:template>
</xsl:stylesheet>
