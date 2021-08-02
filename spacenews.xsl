<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <header>
                <style>
                    body {background-color: lightgrey;}
                    footer {font-size: x-small;}
                    p {font-size: large;}
                    article {margin-bottom: 4em;}
                </style>
            </header>
            <body>
                <h1>S8N – News</h1>
                <xsl:for-each select="root/video">
                    <xsl:sort select="@timestamp" order="descending"/>
                    <article>
                        <header>
                            <h3>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@url"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@video"/>
                                </xsl:element>
                            </h3>
                        </header>
                        <p>
                            <pre>
                                <xsl:value-of select="text()"/>
                            </pre>
                        </p>
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