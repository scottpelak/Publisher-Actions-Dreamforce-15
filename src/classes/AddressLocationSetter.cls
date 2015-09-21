/**========================================
 *    AddressLocationSetter - Version 1.0
 * ========================================
 * Unit Test:	AddressLocationSetter_test
 *
 * Version 1.0:
 *		2015-08-11 by Scott Pelak.
 *		Created.  
 */
global with sharing class AddressLocationSetter {
	global AddressLocationSetter() {
		
	}

	global AddressLocationSetter(ApexPages.StandardController controller){

	}


	@RemoteAction
	global static void updateLocation(Id recordId, String addressField, Decimal latitude, Decimal longitude){
		/**
		 * Version 1.0:
		 *  	Created.  
		 */
		SObject record = recordId.getSObjectType().newSObject(recordId);
		record.put(addressField + 'Latitude', latitude);
		record.put(addressField + 'Longitude', longitude);
		update record;
	}
}