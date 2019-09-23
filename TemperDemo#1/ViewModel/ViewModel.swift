//
//  ViewModel.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/13/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import Foundation
import RxSwift

struct JobsViewModel {

    var dataModel: Dates!
    
    //Dependency injection
    init(mainData:Dates) {
        self.dataModel = mainData

    }
    
    var title:String {
        return dataModel.title ?? ""
    }
    
    var hourlyRate:String {
        let shift = dataModel.shifts
        let rate = String(format: "%.2f", shift?[0].earnings_per_hour ?? "")
       return Utils.cleanCurrency(rate, currencyCode: Utils.CurrencyCode.EUR.rawValue)
    }
    
    var category_distance:String {
        var distanceToDestination = ""
        let category = dataModel.job_category?.description
        if let dist = dataModel.distance {
            distanceToDestination = " - \(dist) km"
        }
        return "\(category ?? "") \(distanceToDestination)"
    }
    
    var start_end_time: String {
        let time  = "\(dataModel.shifts?[0].start_time ?? "No Start time") - \(dataModel.shifts?[0].end_time ?? "No End Time")"
        return time
        
    }
    
    var imageURL:String {
        return self.dataModel.client?.photos[0].formats[0].cdn_url ?? ""
    }
}

