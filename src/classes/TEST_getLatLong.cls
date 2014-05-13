@isTest
private class TEST_getLatLong {
	
	@isTest static void test_method_one() {
		tour_date__c v = new tour_date__c(street__c ='2822 Kilburn Ct.', city__c = 'rochester hills', state__c='Michigan', zip__c='48306', country__c='United States');
		Test.startTest();
		insert v;		
		Test.stopTest();
		system.assert(v.Location__Latitude__s == null);
		system.assert(v.Location__longitude__s == null);

	}
	
	
}