/**=======================================
 *    NearbyAccountsViewer - Version 1.0
 * =======================================
 * Unit Test:	NearbyAccountsViewer_test
 *
 * Version 1.0:
 *		2015-08-13 by Scott Pelak.
 *		Created.  
 */
public with sharing class NearbyAccountsViewer {
	final Id accountId;					// Version 1.0: Created.
	final Decimal billingLatitude;
	final Decimal billingLongitude;
	final Decimal shippingLatitude;
	final Decimal shippingLongitude;
	public String distance {get;set;}

	public NearbyAccountsViewer(ApexPages.StandardController controller){
		this.accountId = controller.getId();
		Account[] accountList = [
			SELECT Id, BillingLatitude, BillingLongitude, ShippingLatitude, ShippingLongitude
			FROM Account
			WHERE Id = :this.accountId
		];

		this.billingLatitude = accountList.isEmpty() ? null : accountList[0].BillingLatitude;
		this.billingLongitude = accountList.isEmpty() ? null : accountList[0].BillingLongitude;
		this.shippingLatitude = accountList.isEmpty() ? null : accountList[0].ShippingLatitude;
		this.shippingLongitude = accountList.isEmpty() ? null : accountList[0].ShippingLongitude;
		this.distance = '10';
	}

	public SelectOption[] getDistanceOptionList(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return new SelectOption[]{
			new SelectOption('10', '10 MI'),
			new SelectOption('20', '20 MI'),
			new SelectOption('50', '50 MI'),
			new SelectOption('100', '100 MI')
		};
	}

	public Integer getDistanceInteger(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return Integer.valueOf(this.distance);
	}

	public NearbyAccount[] getNearbyAccounts(Boolean isFromBillingAddress){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		Decimal latitude = isFromBillingAddress ? this.billingLatitude : this.shippingLatitude;
		Decimal longitude = isFromBillingAddress ? this.billingLongitude : this.shippingLongitude;
		Integer distanceInteger = this.getDistanceInteger();
		NearbyAccount[] nearbyAccountList = new NearbyAccount[]{};
		Account[] accountList = [
			SELECT Id, Name, 
				BillingLatitude, BillingLongitude, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
				ShippingLatitude, ShippingLongitude, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
			FROM Account
			WHERE DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi') < :distanceInteger
			AND Id != :this.accountId
			ORDER BY DISTANCE(BillingAddress, GEOLOCATION(:latitude, :longitude), 'mi')
			LIMIT 9
		];
		for(Integer i = 0; i < accountList.size(); i ++)
			nearbyAccountList.add(new NearbyAccount(accountList[i], i + 1));
		return nearbyAccountList;
	}

	public NearbyAccount[] getNearbyAccountsFromBillingAddress(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return this.billingLatitude == null || this.billingLongitude == null ? new NearbyAccount[]{} : this.getNearbyAccounts(true);
	}

	public String getNearbyAccountsFromBillingAddressJson(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return JSON.serialize(this.getNearbyAccountsFromBillingAddress());
	}

	public NearbyAccount[] getNearbyAccountsFromShippingAddress(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return this.shippingLatitude == null || this.shippingLongitude == null ? new NearbyAccount[]{} : this.getNearbyAccounts(false);
	}

	public String getNearbyAccountsFromShippingAddressJson(){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		return JSON.serialize(this.getNearbyAccountsFromShippingAddress());
	}

	public class NearbyAccount {
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		public Account account {get;set;}	// Version 1.0: Created.
		public Integer order {get;set;}		// Version 1.0: Created.

		public NearbyAccount(Account account, Integer order){
			/**
			 * Version 1.0:
			 *  	Created.  
			 */
			this.account = account;
			this.order = order;
		}

		public String getBillingAddress(){
			/**
			 * Version 1.0:
			 *  	Created.  
			 */
            String address = '';
            address += String.isNotBlank(this.account.BillingStreet) ? this.account.BillingStreet + ',' : '';
            address += String.isNotBlank(this.account.BillingCity) ? ' ' + this.account.BillingCity + ',' : '';
            address += String.isNotBlank(this.account.BillingState) ? ' ' + this.account.BillingState : '';
            address = address.removeEnd(',');
            address += String.isNotBlank(this.account.BillingPostalCode) ? ' ' + this.account.BillingPostalCode : '';
            return address;
		}

		public String getShippingAddress(){
			/**
			 * Version 1.0:
			 *  	Created.  
			 */
            String address = '';
            address += String.isNotBlank(this.account.ShippingStreet) ? this.account.ShippingStreet + ',' : '';
            address += String.isNotBlank(this.account.ShippingCity) ? ' ' + this.account.ShippingCity + ',' : '';
            address += String.isNotBlank(this.account.ShippingState) ? ' ' + this.account.ShippingState : '';
            address = address.removeEnd(',');
            address += String.isNotBlank(this.account.ShippingPostalCode) ? ' ' + this.account.ShippingPostalCode : '';
            return address;
		}
	}
}