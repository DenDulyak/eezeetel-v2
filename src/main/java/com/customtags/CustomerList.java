package com.customtags;

import java.io.IOException;
import java.util.List;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import com.eezeetel.util.HibernateUtil;
import org.hibernate.Query;
import org.hibernate.Session;
import com.eezeetel.entity.TMasterCustomerinfo;

public class CustomerList extends TagSupport {

    private PageContext pageContext;
    private Tag parent;
    String m_strActiveOnly;
    String m_strInitialOption;
    String m_strName;
    String m_onChangeFucntion;

    public int doStartTag() throws JspException {
        Session theSession = null;

        try {
            String strOutput = new String();
            theSession = HibernateUtil.openSession();
            String strQuery = "from TMasterCustomerinfo ";
            if ((this.m_strActiveOnly != null) && (Short.parseShort(this.m_strActiveOnly) == 1)) {
                strQuery = strQuery + " where Active_Status = 1 ";
            }
            strQuery = strQuery + " order by Customer_Company_Name";
            Query query = theSession.createQuery(strQuery);
            List records = query.list();

            if (records.size() > 0) {
                strOutput = "<select ";
                if ((this.m_strName != null) && (!this.m_strName.isEmpty())) {
                    strOutput = strOutput + "name=\"" + this.m_strName + "\"";
                }

                if ((this.m_onChangeFucntion != null) && (!this.m_onChangeFucntion.isEmpty())) {
                    strOutput = strOutput + " onChange=\"" + this.m_onChangeFucntion + "\"";
                }

                strOutput = strOutput + ">";

                if ((this.m_strInitialOption != null) && (!this.m_strInitialOption.isEmpty())) {
                    strOutput = strOutput + "<option value=\"0\">" + this.m_strInitialOption + "</option>";
                }
            }

            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                TMasterCustomerinfo custInfo = (TMasterCustomerinfo) records.get(nIndex);
                strOutput = strOutput + "<option value=\"" + custInfo.getId() + "\">" + custInfo.getCompanyName() + "</option>";
            }

            if ((strOutput != null) && (!strOutput.isEmpty())) {
                strOutput = strOutput + "</select>";
            }
            this.pageContext.getOut().print(strOutput);
        } catch (IOException ioe) {
            throw new JspException("Error: IOException while writing to client" + ioe.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession(theSession);
        }
        return 0;
    }

    public int doEndTag() throws JspException {
        return 6;
    }

    public void release() {
    }

    public void setPageContext(PageContext pageContext) {
        this.pageContext = pageContext;
    }

    public void setParent(Tag parent) {
        this.parent = parent;
    }

    public Tag getParent() {
        return this.parent;
    }

    public void setName(String name) {
        this.m_strName = name;
    }

    public void setOnChange(String onChange) {
        this.m_onChangeFucntion = onChange;
    }

    public void setActive_records_only(String activeRecordsOnly) {
        this.m_strActiveOnly = activeRecordsOnly;
    }

    public void setInitial_option(String strInitialOption) {
        this.m_strInitialOption = strInitialOption;
    }
}