<if @elements:rowcount@ not nil>
<multiple name="elements">
<table bgcolor="lightblue" border="0" cellpadding="2" cellspacing="0" width="100%">
  <tr>
    <td width="15%">
      Curr Name!
    </td>
    <td>

<table bgcolor="#eeeedd" border="0" cellspacing="1" cellpadding="2" width="100%">
  <tr align="center">
  <group column="curriculum_id">
    <td>
    <if @elements.external_p@>
        <a href="@package_url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&@return_url_export@">
    </if>
    <else>
      <a href="@elements.url@">
    </else>
      <if @elements.checked_p@>
        <img src="@package_url@graphics/checked.gif" border="0" width="12" height="12" alt="Checked" title="@elements.name@ - visited">
      </if>
      <else>
        <img src="@package_url@graphics/unchecked.gif" border="0" width="12" height="12" alt="Unchecked" title="@elements.name@ - unvisited">
      </else>
      </a>
      <if @elements.external_p@>
        <a href="@package_url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&@return_url_export@">@elements.name@</a>
      </if>
      <else>
        <a href="@elements.url@">@elements.name@</a>
      </else>
    </td>
  </group>
  <if @elements:rowcount@ gt 0>
    <td>
      <a href="@package_url@curriculum-ave?curriculum_id=@elements.curriculum_id@">?</a>
    </td>
  </if>
  <if @logged_in_p@>
    <td>
     <a href="@package_url@remove-from-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@"><small>[Remove]</small></a>
    </td>
  </if>
  </tr>
</table>

    </td>
    <td width="5%">
      <a href="#" title="Refresh">Refresh!</a>
    </td>
  </tr>
</table>
<br>
</multiple>
</if>
