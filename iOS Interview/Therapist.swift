//
//  Therapist.swift
//  iOS Interview
//
//  Created by Kelvin Lee on 12/10/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

struct ResponseData: Decodable {
    var therapists: [Therapist]
}

struct Therapist: Decodable {
    var id: Int
    var therapistSince: Double
    var primaryLicense: String
    var name: String
    var shiftInfo: [String: Double]
    
    init(id: Int, therapistSince: Double, primaryLicense: String, name: String, shiftInfo: [String: Double]) {
        self.id = id
        self.therapistSince = therapistSince
        self.primaryLicense = primaryLicense
        self.name = name
        self.shiftInfo = shiftInfo
    }
    
    private func startInterval() -> Double {
        guard let start = self.shiftInfo["start"] else { return 0.0 }
        return start
    }
    
    private func endInterval() -> Double {
        guard let end = self.shiftInfo["duration"], let start = self.shiftInfo["start"] else { return 0.0 }
        return start + end
    }
    
    func startTime() -> Double {
        let currentMidnight = Helper().currentMidnightDate()
        let start = currentMidnight.addingTimeInterval(self.startInterval()).timeIntervalSince1970
        return start
    }
    
    func endTime() -> Double {
        let startTime = self.startTime()
        let date = Date(timeIntervalSince1970: startTime)
        let end = date.addingTimeInterval(self.endInterval()).timeIntervalSince1970
        
        return end
    }

}

func loadJson(filename fileName: String) -> [Therapist]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ResponseData.self, from: data)
            return jsonData.therapists
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
