//
//  DetailViewController.swift
//  MusicLibrary
//
//  Created by Josue Ballona on 11/28/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    

    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.navigationItem.title = detail.title
            if let label = artistLabel {
                label.text = "By: \(detail.artist ?? "")"
            }
            if let label = releaseYearLabel {
                label.text = "Released: \(detail.releaseyear ?? "")"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Album? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

