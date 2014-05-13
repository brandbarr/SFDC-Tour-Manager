trigger getLatLong on tour_date__c (after insert, after update) {
    for (tour_date__c td : trigger.new)
        if (td.Location__Latitude__s == null)
           getLatLong.getLocation(td.id);
}