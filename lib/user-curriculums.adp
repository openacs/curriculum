<if @elements:rowcount@ not nil>

<p>
  [
  <a href="start-over">Refresh all curriculums</a>
<if @logged_in_p@>
  |
  <a href="remove-from-bar">Remove all curriculums</a>
</if>
  ]
</p>

<table border="0" width="100%">
  <tr bgcolor="lightblue" border="0" cellpadding="0" cellspacing="1" width="100%">
    <th width="25%">Name</th>
    <th width="50%">Description</th>
    <th width="10%">Status</th>
    <th width="15%">Options</th>
  </tr>
</table>

<br>

<multiple name="elements">

<table bgcolor="lightblue" border="0" cellpadding="2" cellspacing="0" width="100%">
  <tr>
    <td width="25%">@elements.curriculum_name@</td>
    <td width="50%">@elements.curriculum_desc@</td>
    <td width="10%">
    <if @logged_in_p@>
      <if @elements.undesired_p@>
        Dropped/Removed
    </td>
    <td width="15%">
        <a href="add-to-bar?curriculum_id=@elements.curriculum_id@">Continue/Take</a>
      </if>
      <else>
        Ongoing/Completed
    </td>
    <td width="15%">
        <a href="start-over?curriculum_id=@elements.curriculum_id@">Refresh</a>
        |
        <a href="remove-from-bar?curriculum_id=@elements.curriculum_id@">Drop/Remove</a>
      </else>
    </if>
    <else>
      Ongoing/Completed
    </td>
    <td width="15%">
      <a href="start-over?curriculum_id=@elements.curriculum_id@">Refresh</a>
    </else>
    </td>
  </tr>
  <tr>
    <td colspan="4">

<table border="0" cellpadding="2" cellspacing="1" width="100%">
<ul>
<if @elements.element_id@ not nil>
  <group column="curriculum_id">
  <if @elements.groupnum@ odd><tr bgcolor="#eeeedd"></if><else><tr bgcolor="#eeeeee"></else>
    <td>
      <li>
        @elements.groupnum@.
        <a href="@elements.url@">@elements.element_name@</a>
      </li>
    </td>
    <td width="50%">@elements.element_desc;noquote@</td>
    <td width="10%">
      <if @elements.checked_p@>
        Visited
      </if>
      <else>
        Unvisited
      </else>
    </td>
    <td width="15%">
      <if @elements.checked_p@>
        <a href="@elements.url@">Revisit</a>
      </if>
      <else>
        <a href="@elements.url@">Visit</a>
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
</ul>
</table>

    </td>
  </tr>
</table>
<br>
</multiple>
</if>
<if @elements.curriculum_id@ nil>
<li>
  <i>No published curriculums</i>
</li>
</if>
