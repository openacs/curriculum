<if @elements:rowcount@ not nil>
<p>
  [
  <a href="@url@start-over?@return_url_export@" title="#curriculum.lt_Uncheck_the_visited_e#">#curriculum.lt_Reset_all_curriculums#</a>
<if @logged_in_p@>
  |
  <a href="@url@remove-from-bar?@return_url_export@" title="#curriculum.lt_Stop_displaying_the_c#">#curriculum.lt_Remove_all_curriculum#</a>
</if>
  |
  <a href="doc/user.html#STUDENT" title="#curriculum.lt_Read_the_user_manual_#">#curriculum.Help#</a>
  ]
</p>
<table border="0" width="100%">
  <tr bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="1" width="100%">
    <th width="25%">#curriculum.Name#</th>
    <th width="50%">#curriculum.Description#</th>
    <th width="10%">#curriculum.Status#</th>
    <th width="15%">#curriculum.Options#</th>
  </tr>
</table>
<multiple name="elements">
<br>
<table bgcolor="#cccccc" border="0" cellpadding="2" cellspacing="0" width="100%">
  <tr>
    <td width="25%">
      <a href="@url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="#curriculum.Detailed_information#">@elements.curriculum_name;noquote@</a>
    </td>
    <td width="50%">@elements.curriculum_desc;noquote@
      <if @elements.curr_desc_trunc_p@>
        ...
        [<a href="@url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="#curriculum.Complete_description#">#curriculum.more#</a>]
      </if>
    </td>
    <td width="10%">
    <if @logged_in_p@>
      <if @elements.undesired_p@>
        <if @elements.completed_p@>#curriculum.Removed#</if><else>#curriculum.Dropped#</else>
    </td>
    <td width="15%">
      <if @elements.completed_p@>
        <a href="@url@add-to-bar?curriculum_id=@elements.curriculum_id@&refresh_p=1&@return_url_export@" title="#curriculum.lt_Add_the_removed_curri#">#curriculum.Retake#</a>
      </if>
      <else>
        <a href="@url@add-to-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="#curriculum.lt_Add_the_dropped_curri#">#curriculum.Resume#</a>
      </else>
      </if>
      <else>
        <if @elements.completed_p@>#curriculum.Completed#</if><else>#curriculum.Ongoing#</else>
    </td>
    <td width="15%">
        <a href="@url@start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="#curriculum.lt_Uncheck_the_visited_e_1#">#curriculum.Reset#</a>
        |
        <a href="@url@remove-from-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="#curriculum.lt_Remove_the_curriculum#">
          <if @elements.completed_p@>#curriculum.Remove#</if><else>#curriculum.Drop#</else>
        </a>
      </else>
    </if>
    <else>
      <if @elements.completed_p@>#curriculum.Completed#</if><else>#curriculum.Ongoing#</else>
    </td>
    <td width="15%">
      <a href="@url@start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="#curriculum.lt_Uncheck_the_visited_e_1#">#curriculum.Reset#</a>
    </else>
    </td>
  </tr>
  <tr>
    <td colspan="4">

<table border="0" cellpadding="2" cellspacing="1" width="100%">
<if @elements.element_id@ not nil>
  <group column="curriculum_id">
  <if @elements.groupnum@ even><tr bgcolor="#eeeedd"></if><else><tr bgcolor="#eeeeee"></else>
    <td>
      &nbsp;
      &raquo;
      <a href="@url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" title="#curriculum.Detailed_information#">@elements.element_name;noquote@</a>
    </td>
    <td width="50%">@elements.element_desc;noquote@
      <if @elements.elem_desc_trunc_p@>
        ...
        [<a href="@url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" title="#curriculum.Complete_description#">#curriculum.more#</a>]
      </if>
    </td>
    <td width="10%">
    <if @elements.checked_p@>
      #curriculum.Visited#
    </td>
    <td width="15%">
      <if @elements.external_p@>
        <a href="@url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&position=@position@" title="#curriculum.lt_Visit_this_element_ag#">
      </if>
      <else><a href="@elements.url@" title="#curriculum.lt_Visit_this_element_ag#"></else>#curriculum.Revisit#</a>
    </if>
    <else>
      #curriculum.Unvisited#
    </td>
    <td width="15%">
      <if @elements.external_p@>
        <a href="@url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&position=@position@" title="#curriculum.Visit_this_element#">
      </if>
      <else><a href="@elements.url@" title="#curriculum.Visit_this_element#"></else>#curriculum.Visit#</a>
    </else>
    </td>
  </tr>
  </group>
</if>
<else>
  <li>
    <i>#curriculum.No_elements#</i>
  </li>
</else>
</table>

    </td>
  </tr>
</table>
</multiple>
</if>
<else>
<li>
  <i>#curriculum.lt_No_published_curricul#</i>
</li>
</else>

