<if @curriculums:columns@ not nil>
<b>Available columns:</b>
<p>@curriculums:columns@</p>
</if>
@debug_output;noquote@

<p>
  [
  <a href="/admin/site-map/parameter-set?package%5fid=@package_id@">Package parameters</a>
  |
  <a href="/permissions/one?object%5fid=@package_id@">Package permissions</a>
  ]
</p>
<table border="0" width="100%">
  <tr bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
    <th width="20%">Name</th>
    <th width="50%">Description</th>
    <th width="10%">State</th>
    <th width="15%">Actions</th>
    <th width="5%">Move</th>
  </tr>
</table>
<br>
<multiple name="curriculums">
<table bgcolor="#cccccc" border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr>
    <td width="20%">
      <a href="curriculum-ave?@curriculums.curriculum_id_export@">@curriculums.curriculum_name@</a>
    </td>
    <td width="50%">
      @curriculums.curriculum_desc;noquote@
    </td>
    <td width="10%">
      @curriculums.pretty_state@
    </td>
    <td width="15%">
      WF ACTIONS
      |
      <a href="curriculum-delete?@curriculums.curriculum_id_export@">delete</a>
    </td>
    <td width="5%">
    <if @curriculums.curriculum_sort_order@ lt @curriculum_count@>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=down">down</a>
    </if>
    <if @curriculums.rownum@ gt 1>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=up">up</a>
    </if>
    </td>
  </tr>
  <tr>
    <td colspan="5">

<table border="0" cellpadding="2" cellspacing="1" width="100%">

  <if @curriculums.element_id@ not nil>
  <group column="curriculum_id">
  <if @curriculums.groupnum@ even><tr bgcolor="#eeeedd"></if><else><tr bgcolor="#eeeeee"></else>
    <td width="20%">
      <li>
        <a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@">@curriculums.element_name@</a>
      </li>
    </td>
    <td width="50%">
      @curriculums.element_desc;noquote@
    </td>
    <td width="10%">
    <if @curriculums.element_enabled_p@>
      Enabled
    </td>
    <td width="15%">
      <a href="element-disable?@curriculums.element_id_export@">Disable</a>
    </if>
    <else>
      Disabled
    </td>
    <td width="5%">
      <a href="element-enable?@curriculums.element_id_export@">Enable</a>
      |
      <a href="element-delete?@curriculums.element_id_export@">Delete</a>
    </else>
    </td>
    <td width="20%">
    <if @curriculums.groupnum_last_p@ false>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=down">down</a>
    </if>
    <if @curriculums.groupnum@ gt 1>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=up">up</a>
    </if>
    </td>
  </tr>
  </group>
  </if>
  <else>
  <tr bgcolor="#eeeedd">
    <td colspan="5">
      <li>
        <i>No elements</i>
      </li>
    </td>
  </tr>
  </else>
  <tr>
    <td bgcolor="beige" colspan="5">
      <li type="square">
        <a href="element-ave?@curriculums.curriculum_id_export@">Add an element</a>
      </li>
    </td>
  </tr>
</table>

</table>
<br>
</multiple>

<if @curriculums.curriculum_id@ nil>
<li>
  <i>No curriculums</i>
</li>
</if>
<li type="square">
  <a href="curriculum-ave">Add a curriculum</a>
</li>
<br>
</table>
