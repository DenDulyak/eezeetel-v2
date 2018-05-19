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
import com.eezeetel.entity.TMasterSupplierinfo;

public class SupplierList extends TagSupport {

    private PageContext pageContext;
    private Tag parent;
    String m_strActiveOnly;
    String m_strInitialOption;
    String m_strName;
    String m_onChangeFucntion;
    String m_strSecondaryAlso;
    String m_strDefaultSelect;


    public int doStartTag() throws JspException {
        Session theSession = null;

        boolean bWhereClauseExists = false;

        try {
            String strOutput = new String();
            theSession = HibernateUtil.openSession();
            String strQuery = "from TMasterSupplierinfo ";
            if ((this.m_strActiveOnly != null) && (Short.parseShort(this.m_strActiveOnly) == 1)) {
                strQuery = strQuery + " where Supplier_Active_Status = 1 ";
                bWhereClauseExists = true;
            }
            if ((this.m_strSecondaryAlso != null) && (Short.parseShort(this.m_strSecondaryAlso) == 0)) {
                if (bWhereClauseExists) {
                    strQuery = strQuery + " and Secondary_Supplier = 0 ";
                } else
					strQuery = strQuery + " where Secondary_Supplier = 0 ";
            }
            strQuery = strQuery + " order by Supplier_Name";
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

            int nSelectedRecord = Integer.parseInt(this.m_strDefaultSelect);
            for (int nIndex = 0; nIndex < records.size(); nIndex++) {
                String strSelected = "";
                TMasterSupplierinfo supInfo = (TMasterSupplierinfo) records.get(nIndex);
                if (nSelectedRecord == supInfo.getId().intValue()) {
                    strSelected = "Selected";
                }
                strOutput =
				strOutput + "<option value=\"" + supInfo.getId() + "\"" + strSelected + ">" + supInfo.getSupplierName();

                strOutput = strOutput + "</option>";
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

    public void setSecondary_also(String strSecondaryAlso) {
        this.m_strSecondaryAlso = strSecondaryAlso;
    }

    public void setActive_records_only(String activeRecordsOnly) {
        this.m_strActiveOnly = activeRecordsOnly;
    }

    public void setInitial_option(String strInitialOption) {
        this.m_strInitialOption = strInitialOption;
    }

    public void setDefault_select(String strDefaultSelect) {
        this.m_strDefaultSelect = strDefaultSelect;
    }

}