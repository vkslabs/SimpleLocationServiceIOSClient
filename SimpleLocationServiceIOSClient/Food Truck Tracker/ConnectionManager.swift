//
//  ConnectionManager.swift
//  Food Truck Tracker
//
//  Created by Prabhu Swaminathan on 01/05/17.
//  Copyright © 2017 Drivebook. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionManager {
    static let sharedInstance = ConnectionManager()
    let baseURL = "http://54.186.50.131:4567/api/v1/";
    var timer : Timer?
    var callback: ((Array<NSDictionary>?, _: Error?) -> Void)?
    
    @objc func fetchFoodTruckLocation() {
        Alamofire.request(baseURL + "location").responseJSON { response in
            switch(response.result) {
            case .failure(let error):
                self.callback?(nil, error);
                return
            default:
                break
            }
            if let result = response.result.value {
                self.callback?(result as? Array<NSDictionary>, nil)
            } else {
                self.callback?(nil, response.error)
            }
        }
    }
    
    func startFoodTruckLocationUpdate(callback: ((Array<NSDictionary>?, _: Error?) -> Void)?) {
        self.stopFoodTruckLocationUpdate()
        self.callback = callback
        self.fetchFoodTruckLocation()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ConnectionManager.fetchFoodTruckLocation), userInfo: nil, repeats: true);
    }
    
    func stopFoodTruckLocationUpdate() {
        timer?.invalidate()
        timer = nil
        callback = nil
    }
}
