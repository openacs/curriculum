<if @elements:rowcount@ not nil>
<multiple name="elements">
<table bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <th width="15%">
      <img src="@package_url@graphics/unchecked.gif" border="0" width="12" height="12" alt="Unchecked" title="FIXME. Ongoing">
      |
      Curriculum Name
      |
      <a href="@package_url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="Info">i</a>
    </th>
    <td>

<table bgcolor="#cccccc" border="0" cellspacing="2" cellpadding="2" width="100%">
  <tr align="center" bgcolor="#eeeeee">
  <group column="curriculum_id">
    <td>
      <if @elements.checked_p@>
        <img src="@package_url@graphics/checked.gif" border="0" width="12" height="12" alt="Checked" title="@elements.name@ - visited">
      </if>
      <else>
        <img src="@package_url@graphics/unchecked.gif" border="0" width="12" height="12" alt="Unchecked" title="@elements.name@ - unvisited">
      </else>
      |
      <if @elements.external_p@>
        <a href="@package_url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&@return_url_export@">@elements.name@</a>
      </if>
      <else>
        <a href="@elements.url@">@elements.name@</a>
      </else>
      |
      <a href="@package_url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" title="Info">i</a>
    </td>
  </group>
  </tr>
</table>

    </td>
    <th width="5%">
      <a href="start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Refresh">¤</a>
      <if @logged_in_p@>
      |
      <a href="@package_url@remove-from-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Remove">X</a>
      </if>
    </th>
  </tr>
</table>
<br>
</multiple>
</if>
