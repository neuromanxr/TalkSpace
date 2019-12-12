//
//  Helper.swift
//  iOS Interview
//
//  Created by Kelvin Lee on 12/11/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

struct Helper {
    func dateForTherapistSince(interval: Double) -> String {
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "MM/dd/YYYY"
//        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
    func getDateString(interval: Double) -> String {
//        let start = self.currentMidnightDate().addingTimeInterval(interval)
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
    func getRemainingTime(endTimeInterval: TimeInterval) -> String {
        let currentDate = Date()
        let endDate = Date(timeIntervalSince1970: endTimeInterval)
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.hour, .minute], from: currentDate, to: endDate)
        if let hour = difference.hour, let minute = difference.minute {
            return "\(hour)hr \(minute)min till end"
        } else {
            return ""
        }
    }
    
    func getTimeTillStart(startTimeInterval: TimeInterval) -> String {
        let currentDate = Date()
        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.hour, .minute], from: currentDate, to: startDate)
        if let hour = difference.hour, let minute = difference.minute {
            return "\(hour)hr \(minute)min till start"
        } else {
            return ""
        }
    }
    
    func currentMidnightDate() -> Date {
        // get the current date and time
        let currentDateTime = Date()
        
        let cal: Calendar = Calendar(identifier: .gregorian)
        
        let midnightDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: currentDateTime)!
        
        // initialize the date formatter and set the style
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        // get the date time String from the date object
//        let currentDate = dateFormatter.string(from: midnightDate)
        return midnightDate
    }
    
    func mergeSort(_ array: [Therapist], ascending: Bool) -> [Therapist] {
        guard array.count > 1 else { return array }    // 1
        
        let middleIndex = array.count / 2              // 2
        
        let leftArray = mergeSort(Array(array[0..<middleIndex]), ascending: ascending)             // 3
        
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]), ascending: ascending)  // 4
        
        return merge(leftPile: leftArray, rightPile: rightArray, ascending: ascending)             // 5
    }
    
    func merge(leftPile: [Therapist], rightPile: [Therapist], ascending: Bool) -> [Therapist] {
        // 1
        var leftIndex = 0
        var rightIndex = 0

        // 2
        var orderedPile = [Therapist]()
        orderedPile.reserveCapacity(leftPile.count + rightPile.count)
        
        // 3
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            
            let current = Date().timeIntervalSince1970
            
            let leftTherapist = leftPile[leftIndex]
            let rightTherapist = rightPile[rightIndex]
            
            let leftEnd = leftTherapist.endTime()
            let leftGap = leftEnd - current
            
            let rightEnd = rightTherapist.endTime()
            let rightGap = rightEnd - current
            
            if ascending {
                if leftGap > rightGap {
                    orderedPile.append(leftPile[leftIndex])
                    leftIndex += 1
                } else if leftGap < rightGap {
                    orderedPile.append(rightPile[rightIndex])
                    rightIndex += 1
                } else {
                    orderedPile.append(leftPile[leftIndex])
                    leftIndex += 1
                    orderedPile.append(rightPile[rightIndex])
                    rightIndex += 1
                }
            } else {
                if leftGap < rightGap {
                    orderedPile.append(leftPile[leftIndex])
                    leftIndex += 1
                } else if leftGap > rightGap {
                    orderedPile.append(rightPile[rightIndex])
                    rightIndex += 1
                } else {
                    orderedPile.append(leftPile[leftIndex])
                    leftIndex += 1
                    orderedPile.append(rightPile[rightIndex])
                    rightIndex += 1
                }
            }
        }

        // 4
        while leftIndex < leftPile.count {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
        }

        while rightIndex < rightPile.count {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }

        return orderedPile
    }
}
