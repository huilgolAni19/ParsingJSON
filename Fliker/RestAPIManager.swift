//
//  RestAPIManager.swift
//  TrialRESTAPI
//
//  Created by Anirudh on 29/06/16.
//  Copyright © 2016 Anirudh. All rights reserved.
//

import Foundation


typealias ServiceResponse = (JSON, NSError?) -> Void

typealias HandleResponse = (NSString, NSError?) -> Void

class RestAPIManager: NSObject {
    
     static let sharedInstance = RestAPIManager()
    
     let baseURL = "http://www.flickr.com/services/feeds/photos_public.gne?tags=baseball&format=json&nojsoncallback=1"
    
    func getServerData(onCompletion : (JSON) -> Void){
        
            getHttpResopnseJSON(URL: baseURL, onCompletion: { json, err -> Void in
                onCompletion(json)
            })
    }
    
    func getHttpResopnseJSON(URL url: String ,onCompletion: ServiceResponse){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data,response, error in
            let json: JSON = JSON(data: data!)
            onCompletion(json,error);
        })
        task.resume()
    }
    
    func getHttpResopnseString(URL url: String ,body postString: String, onCompletion: ServiceResponse){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
    
        let task = session.dataTaskWithRequest(request, completionHandler: { data,response, error in
            let json: JSON = JSON(data: data!)
            onCompletion(json,error);
        })
        task.resume()
    }

    
    func makeHTTPPostRequest(URL stringUrl: String, postString body: String, onCompletion: HandleResponse) {
        var err: NSError?
        let request = NSMutableURLRequest(URL: NSURL(string: stringUrl)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        // Set the POST body for the request
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)

        //Define NSURLSession
        let session = NSURLSession.sharedSession()
        
        // Define task
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            // Defining error
            err = error
            
            // convert NSData to string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            
            // unwrap optional and send to completion method
            if let unRepTxt = responseString{
             onCompletion(unRepTxt, err)
            }
           
        })
        task.resume()
    }
}

