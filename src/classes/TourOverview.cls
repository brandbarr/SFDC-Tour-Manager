public with sharing class TourOverview {

	Public List<Band__c> bands {get;set;}
	Public string approve {get;set;}
		


	public TourOverview() {

		bands = [SELECT Id, approved__c, name, home_city__c, home_state__c, image_url__c, members__c, tour__c, transportation__c FROM band__c WHERE tour__c = :ApexPages.currentPage().getParameters().get('id')];	
	}

	public pageReference approveBand() {
		band__c b = [SELECT Id, approved__c from Band__c WHERE Id= :approve];
		b.approved__c = true;
		update b;
		return null;
	}
}