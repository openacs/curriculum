<p>
  [
  <a href="/admin/site-map/parameter-set?@export_vars@" title="#curriculum.lt_Set_site-wide_prefere#">#curriculum.Package_parameters#</a>
  |
  <a href="/permissions/one?object%5fid=@package_id@" title="#curriculum.lt_Administer_user_privi#">#curriculum.Package_permissions#</a>
  |
  <a href="../doc/user.html#TEACHER" title="#curriculum.lt_Read_the_user_manual_#">#curriculum.Help#</a>
  ]
</p>
<if @curriculums:rowcount@ ne 0>
<p align="right">
  <a href="thorough-flush" title="#curriculum.lt_Update_the_toolbar_fo#">#curriculum.lt_Im_done_now_update_th#</a>
</p>
<table border="0" width="100%">
  <tr bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="0" width="100%">
    <th width="20%">#curriculum.Name#</th>
    <th width="50%">#curriculum.Description#</th>
    <th width="10%">#curriculum.State#</th>
    <th width="15%">#curriculum.Actions#</th>
    <th width="5%">#curriculum.Move#</th>
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
      <a href="curriculum-ave?@curriculums.curriculum_id_export@" title="#curriculum.lt_Administer_this_curri#">@curriculums.curriculum_name;noquote@</a>
    </td>
    <td width="50%">
      @curriculums.curriculum_desc;noquote@
      <if @curriculums.curr_desc_trunc_p@>
        ...
        [<a href="curriculum-ave?curriculum_id=@curriculums.curriculum_id@" title="#curriculum.Complete_description#">#curriculum.more#</a>]
      </if>
    </td>
    <td width="10%">
      @curriculums.pretty_state@
    </td>
    <td width="15%">
      <a href="@notification_url@" title="@notification_title@">@notification_label@</a>
      |
      <a href="curriculum-delete?@curriculums.curriculum_id_export@" onclick="return confirm('#curriculum.lt_Are_you_sure_you_want#');" title="#curriculum.lt_Delete_this_curriculu#">#curriculum.Delete#</a>
    </td>
    <td width="5%">
    <if @curriculums.rownum@ gt 1>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=up" alt="^" title="#curriculum.Move_up#">
        <img src="../graphics/up.gif" border="0" width="15" height="15"></a>
    </if>
    <if @curriculums.curriculum_sort_order@ lt @curriculum_count@>
      <a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=down" alt="v" title="#curriculum.Move_down#">
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
      &nbsp;
      &raquo;
        <a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@" title="#curriculum.lt_Administer_this_eleme#">@curriculums.element_name;noquote@</a>
    </td>
    <td width="50%">
      @curriculums.element_desc;noquote@
      <if @curriculums.elem_desc_trunc_p@>
        ...
        [<a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@" title="#curriculum.Complete_description#">#curriculum.more#</a>]
      </if>
    </td>
    <td width="10%">
    <if @curriculums.element_enabled_p@>
      #curriculum.Enabled#
    </td>
    <td width="15%">
      <a href="element-disable?@curriculums.element_id_export@" title="#curriculum.lt_Deactivate_this_eleme#">#curriculum.Disable#</a>
    </if>
    <else>
      #curriculum.Disabled#
    </td>
    <td width="15%">
      <a href="element-enable?@curriculums.element_id_export@" title="#curriculum.lt_Activate_this_element#">#curriculum.Enable#</a>
      |
      <a href="element-delete?@curriculums.element_id_export@" onclick="return confirm('#curriculum.lt_Are_you_sure_you_want_1#');" title="#curriculum.lt_Delete_this_element_a#">#curriculum.Delete#</a>
    </else>
    </td>
    <td width="20%">
    <if @curriculums.groupnum@ gt 1>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=up" alt="^" title="#curriculum.Move_up#">
        <img src="../graphics/up.gif" border="0" width="15" height="15"></a>
    </if>
    <if @curriculums.groupnum_last_p@ false>
      <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=down" alt="v" title="#curriculum.Move_down#">
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
        <i>#curriculum.No_elements#</i>
      </li>
    </td>
  </tr>
  </else>
  <tr>
    <td bgcolor="beige" colspan="5">
      <li type="square">
        <a href="element-ave?@curriculums.curriculum_id_export@" title="#curriculum.Create_a_new_element#">#curriculum.Add_an_element#</a>
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
  <i>#curriculum.No_curriculums#</i>
</li>
<br />
</else>
<li type="square">
  <a href="curriculum-ave" title="#curriculum.lt_Create_a_new_curricul#">#curriculum.Add_a_curriculum#</a>
</li>
<br />
</table>

