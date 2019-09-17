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
    
    private let title : String?
    private let imageArray : [Formats]?
    private let category : String?
    private let shifts : [ShitDetails]?
    private let distance : String?
    
    //Dependency injection
    init(mainData:Dates) {
        
        self.title = mainData.title
        self.imageArray =  mainData.client?.photos
        self.shifts = mainData.shifts
        self.category = mainData.job_category?.description
        self.distance = mainData.distance

    }
    
    //Method been written to have more control over the logic rather than assigning them inside closures
    func getImageUrl()->String {
        return self.imageArray?[0].formats[0].cdn_url ?? ""
    }
    
    func start_end_time()->String {
        let time  = "\(shifts?[0].start_time ?? "No Start time") - \(shifts?[0].end_time ?? "No End Time")"
        return time
        
    }
    
    func category_distance() -> String {
        var distanceToDestination = ""
        if let dist = distance {
            distanceToDestination = " - \(dist) km"
        }
        return "\(category ?? "") \(distanceToDestination)"
        
    }
    
    func getHourlyRate() -> String {
        let rate = String(format: "%.2f", shifts?[0].earnings_per_hour ?? "")
        
        return Utils.cleanCurrency(rate, currencyCode: Utils.CurrencyCode.EUR.rawValue)
        
    }
    
    func getTitle() -> String {
        return self.title ?? ""
        
    }
}

