<html>
  <head>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
    <title>#curriculum.External_Element#</title>
  </head>
<switch @position@>
 <case value="top">
  <frameset rows="20%,*">
    <frame src="horizontal?@export_vars@" frameborder="1">
    <frame src="@destination_url@">
 </case>
 <case value="bottom">
  <frameset rows="*,20%">
    <frame src="@destination_url@">
    <frame src="horizontal?@export_vars@" frameborder="1">
 </case>
 <case value="left">
  <frameset cols="20%,*">
    <frame src="vertical?@export_vars@" frameborder="1">
    <frame src="@destination_url@">
 </case>
 <case value="right">
  <frameset cols="*,20%">
    <frame src="@destination_url@">
    <frame src="vertical?@export_vars@" frameborder="1">
 </case>
 <default>
  <frameset rows="20%,*">
    <frame src="horizontal?@export_vars@" frameborder="1">
    <frame src="@destination_url@">
 </default>
</switch>
  </frameset>
</html>

