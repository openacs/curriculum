<if @elements:rowcount@ not nil>

@community_name@:

<multiple name="elements">

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td width="75%">
      @indent;noquote@<a href="@url@curriculum-ave?curriculum_id=@elements.curriculum_id@" title="@elements.curriculum_desc;noquote@<if @elements.curr_desc_trunc_p@> ...</if>">@elements.curriculum_name;noquote@</a>
    </td>
    <td width="25%">
      <if @elements.completed_p@>#curriculum.Completed#</if><else>#curriculum.Ongoing#</else>
    </td>
  </tr>
</table>

</multiple>

</if>
<else>

<li>
  @community_name@: #curriculum.lt_No_published_curricul#
</li>

</else>

