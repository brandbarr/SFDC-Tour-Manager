trigger NumberOfBands on Band__c (before update, before insert, after delete) {

// Create Variables
Public Map<Id, List<Band__c>> TourBands = new Map<Id, List<Band__c>>();
Public Set<Id> ToursSet = new Set<Id>();
Public List<Band__c> Bands = new List<Band__c>();
Public List<Band__c> Mouths = New List<Band__c>();
Public List<Tour__c> Tours = new List<Tour__c>();

// Add Bands from from trigger to a set
if(trigger.isUpdate || trigger.isInsert){
	for(Band__c b : trigger.new){
		ToursSet.add(b.tour__c);
	}
}
if(trigger.isDelete){
	for(Band__c b : trigger.old){
		ToursSet.add(b.tour__c);
	}

}
// Get fields from bands in set
Bands = [SELECT Id, Tour__c FROM Band__c WHERE Tour__c In :ToursSet];

// Add bands/fields to map
for (Band__c b : Bands){
	if(!TourBands.containsKey(b.tour__c)){
		TourBands.put(b.tour__c, new List<band__c>());
	}
	TourBands.get(b.tour__c).add(b);
}

// Get tour fields from map and add them to list
Tours = [SELECT Id, Number_Of_Bands__c  FROM Tour__C WHERE Id IN :ToursSet];
Mouths = [SELECT Id, members__C, tour__c FROM Band__c WHERE tour__c IN :ToursSet];
// Update Tour Record
for (Tour__c t : Tours){
	Bands = TourBands.get(t.Id);
	t.Number_Of_Bands__c = Bands.size();
	t.Mouths_to_feed__c = Mouths.size();
	update t;
}
}