//
//  Utils.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/12/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import UIKit

class Utils {
    enum CurrencyCode :String {
        case GBP
        case EUR
        case USD
    }
    // Set the TableView Label Text
    static func setTableCellLabelText(cell: UITableViewCell, labelTag:Int?, text: Any){
        if labelTag != nil{
            let label = cell.viewWithTag(labelTag!)
            (label as! UILabel).text = text as? String;
        }else {
            cell.textLabel?.text = text as? String;
        }
    }
    
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: Date())
    }
    
    //Handle Error thrown from the API
    static func handleWebserviceErrors (errorCode:Int,activityIndicator: UIActivityIndicatorView, presentVC:UIViewController,alertActionMesasage:String) {
        
        activityIndicator.stopAnimating()
        
        if errorCode == Constants.STATUS_CODE_UNAUTHORIZED {
            addReloadAlert(message: Constants.UNKNOWN_ERROR_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
        }
            
        else if Constants.STATUS_CODE_SERVER_ERROR_RANGE.contains(errorCode) {
            addReloadAlert(message: Constants.SERVER_ERROR_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
        }
            
        else if errorCode == Constants.ERROR_CODE_INTERNET_OFFLINE || errorCode == Constants.ERROR_CODE_NETWORK_CONNECTION_LOST {
            addReloadAlert(message: Constants.INTERNET_OFFLINE_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
        }
            
        else {
            addReloadAlert(message: Constants.UNKNOWN_ERROR_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
        }
        
    }
    //Custom Alert
    static func addReloadAlert(message: String,presentVC:UIViewController,alertActionMesasage:String) {
        
        let alertController = UIAlertController(title: Constants.ERROR_TITLE, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title:alertActionMesasage, style: UIAlertAction.Style.default, handler: { alertAction in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        presentVC.present(alertController, animated: true, completion: nil)
    }
    
    
    //Set image cache for images in a UIView
    static func setImageViewImageWithCache(forImageView: UIImageView, withImageUrl: String){
        
        (forImageView).imageFromServerURL(urlString: withImageUrl)
    }
    
    
    //Set image cache  for tableview
    static func setTableCellImageViewImage(cell: UITableViewCell, imageViewTag:Int, imageUrlString: Any,tableViewName:UITableView? = nil, indexpath:IndexPath? = nil){
        if let imagePathString = imageUrlString as? String {
            (cell.viewWithTag(imageViewTag) as! UIImageView).imageFromServerURL(urlString: imagePathString, tableView: tableViewName, indexpath: indexpath)
        }
    }
    
    //Set Currency
    static func cleanCurrency(_ value: String?, currencyCode:String) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
    }
}

//Image Cache
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    
    public func imageFromServerURL(urlString: String,tableView:UITableView? = nil,indexpath:IndexPath? = nil) {
        var imageURLString : String?
        imageURLString = urlString
        
        if let url = URL(string: urlString) {
            
            image = nil
            
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                
                self.image = imageFromCache
                
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil{
                    print(error as Any)
                    
                    
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let imgaeToCache = UIImage(data: data!){
                        
                        if imageURLString == urlString {
                            self.image = imgaeToCache
                            
                        }
                        
                        imageCache.setObject(imgaeToCache, forKey: urlString as AnyObject)// calls when scrolling
                    }
                })
            }) .resume()
        }
    }
    
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
