<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @start_over_url@ not nil>
<p>
  <a href="@start_over_url@" title="@start_over_title@">@start_over_label@</a>
</p>
</if>

<if @notification_link@ not nil>
<p>
  <a href="@notification_url@" title="@notification_title@">@notification_label@</a>
</p>
</if>

<formtemplate id="curriculum"></formtemplate>
