<p>
  <a href="admin-roles" class="button" title="#curriculum.lt_Default_assignees_for#">#curriculum.Default_Assignees#</a>
  <a href="/shared/parameters?@export_vars@" class="button" title="#curriculum.lt_Set_site-wide_prefere#">#curriculum.Package_parameters#</a>
  <a href="/permissions/one?object%5fid=@package_id@" class="button" title="#curriculum.lt_Administer_user_privi#">#curriculum.Package_permissions#</a>
  <a href="../doc/user.html#TEACHER" class="button" title="#curriculum.lt_Read_the_user_manual_#">#curriculum.Help#</a>
</p>

<if @curriculums:rowcount@ ne 0>
<table border="0" cellpadding="0" cellspacing="1" width="100%">
  <tr bgcolor="#cccccc">
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
      <a href="@notification_url@" class="button" title="@notification_title@">@notification_label@</a>
      <a href="curriculum-delete?@curriculums.curriculum_id_export@" class="button" onclick="return confirm('#curriculum.lt_Are_you_sure_you_want#');" title="#curriculum.lt_Delete_this_curriculu#">#curriculum.Delete#</a>
    </td>
    <td align="center" width="5%">
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
  <if @curriculums.groupnum@ even><tr bgcolor="#dbebf8"></if><else><tr bgcolor="#eeeeee"></else>
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
      <a href="element-disable?@curriculums.element_id_export@" class="button" title="#curriculum.lt_Deactivate_this_eleme#">#curriculum.Disable#</a>
    </if>
    <else>
      #curriculum.Disabled#
    </td>
    <td width="15%">
      <a href="element-enable?@curriculums.element_id_export@" class="button" title="#curriculum.lt_Activate_this_element#">#curriculum.Enable#</a>
      <a href="element-delete?@curriculums.element_id_export@" class="button" onclick="return confirm('#curriculum.lt_Are_you_sure_you_want_1#');" title="#curriculum.lt_Delete_this_element_a#">#curriculum.Delete#</a>
    </else>
    </td>
    <td align="center" width="20%">
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
  <tr bgcolor="#eeeeee">
    <td colspan="5">
      <i>#curriculum.No_elements#</i>
    </td>
  </tr>
  </else>
  <tr>
    <td bgcolor="#eeeedd" colspan="5">
      <a href="element-ave?@curriculums.curriculum_id_export@" class="button" title="#curriculum.Create_a_new_element#">#curriculum.Add_an_element#</a>
    </td>
  </tr>
</table>

</table>
<br />
</multiple>
</if>
<else>
  <i>#curriculum.No_curriculums#</i>
<br />
</else>
  <a href="curriculum-ave" class="button" title="#curriculum.lt_Create_a_new_curricul#">#curriculum.Add_a_curriculum#</a>
<br />
</table>

