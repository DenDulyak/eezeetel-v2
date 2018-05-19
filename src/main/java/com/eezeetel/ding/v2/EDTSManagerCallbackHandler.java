/**
 * EDTSManagerCallbackHandler.java
 * <p>
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.7.1  Built on : Feb 20, 2016 (10:01:29 GMT)
 */
package com.eezeetel.ding.v2;


/**
 *  EDTSManagerCallbackHandler Callback class, Users can extend this class and implement
 *  their own receiveResult and receiveError methods.
 */
public abstract class EDTSManagerCallbackHandler {
    protected Object clientData;

    /**
     * User can pass in any object that needs to be accessed once the NonBlocking
     * Web service call is finished and appropriate method of this CallBack is called.
     * @param clientData Object mechanism by which the user can pass in user data
     * that will be avilable at the time this callback is called.
     */
    public EDTSManagerCallbackHandler(Object clientData) {
        this.clientData = clientData;
    }

    /**
     * Please use this constructor if you don't want to set any clientData
     */
    public EDTSManagerCallbackHandler() {
        this.clientData = null;
    }

    /**
     * Get the client data
     */
    public Object getClientData() {
        return clientData;
    }

    /**
     * auto generated Axis2 call back method for getBalance method
     * override this method for handling normal response from getBalance operation
     */
    public void receiveResultgetBalance(EDTSManagerStub.GetBalanceResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from getBalance operation
     */
    public void receiveErrorgetBalance(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for validatePhoneAccount method
     * override this method for handling normal response from validatePhoneAccount operation
     */
    public void receiveResultvalidatePhoneAccount(EDTSManagerStub.ValidatePhoneAccountResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from validatePhoneAccount operation
     */
    public void receiveErrorvalidatePhoneAccount(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for getProductList method
     * override this method for handling normal response from getProductList operation
     */
    public void receiveResultgetProductList(EDTSManagerStub.GetProductListResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from getProductList operation
     */
    public void receiveErrorgetProductList(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for sendSMS method
     * override this method for handling normal response from sendSMS operation
     */
    public void receiveResultsendSMS(EDTSManagerStub.SendSMSResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from sendSMS operation
     */
    public void receiveErrorsendSMS(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for getTopUpTransactionStatus method
     * override this method for handling normal response from getTopUpTransactionStatus operation
     */
    public void receiveResultgetTopUpTransactionStatus(EDTSManagerStub.GetTopUpTransactionStatusResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from getTopUpTransactionStatus operation
     */
    public void receiveErrorgetTopUpTransactionStatus(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for getTargetTopUpAmount method
     * override this method for handling normal response from getTargetTopUpAmount operation
     */
    public void receiveResultgetTargetTopUpAmount(EDTSManagerStub.GetTargetTopUpAmountResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from getTargetTopUpAmount operation
     */
    public void receiveErrorgetTargetTopUpAmount(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for topUpPhoneAccount method
     * override this method for handling normal response from topUpPhoneAccount operation
     */
    public void receiveResulttopUpPhoneAccount(EDTSManagerStub.TopUpPhoneAccountResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from topUpPhoneAccount operation
     */
    public void receiveErrortopUpPhoneAccount(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for getProductDescriptions method
     * override this method for handling normal response from getProductDescriptions operation
     */
    public void receiveResultgetProductDescriptions(EDTSManagerStub.GetProductDescriptionsResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from getProductDescriptions operation
     */
    public void receiveErrorgetProductDescriptions(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for isCountrySupportedByEzeOperator method
     * override this method for handling normal response from isCountrySupportedByEzeOperator operation
     */
    public void receiveResultisCountrySupportedByEzeOperator(EDTSManagerStub.IsCountrySupportedByEzeOperatorResult result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from isCountrySupportedByEzeOperator operation
     */
    public void receiveErrorisCountrySupportedByEzeOperator(java.lang.Exception e) {
    }
}
