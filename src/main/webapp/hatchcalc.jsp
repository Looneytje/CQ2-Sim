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
                        size="-1">Wave damage calculator</font></td>
                </tr>
            </table>

            <script language="JavaScript">
                var ammyRows = -1;
                function addAmuletRowToTable(tblName, form) {
                    if (ammyRows < 14) {
                        ammyRows++;
                        var row = document.getElementById('ammyTR' + form + ammyRows);
                        row.style.display = 'block';
                    }
                }

                function removeAmuletRowFromTable(tblName, form) {
                    if (ammyRows >= 0) {
                        var row = document.getElementById('ammyTR' +form + ammyRows);
                        row.style.display = 'none';
                        document.getElementById('ammy'+form + ammyRows).value = "";
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

                function correctForm() {
                    var frmName = document.getElementById("whichCalc").value;
                    $("#critsHatch").html("");
                    $("#resultHatch").html("");
                    $("#critsShard").html("");
                    $("#resultShard").html("");
                    $("#critsTreas").html("");
                    $("#resultTreas").html("");

                    if (frmName == "frmHatch") {
                        document.getElementById("frmHatch").style.display = "block";
                        document.getElementById("frmShard").style.display = "none";
                        document.getElementById("frmTreasury").style.display = "none";
                    } else if (frmName == "frmShard") {
                        document.getElementById("frmHatch").style.display = "none";
                        document.getElementById("frmShard").style.display = "block";
                        document.getElementById("frmTreasury").style.display = "none";
                    } else {
                        document.getElementById("frmHatch").style.display = "none";
                        document.getElementById("frmShard").style.display = "none";
                        document.getElementById("frmTreasury").style.display = "block";
                    }
                    return true;
                }
            </script>

            <zod:AutoCompleteJS type="amulet" />
            <form>
                Nethers will always be calculated to the max possible damage. If the result is incorrect, please contact Looney and blame stinusmeret.<br />
                <br /> 
                Select the building that gets the attack: 
                <select name="whichCalc" id="whichCalc" class="input" onChange="correctForm();">
                    <option value="frmHatch" <%if (request.getAttribute("selectbox") == "frmHatch") { %> selected="selected"<%};%>>Hatchery</option>
                    <option value="frmShard" <%if (request.getAttribute("selectbox") == "frmShard") { %> selected="selected"<%};%>>Shard vault</option>
                    <option value="frmTreasury" <%if (request.getAttribute("selectbox") == "frmTreasury") { %> selected="selected"<%};%>>Treasury room</option>
                </select>
            </form>

            <form method="post" action="?page=hatchcalc" id="frmShard" style="display: <%=request.getAttribute("frmShard")%>">
            <input type="hidden" name="action" value="shardcalc"/>
                <table>
                    <tr>
                        <td>Enchant:</td>
                        <td><select name="enchanttypeShard" class="input">
                                <option>No enchantment</option>
                                <option>Topaz</option>
                                <option>Emerald</option>
                        </select></td>
                        <td><input type="text" name="levelShard" class="input" size="5" /></td>
                    </tr>
                    <tr>
                        <td>Itherian:</td>
                        <td><input type="text" name="itheffectShard" size="10" class="input" />%</td>
                    </tr>
                    <tr>
                        <td>Attacking level:</td>
                        <td><input type="text" name="attLvlShard" size="5" class="input" />
                        </td>
                    </tr>
                    <tr>
                        <td>Defending level:</td>
                        <td><input type="text" name="defLvlShard" size="5" class="input" />
                        </td>
                    </tr>
                </table>

                Creatures in the wave:<br />
                <table border="0" cellpadding="1" cellspacing="0" id="tblAmulets">
                    <%
                        for (int i = 0; i <= 20; i++) {
                                    pageContext.setAttribute("i", i);
                    %>
                    <tr id="ammyTRshard<%=i%>" style="display: none">
                        <td><%=i+1%>. </td>
                        <td><zod:AutoInput type="amulet" name="ammyShard${i}" value="" size="40" /></td>
                        <td><input type="checkbox" name="isEnchantedShard${i}" value="Enchanted" checked>Wave enchanted</td>
                        <td><input type="checkbox" name="isCursedShard${i}" value="Jinxed">Jinxed</td>
                        <td><input type="checkbox" name="isNetherShard${i}" value="Nether">Nether</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2"><input type="button" value="Add" class="input" onclick="addAmuletRowToTable('tblAmulets', 'shard');" />&nbsp;
                            <input type="button" value="Remove" class="input" onclick="removeAmuletRowFromTable('tblAmulets', 'shard');" /></td>
                    </tr>
                </table>

                <br /> <input type="submit" value="Submit" class="input" /> <br />
                <br />
                <div id="critsShard"><%=request.getAttribute("crits")%></div>
                <br />

                <div id="resultShard"><%=request.getAttribute("result")%></div>
            </form>

            <form method="post" action="?page=hatchcalc" id="frmTreasury" style="display: <%=request.getAttribute("frmTreasury")%>">
            <input type="hidden" name="action" value="treasurycalc"/>
                <table>
                    <tr>
                        <td>Itherian:</td>
                        <td><input type="text" name="itheffectTreasury" size="10" class="input" />%</td>
                    </tr>
                    <tr>
                        <td>Attacking level:</td>
                        <td><input type="text" name="attLvlTreasury" size="5" class="input" />
                        </td>
                    </tr>
                    <tr>
                        <td>Defending level:</td>
                        <td><input type="text" name="defLvlTreasury" size="5" class="input" />
                        </td>
                    </tr>
                </table>

                Creatures in the wave:<br />
                <table border="0" cellpadding="1" cellspacing="0" id="tblAmulets">
                    <%
                        for (int i = 0; i <= 20; i++) {
                                    pageContext.setAttribute("i", i);
                    %>
                    <tr id="ammyTRTreasury<%=i%>" style="display: none">
                        <td><%=i+1%>. </td>
                        <td><zod:AutoInput type="amulet" name="ammyTreasury${i}" value="" size="40" /></td>
                        <td><input type="checkbox" name="isCursedTreasury${i}" value="Jinxed">Jinxed</td>
                        <td><input type="checkbox" name="isNetherTreasury${i}" value="Nether">Nether</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2"><input type="button" value="Add" class="input" onclick="addAmuletRowToTable('tblAmulets','Treasury');" />&nbsp;
                            <input type="button" value="Remove" class="input" onclick="removeAmuletRowFromTable('tblAmulets', 'Treasury');" /></td>
                    </tr>
                </table>

                <br /> <input type="submit" value="Submit" class="input" /> <br />
                <br />
                <div id="critsTreas"><%=request.getAttribute("crits")%></div>
                <br />

                <div id="resultTreas"><%=request.getAttribute("result")%></div>
            </form>

            <form method="post" action="?page=hatchcalc" id="frmHatch" style="display: <%=request.getAttribute("frmHatch")%>">
            <input type="hidden" name="action" value="hatchcalc"/>
                <table>
                    <tr>
                        <td>Enchant:</td>
                        <td><select name="enchanttypeHatch" class="input">
                                <option>No enchantment</option>
                                <option>Topaz</option>
                                <option>Emerald</option>
                        </select></td>
                        <td><input type="text" name="levelHatch" class="input" size="5" /></td>
                    </tr>
                    <tr>
                        <td>Itherian:</td>
                        <td><input type="text" name="itheffectHatch" size="10" class="input" />%</td>
                    </tr>
                    <tr>
                        <td>Attacking level:</td>
                        <td><input type="text" name="attLvlHatch" size="5" class="input" />
                        </td>
                    </tr>
                    <tr>
                        <td>Defending level:</td>
                        <td><input type="text" name="defLvlHatch" size="5" class="input" />
                        </td>
                    </tr>
                </table>

                Creatures in the wave:<br />
                <table border="0" cellpadding="1" cellspacing="0" id="tblAmulets">
                    <%
                        for (int i = 0; i <= 20; i++) {
                                    pageContext.setAttribute("i", i);
                    %>
                    <tr id="ammyTRHatch<%=i%>" style="display: none">
                        <td><%=i+1%>. </td>
                        <td><zod:AutoInput type="amulet" name="ammyHatch${i}" value="" size="40" /></td>
                        <td><input type="checkbox" name="isEnchantedHatch${i}" value="Enchanted" checked>Wave enchanted</td>
                        <td><input type="checkbox" name="isCursedHatch${i}" value="Jinxed">Jinxed</td>
                        <td><input type="checkbox" name="isNetherHatch${i}" value="Nether">Nether</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2"><input type="button" value="Add" class="input" onclick="addAmuletRowToTable('tblAmulets', 'Hatch');" />&nbsp;
                            <input type="button" value="Remove" class="input" onclick="removeAmuletRowFromTable('tblAmulets', 'Hatch');" /></td>
                    </tr>
                </table>

                <br /> <input type="submit" value="Submit" class="input" /> <br />
                <br />
                <div id="critsHatch"><%=request.getAttribute("crits")%></div>
                <br />

                <div id="resultHatch"><%=request.getAttribute("result")%></div>
            </form>
        </div>

    </c:otherwise>
</c:choose>
<%@ include file="include/footer.jsp"%>