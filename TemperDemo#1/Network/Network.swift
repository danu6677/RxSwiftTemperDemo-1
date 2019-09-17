//
//  Network.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/12/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Network: NSObject {
    //Network resquest types & Responce structures
    private  let NETWORK_REQUEST_TYPES = (G: "GET", P: "POST", U: "PUT", D: "DELETE")
    private  let RESPONSE_STRUCTURE = (A: "Array", D: "Dictonary", O: "Other_for_testing")
    
    ///Singleton
    private static var networkCalls:Network?;
    
    private override init() {
    }
    
    public static var shared:Network {
        
        if networkCalls == nil{
            networkCalls = Network ()
        }
        return networkCalls!
        
    }
    
    
    private func performWebServiceRequest <T : Codable>(type: T.Type,with url: URL, requestType: String, paramData: Data!, requestOptions: [[String]]!, responseStructure: String) -> Observable<T> {
        return Observable<T>.create { observer in
            
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = requestType // As in "POST", "GET", "PUT" or "DELETE"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            if paramData != nil {
                request.httpBody = paramData
            }
            
            //Addinhg Auth/secret-key/application-id and etc
            if requestOptions != nil {
                //ro denotes the request options
                for ro in requestOptions {
                    print(ro)
                    request.addValue(ro[1], forHTTPHeaderField: ro[0])
                }
            }
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let data: Data = data, let response: URLResponse = response, error == nil else {
                    print("WebServiceCall performWebServiceRequest | error : \(String(describing: error!))")
                    print("WebServiceCall performWebServiceRequest | error code : \((error! as NSError).code)")
                    
                    // Handling Network unavailability
                    if (error! as NSError).code == Constants.ERROR_CODE_INTERNET_OFFLINE || (error! as NSError).code == Constants.ERROR_CODE_NETWORK_CONNECTION_LOST {
                        
                        observer.onError(NSError(domain: Constants.INTERNET_OFFLINE_MESSAGE, code: Constants.ERROR_CODE_INTERNET_OFFLINE, userInfo: nil))
                        
                    }
                        // Handling Request Timeout
                    else if (error! as NSError).code == Constants.ERROR_CODE_REQUEST_TIMEOUT {
                        // TEMP: TODO:
                        observer.onError(NSError(domain: Constants.SERVER_ERROR_MESSAGE, code: Constants.STATUS_CODE_SERVER_GATEWAY_TIMEOUT, userInfo: nil))
                    }
                        // Handling Unknown Errors
                    else {
                        
                        observer.onError(NSError(domain: Constants.UNKNOWN_ERROR_MESSAGE, code: 0, userInfo: nil))
                    }
                    return
                }
                
                let responseStatusCode = (response as! HTTPURLResponse).statusCode
                print("WebServiceCall webServiceRequestOther | response status code : \(responseStatusCode)")
                
                if Constants.STATUS_CODE_REQUEST_SUCCESS_RANGE.contains(responseStatusCode) {
                    if responseStructure == self.RESPONSE_STRUCTURE.A {
                        // JSON De-Serialization if anticipated response data structure is Array
                        do {
                            let result = try JSONDecoder().decode(type, from: data)
                            //  successBlock(result)
                            observer.onNext(result)
                            
                        }
                        catch {
                            print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Array")
                            
                            observer.onError(NSError(domain: Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE, code: 0, userInfo: nil))
                        }
                    }
                    else if responseStructure == self.RESPONSE_STRUCTURE.D {
                        // JSON De-Serialization if anticipated response data structure is Dictionary
                        do {
                            let result = try JSONDecoder().decode(type, from: data)
                            
                            // successBlock(result)
                            observer.onNext(result)
                            
                        }
                        catch {
                            print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Dictionary")
                            
                            
                            observer.onError(NSError(domain: Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE, code: 0, userInfo: nil))
                        }
                    }
                    else {
                        if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                            //  successBlock(resultString)
                            print(resultString)
                        }
                        else {
                            
                            print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Other")
                            
                            observer.onError(NSError(domain: Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE, code: 0, userInfo: nil))
                        }
                    }
                }
                else {
                    observer.onError(NSError(domain: Constants.ERROR_TITLE, code: responseStatusCode, userInfo: nil))
                    
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    
    
    //Request methods
    //Public methods to access the services
    public func retrieveJobDetails()-> Observable<Schedule>  {
        let url = URL(string: Config.GET_JOBS_DATA)
        
        return performWebServiceRequest(type: Schedule.self,with: url!, requestType: NETWORK_REQUEST_TYPES.G, paramData: nil, requestOptions: nil, responseStructure: RESPONSE_STRUCTURE.D)
        
    }
}
