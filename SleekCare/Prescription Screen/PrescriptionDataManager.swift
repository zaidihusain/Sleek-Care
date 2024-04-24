//
//  PrescriptionDataManager.swift
//  SleekCare
//
//  Created by Nabeel on 13/04/24.
//

import Foundation

class PrescriptionDataManager {
    static let shared = PrescriptionDataManager()
    
    private let defaults = UserDefaults.standard
    private let key = "prescriptionArray"
    
    var prescriptionArray: [String] {
        get {
            return defaults.array(forKey: key) as? [String] ?? [""] // Return the saved array or [""] if none exists
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
    
    private init() {}
}

