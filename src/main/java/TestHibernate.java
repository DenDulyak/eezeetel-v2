import java.util.List;

import org.apache.catalina.realm.JDBCRealm;
import org.hibernate.Query;
import org.hibernate.Session;

import com.eezeetel.util.HibernateUtil;
import com.eezeetel.entity.TBatchInformation;
import com.eezeetel.entity.User;

public class TestHibernate {
	static {
		System.out.println("Coming Here");
	}

	private String m_strCountry = "UK";

	public void setCountry(String strCountry) {
		this.m_strCountry = strCountry;
	}

	private static boolean trythis(TestHibernate.UserInfo theuserInfo) {
		theuserInfo.m_strPassword = "adfljasdklfjasdklfja";
		theuserInfo.m_nRole = Short.valueOf((short) 9787);
		return true;
	}

	public static void member() {
		System.out.println("member");
	}

	public static void main(String[] args) {
		System.out.println(JDBCRealm.Digest("admin", "MD5", "utf8"));
		member();
		member();
	}

	private void CryptPasswords() {
		Session session = null;
		try {
			session = HibernateUtil.openSession();
			session.beginTransaction();

			String strQuery = "from User";
			Query query = session.createQuery(strQuery);
			List lst = query.list();
			for (int i = 0; i < lst.size(); i++) {
				User theUser = (User) lst.get(i);
				System.out.println(i + " - Processing User : " + theUser.getLogin());
				String cryptPassword = JDBCRealm.Digest(theUser.getPassword(), "MD5", "utf8");

				theUser.setPassword(cryptPassword);
				session.save(theUser);
			}
			session.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.getTransaction().rollback();
		} finally {
			HibernateUtil.closeSession(session);
		}
	}

	private void ShowMisMatchBatches() {
		Session session = null;
		try {
			session = HibernateUtil.openSession();

			String strQuery = "from TBatchInformation order by SequenceId";
			Query query = session.createQuery(strQuery);
			List lst = query.list();
			for (int i = 0; i < lst.size(); i++) {
				TBatchInformation batchInfo = (TBatchInformation) lst.get(i);

				strQuery = "from TCardInfo fc where Batch_Sequence_ID = " + batchInfo.getSequenceId() + " and IsSold = 0";
				query = session.createQuery(strQuery);
				List availableCardsList = query.list();
				if (availableCardsList.size() != batchInfo.getAvailableQuantity()) {
					System.out.println("Wrong Batch : " + batchInfo.getSequenceId() + " - AVAILABLE = "
							+ batchInfo.getAvailableQuantity() + "  ACTUAL = " + availableCardsList.size());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			HibernateUtil.closeSession(session);
		}
	}

	private final class UserInfo {
		String m_strUserName;
		String m_strPassword;
		String m_strRole;
		Short m_nRole;

		private UserInfo() {
		}
	}
}
