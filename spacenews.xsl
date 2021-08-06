<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <title>S8N – News</title>
                <link rel="alternate" type="application/rss+xml" title="RSS" href="https://buckket.github.io/spacenews/rss.xml"/>
                <style>
                    footer {font-size: x-small;}
                    article {margin-bottom: 4em;}
                    img {max-width: 640px; height: auto;}
                </style>
            </head>
            <body>
                <h1>
                    <a href="https://www.youtube.com/channel/UCJRR3CPEVpT03fUsozSmFgA">S8N</a> – News
                </h1>
                <xsl:for-each select="root/video">
                    <xsl:sort select="@timestamp" order="descending"/>
                    <article>
                        <header>
                            <h2>
                                <xsl:element name="a">
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="@video"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@url"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@video"/>
                                </xsl:element>
                                <xsl:text> [</xsl:text>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="@video"/>
                                    </xsl:attribute>
                                    <xsl:text>#</xsl:text>
                                </xsl:element>
                                <xsl:text>]</xsl:text>
                            </h2>
                        </header>
                        <xsl:for-each select="image">
                            <p>
                                <xsl:element name="img">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="@filename"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        <xsl:value-of select="text()"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </p>
                        </xsl:for-each>
                        <footer>
                            <xsl:element name="time">
                                <xsl:attribute name="datetime">
                                    <xsl:value-of select="@isotime"/>
                                </xsl:attribute>
                                <xsl:value-of select="@isotime"/>
                            </xsl:element>
                        </footer>
                    </article>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
