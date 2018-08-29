//
//  ViewController.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

class ActivityLogController: NSViewController, ClockDelegate {

    @IBOutlet weak var remainingTime: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let clock = Clock()
        clock.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func onCurrentTime(_ currentTime: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        remainingTime.stringValue = formatter.string(from: currentTime)
    }

}
