<html>
  <head>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
    <title>External Element</title>
  </head>
<switch @position@>
 <case value="top">
  <frameset rows="20%,*">
    <frame src="horizontal" frameborder="1">
    <frame src="@destination_url@">
 </case>
 <case value="bottom">
  <frameset rows="*,20%">
    <frame src="@destination_url@">
    <frame src="horizontal" frameborder="1">
 </case>
 <case value="left">
  <frameset cols="20%,*">
    <frame src="vertical" frameborder="1">
    <frame src="@destination_url@">
 </case>
 <case value="right">
  <frameset cols="*,20%">
    <frame src="@destination_url@">
    <frame src="vertical" frameborder="1">
 </case>
 <default>
  <frameset rows="20%,*">
    <frame src="horizontal" frameborder="1">
    <frame src="@destination_url@">
 </default>
</switch>
  </frameset>
</html>
