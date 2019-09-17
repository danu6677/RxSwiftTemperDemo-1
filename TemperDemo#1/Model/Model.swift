//
//  Model.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/13/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import Foundation

public struct Schedule: Codable {
      public let data : [String:[Dates]]
}

public struct Dates: Codable {
      public let title: String?
      public let distance: String?
      public let client: Images?
      public let shifts: [ShitDetails]?
      public let job_category:JobCategory?
    
}

public struct Images:Codable {
      public let photos: [Formats]
    
}
public struct Formats:Codable {
      public let formats: [BackgroundImage]
    
}
public struct BackgroundImage:Codable {
      public let cdn_url: String?
    
}
public struct ShitDetails:Codable {
      public let currency: String?
      public let earnings_per_hour: Double?
      public let start_time: String?
      public let end_time: String?
    
}
public struct JobCategory:Codable {
      public let description: String?
    
}
