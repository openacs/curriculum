<p>
  [
  <a href="/admin/site-map/parameter-set?@export_vars@">Package parameters</a>
  |
  <a href="/permissions/one?object%5fid=@package_id@">Package permissions</a>
  ]
</p>
<if @curriculums:rowcount@ ne 0>
<p align="right">
  <a href="thorough-flush">I'm done now, update the bar for everyone! (Use sparingly)</a>
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
<br />
<multiple name="curriculums">
<tcl>
# Single-curriculum notifications link.
set notification_link [curriculum::get_watch_link -curriculum_id $curriculums(curriculum_id)]
foreach { notification_url notification_label notification_title } $notification_link {
    # Do nothing!
}
</tcl>
<table bgcolor="#cccccc" border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr>
    <td width="20%">
      <a href="curriculum-ave?@curriculums.curriculum_id_export@">@curriculums.curriculum_name;noquote@</a>
    </td>
    <td width="50%">
      @curriculums.curriculum_desc;noquote@
      <if @curriculums.curr_desc_trunc_p@>
        ...
        [<a href="curriculum-ave?curriculum_id=@curriculums.curriculum_id@" title="Complete description">more</a>]
      </if>
    </td>
    <td width="10%">
      @curriculums.pretty_state@
    </td>
    <td width="15%">
      <a href="@notification_url@" title="@notification_title@">@notification_label@</a>
      <a href="curriculum-delete?@curriculums.curriculum_id_export@" onclick="return confirm('Are you sure you want to delete this curriculum?');" title="Delete">
        <img src="/shared/images/Delete16.gif" border="0" width="16" height="16">
      </a>
    </td>
    <td width="5%">
    <if @curriculums.rownum@ gt 1>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=up" alt="^" title="Move up">
        <img src="../graphics/up.gif" border="0" width="15" height="15"></a>
    </if>
    <if @curriculums.curriculum_sort_order@ lt @curriculum_count@>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=down" alt="v" title="Move down">
        <img src="../graphics/down.gif" border="0" width="15" height="15">
      </a>
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
        <a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@">@curriculums.element_name;noquote@</a>
      </li>
    </td>
    <td width="50%">
      @curriculums.element_desc;noquote@
      <if @curriculums.elem_desc_trunc_p@>
        ...
        [<a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@" title="Complete description">more</a>]
      </if>
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
    <td width="15%">
      <a href="element-enable?@curriculums.element_id_export@">Enable</a>
      <a href="element-delete?@curriculums.element_id_export@" onclick="return confirm('Are you sure you want to delete this element?');" title="Delete">
        <img src="/shared/images/Delete16.gif" border="0" width="16" height="16">
      </a>
    </else>
    </td>
    <td width="20%">
    <if @curriculums.groupnum@ gt 1>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=up" alt="^" title="Move up">
        <img src="../graphics/up.gif" border="0" width="15" height="15"></a>
    </if>
    <if @curriculums.groupnum_last_p@ false>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=down" alt="v" title="Move down">
        <img src="../graphics/down.gif" border="0" width="15" height="15">
      </a>
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
<br />
</multiple>
</if>
<else>
<li>
  <i>No curriculums</i>
</li>
<br />
</else>
<li type="square">
  <a href="curriculum-ave">Add a curriculum</a>
</li>
<br />
</table>
