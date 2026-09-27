public class CalloutToSalesforceOrg {
    public static void getAccount(){
        Http http = new Http();
        Httprequest request = new httprequest();
        request.setEndpoint('callout:TargetOrg/services/apexrest/accountmngmt/');
        request.setMethod('GET');
        
        Httpresponse response = http.send(request);
        //system.debug('response' + response.getBody());
        //system.debug('response status' + response.getStatusCode());
        if(response.getStatusCode()==200){
            List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
            for(Object obj : results){
                //system.debug(obj);
                Map<String, Object> accountRecord = (Map<String, Object>) obj;
                system.debug(accountRecord.get('Industry'));
            }
        }else{
            system.debug('Error in integration ' + response.getBody());
        }
    }
}