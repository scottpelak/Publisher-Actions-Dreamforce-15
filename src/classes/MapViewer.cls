/**============================
 *    MapViewer - Version 1.0
 * ============================
 * Unit Test:	MapViewer_test
 *
 * Version 1.0:
 *		2015-08-11 by Scott Pelak.
 *		Created.  
 */
public with sharing class MapViewer {
	final Id accountOrContactId;		// Version 1.0: Created.
	final SObjectType sObjectType;		// Version 1.0: Created.
	final Account acct;
	final Contact con;

	public MapViewer(ApexPages.StandardController controller){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		this.accountOrContactId = controller.getId();
		this.sObjectType = this.accountOrContactId == null ? null : this.accountOrContactId.getSObjectType();

		Account[] accountList = [
			SELECT Id, BillingAddress, ShippingAddress
			FROM Account
			WHERE Id = :this.accountOrContactId
		];
		this.acct = accountList.isEmpty() ? null : accountList[0];

		Contact[] contactList = [
			SELECT Id, MailingAddress, OtherAddress
			FROM Contact
			WHERE Id = :this.accountOrContactId
		];
		this.con = contactList.isEmpty() ? null : contactList[0];
	}

	public Account getAccount(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return this.acct;
	}

	public Contact getContact(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return this.con;
	}

	public String getAddress(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		String address = '';
		






		return address;
	}

	public String getLatitude(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		String latitude = '';
		return latitude;
	}

	public String getLongitude(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		String longitude = '';
		return longitude;
	}
}