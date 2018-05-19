package com.transferto;

import java.util.Map;

public class MSISDNResponse {
	public int m_nErrorCode;
	public String m_strErrorText;
	public String m_strDestinationNumber;
	public String m_strCountry;
	public String m_strCountryID;
	public String m_strCurrency;
	public String m_strOperator;
	public String m_strOperatorID;
	public Map<Float, PriceMapObject> m_priceMap;
	public String m_strProductList;
	public String m_strRetailPriceList;
	public String m_strWholeSalePriceList;

	static public class PriceMapObject {
		public String m_strProduct;
		public float m_fWholeSalePrice;
		public float m_fRetailPrice;
		public float m_fCostToCustomer;
		public float m_fSuggestedRetailprice;

		public PriceMapObject() {
		}
	}
}
