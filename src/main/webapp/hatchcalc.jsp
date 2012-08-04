<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/zod.tld" prefix="zod"%>
<%@page import="be.lacerta.cq2.sim.hbn.User"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="be.lacerta.cq2.objects.Gem"%>
<%@ include file="include/init.jsp"%>
<%@ include file="include/header.jsp"%>
<c:choose>
	<c:when test="${!zod:hasAccess(user,Constants.RIGHTS_ALL)}">What are you doing here?</c:when>
	<c:otherwise>
		<%@ include file="include/menu.jsp"%>

		<div class="porlet" id="p-content">

			<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
				pageEncoding="ISO-8859-1"%>

			<table width="100%">
				<tr>
					<td class="titleline" width="100%"><font class="head"
						size="-1">Hatchdamage calculator</font></td>
				</tr>
			</table>

<script language="JavaScript">
                var ammyRows = -1;
                function addAmuletRowToTable(tblName) {
                    if (ammyRows < 20) {
                        ammyRows++;
                        var row = document.getElementById('ammyTR' + ammyRows);
                        row.style.display = 'block';
                    }
                }

                function removeAmuletRowFromTable() {
                    if (ammyRows >= 0) {
                        var row = document.getElementById('ammyTR' + ammyRows);
                        row.style.display = 'none';
                        document.getElementById('ammy' + ammyRows).value = "";
                        ammyRows--;
                    }
                }

                function fixForm(tblName) {
                    var form = document.getElementById('frmAmulets');
                    var button = document.getElementById('sbmAmulets');
                    var tabel = document.getElementById(tblName);

                    form.insertBefore(tabel, form.childNodes.item(0));

                    var inputs = form.elements;
                    buffer = "";
                    for (i = 0; i < inputs.length; i++)
                        buffer += inputs[i].name + "=" + inputs[i].value + "\n";

                    return true;
                }
            </script>

			<zod:AutoCompleteJS type="amulet" />

			<form method="post" action="?page=hatchcalc" id="frmAmulets">
				<input type="hidden" name="action" value="hatchcalc" />
            Nethers will always be calculated to the max possible damage. If the result is incorrect, please contact Looney and blame stinusmeret.<br/><br/>
				<table>
					<tr>
						<td>Enchant:</td>
						<td><select name="enchanttype" class="input">
								<option>No enchantment</option>
								<option>Topaz</option>
								<option>Emerald</option>
						</select></td>
						<td><input type="text" name="level" class="input" size="5" /></td>
					</tr>
					<tr>
                        <td>Itherian:</td>
                        <td><input type="text" name="itheffect" size="10" class="input" />%
                        </td>
                    </tr>
					<tr>
						<td>Attacking level:</td>
						<td><input type="text" name="attLvl" size="5" class="input" />
						</td>
					</tr>
					<tr>
						<td>Defending level:</td>
						<td><input type="text" name="defLvl" size="5" class="input" />
						</td>
					</tr>
				</table>
				
				Creatures in the wave:<br />
				<table border="0" cellpadding="1" cellspacing="0" id="tblAmulets">
                    <%
                        for (int i = 0; i <= 20; i++) {
                                    pageContext.setAttribute("i", i);
                    %>
                    <tr id="ammyTR<%=i%>" style="display: none">
                        <td><zod:AutoInput type="amulet" name="ammy${i}" value="" size="40" /></td>
                        <td><input type="checkbox" name="isEnchanted${i}" value="Enchanted" checked>Wave enchanted</td>
                        <td><input type="checkbox" name="isCursed${i}" value="Jinxed">Jinxed</td>
                        <td><input type="checkbox" name="isNether${i}" value="Nether">Nether</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2"><input type="button" value="Add"
                            class="input" onclick="addAmuletRowToTable('tblAmulets');" />&nbsp;
                            <input type="button" value="Remove" class="input"
                            onclick="removeAmuletRowFromTable('tblAmulets');" /></td>
                    </tr>
                </table>

				<br /> <input type="submit" value="Submit" class="input" /> <br />
				<br />
<%=request.getAttribute("crits")%>
<br />

				<%=request.getAttribute("result")%>
			</form>
		</div>

	</c:otherwise>
</c:choose>
<%@ include file="include/footer.jsp"%>