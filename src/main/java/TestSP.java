import com.eezeetel.util.HibernateUtil;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;

import java.util.List;

public class TestSP {
	public static void main(String[] args) {
		String req_date = "2013-05-01";
		int supplier_id = 35;

		Session session = null;
		try {
			session = HibernateUtil.openSession();

			String strQuery = "call SP_Report_Monthly_Product_Uploads_By_Supplier(" + supplier_id + ", '" + req_date + "')";
			SQLQuery query = session.createSQLQuery(strQuery);
			query.addScalar("Product_Name", StandardBasicTypes.STRING);
			query.addScalar("Product_Face_Value", StandardBasicTypes.FLOAT);
			query.addScalar("Quantity", StandardBasicTypes.INTEGER);

			List lst = query.list();
			for (int i = 0; i < lst.size(); i++) {
				Object[] oneRecord = (Object[]) lst.get(i);

				String productName = (String) oneRecord[0];
				Float productFaceValue = (Float) oneRecord[1];
				Integer quantity = (Integer) oneRecord[2];

				System.out.println(productName + " - " + productFaceValue + " - " + quantity);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			HibernateUtil.closeSession(session);
		}
	}
}
