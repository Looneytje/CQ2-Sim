package be.lacerta.cq2.sim;

import java.util.HashMap;
import java.util.List;

import be.lacerta.cq2.sim.hbn.Amulet;
import be.lacerta.cq2.sim.hbn.Creature;
import be.lacerta.cq2.sim.hbn.Itherian;
import be.lacerta.cq2.sim.hbn.Race;
import be.lacerta.cq2.sim.hbn.Sacrifices;
import be.lacerta.cq2.sim.hbn.User;
import be.lacerta.cq2.utils.CreatureFinder;
import be.lacerta.cq2.utils.StringUtils;

public class HatchdamageExtension extends AbstractSimExtension {

	public void calc() {
		int kdLeveldef = getInt("defLvl");
		int kdLevelAtt = getInt("attLvl");
		int gdMinBuildingHealthLoss = 0;
		int gdMaxBuildingHealthLoss = 3;
		double gdKingdomLevelDifferenceMultiplier = 0.2;
		int gdMaxKingdomLevelDifference = 10;
		int levelDiff = 0;
		
		int finaldamage = 0;
		double result = 0;
		Creature crit = new Creature();

		if (Math.abs(kdLevelAtt - kdLeveldef) > gdMaxKingdomLevelDifference) {
			levelDiff = gdMaxKingdomLevelDifference;
		} else {
			levelDiff = Math.abs(kdLevelAtt - kdLeveldef);
		}
	
		double levelmultiplier = gdKingdomLevelDifferenceMultiplier + (1 - gdKingdomLevelDifferenceMultiplier) * (1 - (double) levelDiff / (double) gdMaxKingdomLevelDifference);

		double healthloss = gdMinBuildingHealthLoss + (gdMaxBuildingHealthLoss - gdMinBuildingHealthLoss) * levelmultiplier;
		

		for (int i = 0; getString("ammy" + i) != ""; i++) {
			double multiplier = 1;
			Amulet a = CreatureFinder.findAmulet(request.getParameter("ammy"+i).trim());

			if (a != null && a.getEss() == 0) {
				crit = Creature.getCreature(a.getName());

				if (getString("isNether"+i).equals("Nether")) {
					multiplier = 7;
				}

				if (getString("isCursed"+i).equals("Jinxed")) {
					multiplier *= crit.getRace().gGetCreatureExponent(crit.getSkill()) * 0.3;
				} else {
					multiplier *= crit.getRace().gGetCreatureExponent(crit.getSkill());
				}
				
				if (getString("isEnchanted"+i).equals("Enchanted")){
					if (getString("enchanttype").equals("Topaz")) {
						multiplier += (((0.2 + 0.8 * (getInt("level") - 1) / 19) * 0.8) * multiplier);
					} else if (getString("enchanttype").equals("Emerald")) {
						multiplier += (((0.2 + 0.8 * (getInt("level") - 1) / 19) * 1.8) * multiplier);
					}
				}
				
				if (getInt("itheffect") != 0) {
					multiplier += (double) getInt("itheffect") / 100;
				}
				
				double critresult = healthloss * multiplier * crit.getRace().getStealage() / 100;
				
				result += critresult;
				
				request.setAttribute("crits", request.getAttribute("crits") + "A(n) " + crit.getName() + " will do " + critresult + "% damage. <br>");
				
			} else {
				request.setAttribute("result", "Enter a correct critname please.");
			}
			finaldamage = (int) Math.round(result);
			request.setAttribute("result", "This wave will do " + finaldamage + "% damage.");
		}

		setPath("/hatchcalc.jsp");
	}

	public void run(String page) {
		String action = request.getParameter("action");
		request.setAttribute("action", action);
		request.setAttribute("result", " ");
		request.setAttribute("crits", " ");

		if (action == null || action.equals("")) {
			setPath("/hatchcalc.jsp");
		} else if (action.equals("hatchcalc"))
			calc();
		else
			setPath("/hatchcalc.jsp");

	}
}
