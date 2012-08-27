package be.lacerta.cq2.sim;

import be.lacerta.cq2.sim.hbn.Amulet;
import be.lacerta.cq2.sim.hbn.Creature;
import be.lacerta.cq2.sim.hbn.Race;
import be.lacerta.cq2.utils.CreatureFinder;
import java.io.PrintStream;
import javax.servlet.http.HttpServletRequest;

public class HatchdamageExtension extends AbstractSimExtension
{
  String toCalc;
  
  public void calc()
  {
    int kdLeveldef = getInt("defLvl" + toCalc);
    int kdLevelAtt = getInt("attLvl" + toCalc);
    int gdMinBuildingHealthLoss = 0;
    int gdMaxBuildingHealthLoss = 3;
    double gdKingdomLevelDifferenceMultiplier = 0.2D;
    int gdMaxKingdomLevelDifference = 10;
    int levelDiff = 0;

    int finaldamage = 0;
    double result = 0.0D;
    Creature crit = new Creature();

    if (Math.abs(kdLevelAtt - kdLeveldef) > gdMaxKingdomLevelDifference)
      levelDiff = gdMaxKingdomLevelDifference;
    else {
      levelDiff = Math.abs(kdLevelAtt - kdLeveldef);
    }

    double levelmultiplier = gdKingdomLevelDifferenceMultiplier + (1.0D - gdKingdomLevelDifferenceMultiplier) * (1.0D - levelDiff / gdMaxKingdomLevelDifference);

    double healthloss = gdMinBuildingHealthLoss + (gdMaxBuildingHealthLoss - gdMinBuildingHealthLoss) * levelmultiplier;

    for (int i = 0; getString("ammy" + toCalc + i) != ""; i++) {
      double multiplier = 1.0D;
      Amulet a = CreatureFinder.findAmulet(request.getParameter("ammy" + toCalc + i).trim());

      if ((a != null) && (a.getEss() == 0)) {
        crit = Creature.getCreature(a.getName());

        if (getString("isNether" + toCalc + i).equals("Nether")) {
          multiplier = 7.0D;
        }

        if (getString("isCursed" + toCalc + i).equals("Jinxed"))
          multiplier *= crit.getRace().gGetCreatureExponent(crit.getSkill()) * 0.3D;
        else {
          multiplier *= crit.getRace().gGetCreatureExponent(crit.getSkill());
        }

        if (getString("isEnchanted" + toCalc + i).equals("Enchanted")) {
          if (getString("enchanttype" + toCalc).equals("Topaz"))
            multiplier += (0.2D + 0.8D * (getInt("level" + toCalc) - 1) / 19.0D) * 0.8D * multiplier;
          else if (getString("enchanttype" + toCalc).equals("Emerald")) {
            multiplier += (0.2D + 0.8D * (getInt("level" + toCalc) - 1) / 19.0D) * 1.8D * multiplier;
          }
        }

        if (getInt("itheffect" + toCalc) != 0) {
          multiplier += getInt("itheffect" + toCalc) / 100.0D;
        }

        double critresult = 0.0D;
        if (toCalc.equals("Hatch")) {
          critresult = healthloss * multiplier * crit.getRace().getStealage() / 100.0D;
          request.setAttribute("crits", request.getAttribute("crits") + "A(n) " + crit.getName() + " will do " + critresult + "% damage. <br>");
        } else if (toCalc.equals("Shard")) {
          critresult = healthloss * multiplier * crit.getRace().getStealage3() / 100.0D;
          request.setAttribute("crits", request.getAttribute("crits") + "A(n) " + crit.getName() + " will do " + critresult + " damage to the shard vault. <br>");
        } else {
          critresult = healthloss * multiplier * crit.getRace().getStealage2() / 100.0D;
          request.setAttribute("crits", request.getAttribute("crits") + "A(n) " + crit.getName() + " steal " + critresult + "% of the treasury content. <br>");
        }

        result += critresult;
      }
      else
      {
        request.setAttribute("result", "Enter a correct critname please.");
      }
      finaldamage = (int)Math.round(result);

      if (toCalc.equals("Hatch")) {
        request.setAttribute("result", "This wave will do " + finaldamage + "% damage to the hatchery.");
      } else if (toCalc.equals("Shard")) {
        finaldamage *= 10;
        request.setAttribute("result", "This wave will do " + finaldamage + " damage to the shard vault.");
      } else {
        request.setAttribute("result", "This wave will steal " + finaldamage + "% of the treasury room.");
      }
    }

    setPath("/hatchcalc.jsp");
  }

  public void hatchCalc()
  {
  }

  public void shardCalc()
  {
  }

  public void run(String page)
  {
    String action = getString("action");
    request.setAttribute("action", action);
    request.setAttribute("result", " ");
    request.setAttribute("crits", " ");

    if ((action == null) || (action.equals(""))) {
      request.setAttribute("frmHatch", "block");
      request.setAttribute("frmShard", "none");
      request.setAttribute("frmTreasury", "none");
      request.setAttribute("selectbox", "frmHatch");
      setPath("/hatchcalc.jsp");
    } else if (action.equals("hatchcalc")) {
      request.setAttribute("frmHatch", "block");
      request.setAttribute("frmShard", "none");
      request.setAttribute("frmTreasury", "none");
      request.setAttribute("selectbox", "frmHatch");
      toCalc = "Hatch";
      calc();
    } else if (action.equals("shardcalc")) {
      request.setAttribute("frmHatch", "none");
      request.setAttribute("frmShard", "block");
      request.setAttribute("frmTreasury", "none");
      request.setAttribute("selectbox", "frmShard");
      toCalc = "Shard";
      calc();
    } else if (action.equals("treasurycalc")) {
      request.setAttribute("frmHatch", "none");
      request.setAttribute("frmShard", "none");
      request.setAttribute("frmTreasury", "block");
      request.setAttribute("selectbox", "frmTreasury");
      toCalc = "Treasury";
      calc();
    } else {
      setPath("/hatchcalc.jsp");
    }
  }
}