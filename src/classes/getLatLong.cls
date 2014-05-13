public class getLatLong {
 
     @future (callout=true)  // future method needed to run callouts from Triggers
      static public void getLocation(id tdId){
        // gather account info
        tour_date__c td = [SELECT City__c,Country__c,Zip__c,State__c,Street__c FROM tour_date__c WHERE id =: tdId];
 
        // create an address string
        String address = '';
        if (td.street__c != null)
            address += td.street__c +', ';
        if (td.City__c != null)
            address += td.City__c +', ';
        if (td.State__C != null)
            address += td.State__c +' ';
        if (td.zip__c!= null)
            address += td.zip__c +', ';
        if (td.Country__c != null)
            address += td.Country__c;
 
        address = EncodingUtil.urlEncode(address, 'UTF-8');
 
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
 
        try{
            // callout
            HttpResponse res = h.send(req);
 
            // parse coordinates from response
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
 
                }
            }
 
            // update coordinates if we get back
            if (lat != null){
                td.Location__Latitude__s = lat;
                td.Location__Longitude__s = lon;
                update td;
            }
 
        } catch (Exception e) {
        }
    }
}