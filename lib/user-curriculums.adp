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

<table border="1" bgcolor="#eeeeee" width="100%">
  <tr>
    <th width="25%">Name</th>
    <th width="50%">Description</th>
    <th width="10%">Status</th>
    <th width="15%">Options</th>
  </tr>
</table>

<br>

<multiple name="elements">

<table border="1" bgcolor="#eeeeee" width="100%">
  <tr>
    <td width="25%">@elements.curriculum_name@</td>
    <td width="50%">@elements.curriculum_desc@</td>
    <td width="10%">
    <if @logged_in_p@>
      <if @elements.undesired_p@>
        Removed
      </if>
      <else>
        Displayed
      </else>
    </td>
    </if>
    <td width="15%">
      <a href="start-over?curriculum_id=@elements.curriculum_id@">Refresh</a>
    <if @logged_in_p@>
      |
      <if @elements.undesired_p@>
        <a href="add-to-bar?curriculum_id=@elements.curriculum_id@">Display</a>
      </if>
      <else>
        <a href="remove-from-bar?curriculum_id=@elements.curriculum_id@">Remove</a>
      </else>
    </if>
    </td>
  </tr>

<if @elements.element_id@ not nil>
  <group column="curriculum_id">


  <tr>
    <td colspan="4">
      <if @elements.groupnum_last_p@>
        Contains @elements.groupnum@ element(s). -- We could put the above table row in this row if that is better ...
      </if>
    </td>
  </tr>


  <tr>
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
</table>

<br>

</multiple>
</if>

<if @elements.curriculum_id@ nil>
<li>
  <i>No published curriculums</i>
</li>
</if>
