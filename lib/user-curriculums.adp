<if @elements:rowcount@ not nil>
<p>
  [
  <a href="@url@start-over?@return_url_export@" title="Uncheck the visited elements in all curriculums">Reset all curriculums</a>
<if @logged_in_p@>
  |
  <a href="@url@remove-from-bar?@return_url_export@" title="Stop displaying the curriculum toolbar">Remove all curriculums</a>
</if>
  |
  <a href="doc/user.html#STUDENT" title="Read the user manual for this page">Help</a>
  ]
</p>
<table border="0" width="100%">
  <tr bgcolor="#cccccc" border="0" cellpadding="0" cellspacing="1" width="100%">
    <th width="25%">Name</th>
    <th width="50%">Description</th>
    <th width="10%">Status</th>
    <th width="15%">Options</th>
  </tr>
</table>
<multiple name="elements">
<br>
<table bgcolor="#cccccc" border="0" cellpadding="2" cellspacing="0" width="100%">
  <tr>
    <td width="25%">
      <a href="@url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="Detailed information">@elements.curriculum_name;noquote@</a>
    </td>
    <td width="50%">@elements.curriculum_desc;noquote@
      <if @elements.curr_desc_trunc_p@>
        ...
        [<a href="@url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="Complete description">more</a>]
      </if>
    </td>
    <td width="10%">
    <if @logged_in_p@>
      <if @elements.undesired_p@>
        <if @elements.completed_p@>Removed</if><else>Dropped</else>
    </td>
    <td width="15%">
      <if @elements.completed_p@>
        <a href="@url@add-to-bar?curriculum_id=@elements.curriculum_id@&refresh_p=1&@return_url_export@" title="Add the removed curriculum to the toolbar">Retake</a>
      </if>
      <else>
        <a href="@url@add-to-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Add the dropped curriculum to the toolbar">Resume</a>
      </else>
      </if>
      <else>
        <if @elements.completed_p@>Completed</if><else>Ongoing</else>
    </td>
    <td width="15%">
        <a href="@url@start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Uncheck the visited elements">Reset</a>
        |
        <a href="@url@remove-from-bar?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Remove the curriculum from the toolbar">
          <if @elements.completed_p@>Remove</if><else>Drop</else>
        </a>
      </else>
    </if>
    <else>
      <if @elements.completed_p@>Completed</if><else>Ongoing</else>
    </td>
    <td width="15%">
      <a href="@url@start-over?curriculum_id=@elements.curriculum_id@&@return_url_export@" title="Uncheck the visited elements">Reset</a>
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
      <a href="@url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" title="Detailed information">@elements.element_name;noquote@</a>
    </td>
    <td width="50%">@elements.element_desc;noquote@
      <if @elements.elem_desc_trunc_p@>
        ...
        [<a href="@url@element-ave?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@" title="Complete description">more</a>]
      </if>
    </td>
    <td width="10%">
    <if @elements.checked_p@>
      Visited
    </td>
    <td width="15%">
      <if @elements.external_p@>
        <a href="@url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&position=@position@" title="Visit this element again">
      </if>
      <else><a href="@elements.url@" title="Visit this element again"></else>Revisit</a>
    </if>
    <else>
      Unvisited
    </td>
    <td width="15%">
      <if @elements.external_p@>
        <a href="@url@ext?curriculum_id=@elements.curriculum_id@&element_id=@elements.element_id@&position=@position@" title="Visit this element">
      </if>
      <else><a href="@elements.url@" title="Visit this element"></else>Visit</a>
    </else>
    </td>
  </tr>
  </group>
</if>
<else>
  <li>
    <i>No elements</i>
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
  <i>No published curriculums</i>
</li>
</else>
