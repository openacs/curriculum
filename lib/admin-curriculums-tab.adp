<if @tabs_p@>

<table width="0">
  <tr>
    <td>
      <tabstrip id="states"></tabstrip>
    </td>
  </tr>
</table>

<include src="admin-curriculums" state_id="@states.tab@" workflow_id="@workflow_id@" \>

</if>
<else>

<include src="admin-curriculums" state_id="any" workflow_id="@workflow_id@" \>

</else>