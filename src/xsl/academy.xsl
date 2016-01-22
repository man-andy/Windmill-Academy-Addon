<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:php='http://php.net/xsl' exclude-result-prefixes='php'>
    
    <!--
    Ouput loose HTML
    -->
    <xsl:output
        method="html"
        doctype-system="about:legacy-compat"
        doctype-public=""
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

    <!--
    Added specific css for academy
    -->
    <xsl:template match='wmpage' mode='defaultCss'>
        <link href='//fonts.googleapis.com/css?family=Roboto:400,700' rel='stylesheet' type='text/css'/>
        <xsl:apply-templates select='self::wmpage' mode='optionalCss'/>
        <link rel="stylesheet" type="text/css" href="/var/frontend/academy/style/optimized/material-design-eportfolio-academy.css"/>
    </xsl:template>

    <!--
    Show the client's logo
    -->
    <xsl:template match='wmpage' mode='headerLogo'>
        <div id='logo'>
            <a href='{php:functionString("WMXSLFunctions::resolveHost", "academy", "environments.hosts.group", "/home") }'>
                <img>
                    <xsl:attribute name='src'>
                        <xsl:text>/images/logos/logo-</xsl:text>
                        <xsl:value-of select='@sitename'/>
                        <xsl:text>.svg</xsl:text>
                    </xsl:attribute>
                </img>
            </a>
        </div>
    </xsl:template>

    <!--
    As default match away content

    *match* wmpage
    *mode* content

    Since: Mon Jan 26 2015
    -->
    <xsl:template match='wmpage' mode='content'>
        <div id='main'>
            <section>
                <xsl:apply-templates select='self::node()' mode='contentElements'/>
            </section>
            <xsl:apply-templates select='self::node()' mode='contentBottom'/>
        </div>
    </xsl:template>

    <!--
    Show the content for the bottom group
    -->
    <xsl:template match='wmpage' mode='contentBottom'>
        <section>
            <div>
                <xsl:attribute name='class'>
                    <xsl:text>bottombox</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select='article/article[@requested]/contentblocks[@group = "bottom" and count(contentblock) &gt; 0]' mode='actionBox'/>
            </div>
        </section>
    </xsl:template>

    <!--
    Adds the content for the categories moduleinmode contentblock
    -->
    <xsl:template match='contentblocks/contentblock[template = "moduleinmode" and node()/@mode = "categories"]' mode='cbContents'>
        <xsl:apply-templates select='title' mode='cbContent'/>
        <div class='module layout_list'>
            <xsl:apply-templates select='node()/filters/filter[substring(column, string-length(column) - string-length("_type") +1)]' mode='cbContentCategories'/>
        </div>
    </xsl:template>

    <!--
    Adds the categories filter in two columns
    -->
    <xsl:template match='filter' mode='cbContentCategories'/>
    <xsl:template match='filter[count(option) &gt; 1]' mode='cbContentCategories'>
        <xsl:variable name='max_column_amount'>
            <xsl:value-of select='ceiling(count(current()/option ) div 2)'/>
        </xsl:variable>
        <div class='optioncolumn'>
            <xsl:apply-templates select='option[position() &lt; $max_column_amount]' mode='optionContent'/>
        </div>
        <div class='optioncolumn'>
            <xsl:apply-templates select='option[position() &gt; $max_column_amount]' mode='optionContent'/>
        </div>
    </xsl:template>

    <!--
    Adds the label and amount of the option in a link
    -->
    <xsl:template match='option' mode='optionContent'>
        <a class='item'>
            <xsl:attribute name='href'>
                <xsl:text>/cursussen?activity_type[]=</xsl:text>
                <xsl:value-of select='identifier'/>
            </xsl:attribute>
            <xsl:value-of select='label'/>
            <span class='amount'>
                <xsl:value-of select='amount'/>
            </span>
        </a>
    </xsl:template>

     <!--
     Photo and label
     -->
    <xsl:template match='photo' mode='itemValuePhoto'/>
        <xsl:template match='photo[not(self::node() = "")]' mode='itemValuePhoto'>
             <div class='photo_wrapper'>
                <xsl:attribute name='style'>
                    <xsl:text>background-image:url('</xsl:text>
                    <xsl:value-of select='/wmpage/@aliasthumbs'/>
                    <xsl:text>__lw650h650d1/__cw650h650/__ql60/</xsl:text>
                    <xsl:value-of select='self::node()'/>
                    <xsl:text>')</xsl:text>
                </xsl:attribute>
            </div>
            <span>
                <xsl:attribute name='class'>
                    <xsl:text>label ribbon </xsl:text>
                    <xsl:value-of select='php:functionString("WMXSLFunctions::slugifyString", parent::node()/label)'/>
                </xsl:attribute>
                <span class='label_tag'>
                    <xsl:value-of select='parent::node()/label'/>
                </span>
            </span>
    </xsl:template>

    <!--
    Item class
    -->
    <xsl:template match='node()' mode='itemClass'>
        <xsl:attribute name='class'>
            <xsl:value-of select='local-name()'/>
            <xsl:text> </xsl:text>
            <xsl:value-of select='label/@dbvalue'/>
        </xsl:attribute>
    </xsl:template>

    <!--
    Adds the content for rows with special items
    -->
    <xsl:template match='contentblocks/contentblock[template = "moduleinmode" and node()/@mode = "spotlight" or node()/@mode = "special"]' mode='cbContents'>
        <xsl:apply-imports />
        <xsl:apply-templates select='node()/data' mode='moduleContentData'/>
    </xsl:template>

    <!--
     Don't add a divider for the pager numbers
     -->
     <xsl:template match='node()' mode='pagerPageNumberDivider'/>

     <!--
     Don't add a label for the pager
     -->
     <xsl:template match='node()' mode='pagerPagesTitle'/>

    <!--
    Adds the value to the action attribute of the form surrounding the filterset
    -->
    <xsl:template match='filters' mode='filterformActionAttributeValue'>
        <xsl:value-of select='/wmpage/navigation/menu[@active = 1]//item[@active = 1]/seolink'/>
    </xsl:template>

    <!--
    Returns the base filtered link for the module
    -->
    <xsl:template name='baseFilteredLink'>
        <xsl:value-of select='/wmpage/navigation/menu[@active = 1]//item[@active = 1]/seolink'/>
        <xsl:apply-templates select='/wmpage/node()[data/node() ]/searchform' mode='searchFormArgument'/>
    </xsl:template>

   <!--
    Returns the baselink for url's made in this stylesheet, overwrite for other script
    -->
    <xsl:template match='node()' mode='pagerBaseLink'>
        <xsl:value-of select='/wmpage/navigation/menu[@active = 1]//item[@active = 1]/seolink'/>
        <xsl:text>?activity:</xsl:text>
    </xsl:template>

    <!--
    Add the offset to the link
    -->
    <xsl:template match='/wmpage/node()[data/node() ]' mode='pagerOffsetArgument'>
        <xsl:text>activity:offset=</xsl:text>
        <xsl:value-of select='@offset'/>
    </xsl:template>

    <!--
    Adds the title and text to the form content
    -->
    <xsl:template match='/wmpage/article/article[@requested = "1"]/contentblocks[@group = "action"]/contentblock[template = "compositeform"]/form' mode='form_content'>
        <div class='wrapper'>
            <xsl:apply-templates select='parent::contentblock/title' mode='cbContent'/>
            <xsl:apply-templates select='parent::contentblock/text' mode='cbContent'/>
            <div class="formfield text_field querystringfield">
                <xsl:apply-templates select='self::node()' mode='querystringName'/>
                <label for="querystring_input">
                    <xsl:value-of select='php:functionString("WMXSLFunctionsEportfolio::text", "querystring_label", "cbcompositeform.brandbox")'/>
                </label>
            </div>
            <div class="formfield submit_field field">
                <button type="submit" class='waves-effect waves-float btn'>
                    <xsl:value-of select='php:functionString("WMXSLFunctionsEportfolio::text", "searchbutton_label", "cbcompositeform.brandbox")'/>
                </button>
            </div>
        </div>
    </xsl:template>

    <!--
    Adds the title and text to the form content
    -->
    <xsl:template match='node()' mode='querystringName'>
        <input id="querystring_input" name="querystring" value="" type="text"></input>
    </xsl:template>
    <xsl:template match='node()[ancestor::wmpage/@sitename = "eportfolio_vrijwilligersacademie"]' mode='querystringName'>
        <input id="querystring_input" name="activity:query" value="" type="text"></input>
    </xsl:template>

    <!--
    Adds the action attribute to the form
    -->
    <xsl:template match='/wmpage/article/article[@requested = "1"]/contentblocks[@group = "action"]/contentblock[template = "compositeform"]/form' mode='form_actionAttribute'>
        <xsl:attribute name='action'>
           <xsl:value-of select='php:functionString("WMXSLFunctionsEportfolio::text", "search_action", "cbcompositeform.brandbox")'/>
        </xsl:attribute>
    </xsl:template>

    <!--
    Adds the value of the method to the method attribute
    -->
    <xsl:template match='/wmpage/article/article[@requested = "1"]/contentblocks[@group = "action"]/contentblock[template = "compositeform"]/form' mode='form_methodAttributeValue'>
        <xsl:text>post</xsl:text>
    </xsl:template>

    <!--
    Sets the input for the label and adds the bar
    -->
    <xsl:template match='/wmpage/article/article[@requested = "1"]/contentblocks/contentblock[template = "compositeform"]/form/text | /wmpage/article/article[@requested = "1"]/contentblocks/contentblock[template = "compositeform"]/form/longtext' mode='form_field_elements'>
        <xsl:apply-templates select='self::node()' mode='form_field_input'/>
        <xsl:apply-templates select='self::node()' mode='form_field_label'/>
        <span class="bar"></span>
    </xsl:template>

</xsl:stylesheet>

