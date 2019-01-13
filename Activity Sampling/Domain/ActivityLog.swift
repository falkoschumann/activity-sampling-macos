//
//  ActivityLog.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 06.01.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

protocol ActivityLog {
    func write(activity: Activity)
}
