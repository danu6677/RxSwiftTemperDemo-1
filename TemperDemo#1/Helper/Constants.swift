//
//  Constants.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/12/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import Foundation

class Constants {
    // MARK: - Network status codes/error codes
    static let ERROR_CODE_REQUEST_TIMEOUT = -1001
    static let ERROR_CODE_NETWORK_CONNECTION_LOST = -1005
    static let ERROR_CODE_INTERNET_OFFLINE = -1009
    static let STATUS_CODE_REQUEST_SUCCESS = 200
    static let STATUS_CODE_REQUEST_SUCCESS_RANGE = 200...299
    static let STATUS_CODE_FORBIDDEN = 403
    static let STATUS_CODE_UNAUTHORIZED = 401
    static let STATUS_CODE_SERVER_ERROR_RANGE = 500...599
    static let STATUS_CODE_SERVER_GATEWAY_TIMEOUT = 504
    
    // MARK: - Alert Action Titles
    static let OK_ACTION = "OK"
    static let YES_ACTION = "Yes"
    static let NO_ACTION = "No"
    static let DISMISS_ACTION = "Dismiss"
    static let RELOAD_ACTION = "Reload"
    static let RETRY_ACTION = "Retry"
    static let CANCEL_ACTION = "Cancel"
    
    // MARK: - Alert Titles
    static let SUCCESS_TITLE = "Success"
    static let ERROR_TITLE = "Error"
    static let ALERT_TITLE = "Alert"
    static let WARNING_TITLE = "Warning"
    static let CONFIRM_TITLE = "Confirm"
    
    // MARK: - Alert Messages
    static let INTERNET_OFFLINE_MESSAGE = "Internet connection appears to be offline. Reload to try again when connection is available!"
    static let SERVER_ERROR_MESSAGE = "We are experiencing a server error at the moment. Reload to try again!"
    static let INTERNAL_ERROR = "We are experiencing an internal error at the moment."
    
    static let REQUEST_JSON_BODY_SERIALIZATION_ERROR_MESSAGE = "Experienced an error in JSON request body serialization!"
    static let RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE = "Experienced an error in JSON response de-serialization!"
    static let UNKNOWN_ERROR_MESSAGE = "Some unexpected error occured! Please try again later"
    
    static let UNAUTHORIZED_ERROR_MESSAGE = "Unauthorized access!"
    static let FORBIDDEN_ERROR_MESSAGE = "You dont ahve permission to access this content"
}
