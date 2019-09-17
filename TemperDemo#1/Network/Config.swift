
//
//  Config.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/12/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import Foundation

class Config {
    private static var VERSION_NUMBER = "v2" //MARK: - routing to the relavant end-points handled from the back-end
    private static let BASE_URL = "https://temper.works/api/"

    
    public static var GET_JOBS_DATA = BASE_URL+VERSION_NUMBER+"/contractor/shifts"
}
