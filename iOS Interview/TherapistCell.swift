//
//  TherapistCell.swift
//  iOS Interview
//
//  Created by Kelvin Lee on 12/10/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class TherapistCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var therapistSinceLabel: UILabel!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellForGaps(gap: (Date, Date)) {
        self.remainingLabel.isHidden = true
        self.therapistSinceLabel.isHidden = true
        self.titleLabel.isHidden = true
        self.sessionTimeLabel.text = "No Therapist: \(Helper().getDateString(interval: gap.0.timeIntervalSince1970)) to \(Helper().getDateString(interval: gap.1.timeIntervalSince1970))"
    }

    func setupCellForOnDuty(therapist: Therapist) {
        self.titleLabel.text = therapist.name
        
        let sinceDate = Helper().dateForTherapistSince(interval: therapist.therapistSince)
        self.therapistSinceLabel.text = "\(therapist.primaryLicense) since \(sinceDate)"
        
        let start = therapist.startTime()
        let end = therapist.endTime()
//        let current = Date().timeIntervalSince1970
//        let gap = end - current
        
        let startDateString = Helper().getDateString(interval: start)
        let endDateString = Helper().getDateString(interval: end)
        self.remainingLabel.isHidden = false
        self.remainingLabel.isHidden = false
        self.therapistSinceLabel.isHidden = false
        self.titleLabel.isHidden = false
        self.remainingLabel.text = "\(Helper().getRemainingTime(endTimeInterval: therapist.endTime()))"
        self.sessionTimeLabel.text = "On Duty \(startDateString) to \(endDateString)"
    }
    
    func setupCellStartingSoon(therapist: Therapist) {
        self.titleLabel.text = therapist.name
        
        let sinceDate = Helper().dateForTherapistSince(interval: therapist.therapistSince)
        self.therapistSinceLabel.text = "\(therapist.primaryLicense) since \(sinceDate)"
        
        let start = therapist.startTime()
        let end = therapist.endTime()
        
        let startDateString = Helper().getDateString(interval: start)
        let endDateString = Helper().getDateString(interval: end)
        self.remainingLabel.isHidden = false
        self.remainingLabel.isHidden = false
        self.therapistSinceLabel.isHidden = false
        self.titleLabel.isHidden = false
        self.remainingLabel.text = Helper().getTimeTillStart(startTimeInterval: therapist.startTime())
        self.sessionTimeLabel.text = "On Duty \(startDateString) to \(endDateString)"
    }
}
