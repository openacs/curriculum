<if @elements:rowcount@ not nil>
<multiple name="elements">
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <th nowrap>
    <if @elements.completed_p@>
      <img src="/shared/images/checkboxchecked.gif" border="0" width="13" height="13" alt="X" title="Completed">
    </if>
    <else>
      <img src="/shared/images/checkbox.gif" border="0" width="13" height="13" alt="O" title="Ongoing">
    </else>
      @elements.curriculum_name;noquote@
      <a href="@package_url@curriculum-ave?curriculum_id=@elements.curriculum_id@" target="_top">
      <img src="@package_url@graphics/info.gif" border="0" width="12" height="12" alt="i" title="Information">
      </a>
    </th>
  </tr>
    <td nowrap>

<table bgcolor="#cccccc" border="0" cellspacing="2" cellpadding="2" width="100%">
  <group column="curriculum_id">
  <tr bgcolor="#eeeeee">
    <td>
      <if @elements.checked_p@>
        <img src="/shared/images/checkboxchecked.gif" border="0" width="13" height="13" alt="X" title="Visited">
      </if>
      <else>
        <img src="/shared/images/checkbox.gif" border="0" width="13" height="13" alt="O" title="Unvisited">
      </else>
      <if @elements.external_p@>
        <a href="@package_url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&@return_url_export@&position=@position@" target="_top" title="Visit">@elements.name@</a>
      </if>
      <else>
        <a href="@elements.url@" target="_top" title="Visit">@elements.name@</a>
      </else>
      <a href="@package_url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" target="_top">
        <img src="@package_url@graphics/info.gif" border="0" width="12" height="12" alt="i" title="Information">
      </a>
    </td>
  </tr>
  </group>
</table>

    </td>
  </tr>
  <tr>
    <th nowrap">
      <a href="@package_url@start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@"><img src="@package_url@graphics/refresh.jpg" border="0" width="13" height="14" alt="Refresh" title="Refresh"></a>
      <if @logged_in_p@>
      <a href="@package_url@remove-from-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@">
        <img src="@package_url@graphics/remove.jpg" border="0" width="15" height="13" alt="X" title="Remove">
      </a>
      </if>
    </th>
  </tr>
</table>
<br>
</multiple>
</if>
