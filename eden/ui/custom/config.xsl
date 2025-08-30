<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
	<head>
		<title>Ghost UI Configuration Tool</title>
		<link rel="stylesheet" href="/config.css"/>
		
		<script src="client.js"/>
		
		<script>
			function spitDom()
			{
				alert(document.body.innerHTML);
			}
		</script>
	</head>
	<body>
		<a name="top"></a>
	
		<h1 class="pageTitle">Ghost UI Configuration Tool</h1>
	
		<div id="bodyContainer">

		<a id="quitlink" onclick="makeRequest('quit');" href="javascript:;" onmouseover="status='Quit the configuration tool.';return true;" onmouseout="status='';return true;">Quit</a>
	
		<ul id="grouptoc">
		
			Quick Jump:
		
			<xsl:for-each select="configuration_page/group">
			
				<xsl:variable name="groupName">
					<xsl:value-of select="name"/>
				</xsl:variable>			
	
				<li><a href="#{$groupName}"><xsl:value-of select="name"/></a></li>
	
			</xsl:for-each>
		</ul>

		<div id="mainContentContainer">

		<p>
			Welcome to the GhostUI configuration tool. To activate a particular window, simply click on it. Active windows will be colored yellow. At any point, you may zone or relog in game to see the changes. When you are done, click on quit at the top right to safely exit the tool.
		</p>
		
		<xsl:for-each select="configuration_page/group">
		
			<xsl:variable name="groupName">
				<xsl:value-of select="name"/>
			</xsl:variable>			
				
			<a name="#{$groupName}"></a>

			<div class="groupContainer" id="{$groupName}">
			
				<h2 class="groupTitle"><xsl:value-of select="name"/> <span class="topLink">[<a class="topLink" href="#top">top</a>]</span></h2>
				
				<div id="{$groupName}Container">
		
				<xsl:for-each select="option">
				
					<xsl:variable name="optionIndex"><xsl:value-of select="index"/></xsl:variable>
					
					<xsl:variable name="selected"><xsl:value-of select="selected"/></xsl:variable>

					<xsl:variable name="selectedClass">
						<xsl:choose>
							<xsl:when test="normalize-space($selected)='true'">
								optionContainerSelected
							</xsl:when>
							<xsl:otherwise>
								optionContainerUnselected
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<a class="{$selectedClass}" id="{$optionIndex} {$groupName}" onclick="setRequest('{$optionIndex}','{$groupName}');" href="javascript:;" onmouseover="status='Click to activate.';return true;" onmouseout="status='';return true;">
						<div class="optionTitle">
							<xsl:value-of select="title"/>
						</div>
						<div class="optionImages">
							<xsl:for-each select="images/ifname">
								<xsl:variable name="imgref">
									<xsl:value-of select="."/>
								</xsl:variable>
								<img class="imagePreview" src="{$imgref}" style="border:1px solid black;"/>
							</xsl:for-each>
						</div>
						<div class="optionDescription">
							<!--<xsl:value-of select="translate(description,'[]','&lt;&gt;')"/>-->
							<xsl:value-of select="description"/>
						</div>
					</a>
					
				</xsl:for-each>
				
				</div>
				
				<xsl:if test="normalize-space(selection)='false'">
					<script>hideOptionContents('<xsl:value-of select="name"/>');</script>
					<p class="importantMessage">
						You are currently using none of the available options for this window. This may mean that you are using a non-GhostUI or custom modded window. It is strongly encouraged that you backup your custom folder before using one of these options. To see the options anyway <a href="javascript:showOptionContents('{$groupName}');">click here</a>.
					</p>
				</xsl:if>
				
				<hr size="1" class="optionContainerHr"/>
			</div>
			
		</xsl:for-each>			
		
		<hr size="1" class="optionContainerHr"/>
		
		<!--
		<a href="javascript: spitDom();">dom</a><br/>
		<a href="javascript: makeRequest('quit');">quit</a>
		-->

		</div>
		
		</div>
	
	</body>
</html>
</xsl:template>

</xsl:stylesheet>
