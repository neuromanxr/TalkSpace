//
//  ViewController.swift
//  iOS Interview
//
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Modes {
        case gaps
        case onDuty
        case startingSoon
    }
    
    var timeModes: Modes = .onDuty

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gapsButton: UIButton!
    @IBOutlet weak var onDutyButton: UIButton!
    @IBOutlet weak var startingSoonButton: UIButton!
    @IBAction func gapsButtonAction(_ sender: UIButton) {
        self.timeModes = .gaps
        loadGaps()
    }
    @IBAction func onDutyButtonAction(_ sender: UIButton) {
        self.timeModes = .onDuty
        loadOnDuty()
    }
    @IBAction func startingSoonButtonAction(_ sender: UIButton) {
        self.timeModes = .startingSoon
        loadStartingSoon()
    }
    
    var therapists = [Therapist]()
    var gaps = [(Date, Date)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gapsButton.layer.cornerRadius = 8.0
        gapsButton.clipsToBounds = true
        
        onDutyButton.layer.cornerRadius = 8.0
        onDutyButton.clipsToBounds = true
        
        startingSoonButton.layer.cornerRadius = 8.0
        startingSoonButton.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadOnDuty()
    }
    
    func loadGaps() {
        guard let therapists = readFile() else { return }
        
        let sorted = Helper().mergeSort(therapists, ascending: true)
        var gaps = [(Date, Date)]()
        for (idx, obj) in sorted.enumerated() {
            print("endTime:\(obj.endTime())")
            if idx + 1 != sorted.count {
                let timeGap = obj.endTime() - sorted[idx + 1].startTime()
                print("timeGaps:\(timeGap)")
                if timeGap > 0 {
                    let startGap = Date(timeIntervalSince1970: obj.endTime())
                    let endGap = Date(timeIntervalSince1970: sorted[idx + 1].startTime())
                    gaps.append((startGap, endGap))
                }
            }
        }
        self.gaps = gaps
        
        self.tableView.reloadData()
    }
    
    func loadOnDuty() {
        guard let therapists = readFile() else { return }
        
        let onDuty = therapists.filter { (therapist) -> Bool in
            let current = Date().timeIntervalSince1970
            let startTime = therapist.startTime()
            let endTime = therapist.endTime()
            let startDate = Date(timeIntervalSince1970: startTime)
            let endDate = Date(timeIntervalSince1970: endTime)
            let currentDate = Date(timeIntervalSince1970: current)
            let calendar = Calendar.current
            if calendar.compare(currentDate, to: startDate, toGranularity: .hour) == .orderedDescending && calendar.compare(currentDate, to: endDate, toGranularity: .hour) == .orderedAscending {
                return true
            } else {
                return false
            }
        }
        print("onduty count:\(onDuty.count)")
        self.therapists = Helper().mergeSort(onDuty, ascending: true)
        
        self.tableView.reloadData()
    }
    
    func loadStartingSoon() {
        guard let therapists = readFile() else { return }
        
        let onDuty = therapists.filter { (therapist) -> Bool in
            let current = Date().timeIntervalSince1970
            let startTime = therapist.startTime()
//            let endTime = therapist.endTime()
            let startDate = Date(timeIntervalSince1970: startTime)
//            let endDate = Date(timeIntervalSince1970: endTime)
            let currentDate = Date(timeIntervalSince1970: current)
            let calendar = Calendar.current
            if calendar.compare(currentDate, to: startDate, toGranularity: .hour) == .orderedAscending {
                return true
            } else {
                return false
            }
        }
        print("onduty count:\(onDuty.count)")
        self.therapists = Helper().mergeSort(onDuty, ascending: false)
        
        self.tableView.reloadData()
    }

    func readFile() -> [Therapist]? {
        guard let therapists = loadJson(filename: "therapists09") else { return nil }
        print("therapists: \(therapists.first!)")
        
        return therapists
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch timeModes {
        case .gaps:
            return self.gaps.count
        default:
            return self.therapists.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TherapistCell", for: indexPath) as! TherapistCell
        
        switch self.timeModes {
        case .gaps:
            let gap = self.gaps[indexPath.row]
            cell.setupCellForGaps(gap: gap)
            break
        case .onDuty:
            let therapist = self.therapists[indexPath.row]
            cell.setupCellForOnDuty(therapist: therapist)
            break
        case .startingSoon:
            let therapist = self.therapists[indexPath.row]
            cell.setupCellStartingSoon(therapist: therapist)
            break
        }
        return cell
    }
}

