<p>
  [
  <a href="/admin/site-map/parameter-set?package%5fid=@package_id@">Package parameters</a>
  |
  <a href="/permissions/one?object%5fid=@package_id@">Package permissions</a>
  ]
</p>

<if @curriculums:columns@ not nil>
<b>Here are the available columns:</b>
<p>@curriculums:columns@</p>
</if>

@debug_output;noquote@

<table border=1 bgcolor="#eeeeee">

<multiple name="curriculums">

<tr><td>

<li>
<a href="curriculum-ave?@curriculums.curriculum_id_export@">@curriculums.curriculum_name@</a>
-
[
<a href="curriculum-delete?@curriculums.curriculum_id_export@">delete</a>
<if @curriculums.curriculum_sort_order@ lt @curriculum_count@>
|
<a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=down">down</a>
</if>
<if @curriculums.rownum@ gt 1>
<a href="curriculum-swap?sort_order=@curriculums.curriculum_sort_order@&direction=up">up</a>
</if>
]
  <ul><br>Elements:

  <if @curriculums.element_id@ not nil>
  <group column="curriculum_id">
  <li>
  <a href="element-ave?@curriculums.curriculum_id_export@&@curriculums.element_id_export@">@curriculums.element_name@</a>
  -
  <a href="@curriculums.element_url@">@curriculums.element_url@</a>
  -
  [
  <if @curriculums.element_enabled_p@>
  <a href="element-disable?@curriculums.element_id_export@">disable</a>
  </if>
  <else>
  <font color="red">disabled</font>
  |
  <a href="element-enable?@curriculums.element_id_export@">enable</a>
  |
  <a href="element-delete?@curriculums.element_id_export@">delete</a>
  </else>
  <if @curriculums.groupnum_last_p@ false>
  |
  <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=down">down</a>
  </if>
  <if @curriculums.groupnum@ gt 1>
  <a href="element-swap?@curriculums.curriculum_id_export@&sort_order=@curriculums.element_sort_order@&direction=up">up</a>
  </if>
  ]
  </group>
  </if>
  <else>
  <li><i>No elements</i>
  </else>
  <li type="square"><a href="element-ave?@curriculums.curriculum_id_export@">Add an element</a>

  </ul>

<br>

</td></tr>

</multiple>

<if @curriculums.curriculum_id@ nil>
<li><i>No curriculums</i>
</if>

<li type="square"><a href="curriculum-ave">Add a curriculum</a>

</table>
