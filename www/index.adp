<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @admin_p@>
<p align="right">
  <a href="admin/">#curriculum.lt_Administer_Curriculum#</a>
</p>
</if>

<include src="../lib/user-curriculums" />

