<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @admin_p@>
<p align="right">
  <a href="admin/">Administer Curriculum</a>
</p>
</if>

<include src="../lib/user-curriculums" />
