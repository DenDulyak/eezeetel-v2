import com.commons.GenerateOldInvoices;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

public class GenerateCustomerReports {
	public static void main(String[] args) {
		GenerateOldInvoices invoices = new GenerateOldInvoices();
		invoices.setCountry("UK");

		int nCustomerID = Integer.parseInt(args[0]);
		int nForYear = Integer.parseInt(args[1]);
		int nForMonth = Integer.parseInt(args[2]);
		nForMonth--;

		invoices.setDuration(nForYear, nForMonth, nForYear, nForMonth);
		invoices.setCustomerID(nCustomerID);
		invoices.setGenerateHTMLOutput(true);
		invoices.createInvoice();

		String strReportFile = "D:\\Installations\\" + nCustomerID + "_" + nForYear + "_" + (nForMonth + 1) + ".html";
		File generatedFile = new File(strReportFile);
		try {
			PrintWriter out = new PrintWriter(strReportFile);
			out.println(invoices.m_strInvoiceReport);
			out.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
}
