<if @tabs_p@>

<table width="0">
  <tr>
    <td>
      #curriculum.lt_Show_curriculums_in_p#
      <tabstrip id="states"></tabstrip>
    </td>
  </tr>
</table>

<include src="admin-curriculums" state_id="@states.tab@" workflow_id="@workflow_id@" \>

</if>
<else>

<include src="admin-curriculums" state_id="any" workflow_id="@workflow_id@" \>

</else>
