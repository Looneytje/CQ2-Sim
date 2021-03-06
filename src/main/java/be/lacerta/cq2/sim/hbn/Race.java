package be.lacerta.cq2.sim.hbn;

import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

public class Race extends HbnObject implements java.io.Serializable {

	int id;
	String creatureClass;
	String name;
	int FD;
	int DD;
	int AD;
	int ED;
	int stealage;
	int stealage2;
	int stealage3;
	
	public int getStealage2() {
		return stealage2;
	}

	public void setStealage2(int stealage2) {
		this.stealage2 = stealage2;
	}

	public int getStealage3() {
		return stealage3;
	}

	public void setStealage3(int stealage3) {
		this.stealage3 = stealage3;
	}

	public int getStealage() {
		return stealage;
	}

	public void setStealage(int stealage) {
		this.stealage = stealage;
	}

	private Set<Item> items = new TreeSet<Item>();
	
	public Race() {

	}

	public Race(int id) {
		this.id = id;
	}
	
	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setCreatureClass(String creatureClass) {
		this.creatureClass = creatureClass;
	}

	public String getCreatureClass() {
		return creatureClass;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setFD(int FD) {
		this.FD = FD;
	}

	public int getFD() {
		return FD;
	}

	public void setDD(int DD) {
		this.DD = DD;
	}

	public int getDD() {
		return DD;
	}

	public void setAD(int AD) {
		this.AD = AD;
	}

	public int getAD() {
		return AD;
	}

	public void setED(int ED) {
		this.ED = ED;
	}

	public int getED() {
		return ED;
	}
	
	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof Race))
			return false;
		Race o = (Race) other;
		return (o.getId() == this.getId());
	}
	
	public int hashCode() {
	      return id;
	}
	
	@SuppressWarnings("unchecked")
	public static List<Race> getRaces() {
		List<Race> races = null;
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.getTransaction();
		Criteria c = session.createCriteria(Race.class);
		races = c.list();
		return races;
	}

	@SuppressWarnings("unchecked")
	public static Race createFromDB(String name) {
		Race race = null;
		Transaction tx = null;
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		try {
			tx = session.getTransaction();
			Criteria c = session.createCriteria(Race.class);
			c.add(Restrictions.eq("name", name));
			List<Race> results = c.list();
			if (results != null && results.size() > 0) {
				race = results.get(0);
			}
			
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null && tx.isActive())
				tx.rollback();
		}
		return race;
	}

	public void setItems(Set<Item> items) {
		this.items = items;
	}

	public Set<Item> getItems() {
		return items;
	}
	
	// get creature exponent
	public double gGetCreatureExponent(int skill) {

	// definitions
	double[] exponents = {1, 1.1, 1.15, 1.2, 1.28, 1.29, 1.29, 1.3, 1.3, 1.31, 1.31, 1.32};
	int jumps = 40;

	// calculate exponent
	int exponent = (int) Math.floor(skill / jumps);
	if (exponent > 11 || exponent < 0) { exponent = exponents.length - 1; }

	// return
	return exponents[exponent];
	}
	
}