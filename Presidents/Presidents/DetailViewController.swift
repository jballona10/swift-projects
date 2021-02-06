//
//  DetailViewController.swift
//  Presidents
//
//  Created by Josue Ballona on 10/31/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var termDateLabel: UILabel!
    @IBOutlet weak var nicknamesLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        // Update name label
        if let detail = detailItem {
            if let label = nameLabel {
                label.text = detail.name
            }
            // update presidential order label
            if let label = orderLabel {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                label.text = formatter.string(from: detail.number as NSNumber)
                label.text! += " president of the United States."
            }
            // update presidential term label
            if let label = termDateLabel {
                label.text = "(\(detail.startDate) to \(detail.endDate))"
            }
            // update nickname label
            if let label = nicknamesLabel {
                label.text = detail.nickname
            }
            // update political party label
            if let label = partyLabel {
                label.text = detail.politicalParty
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: President? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

