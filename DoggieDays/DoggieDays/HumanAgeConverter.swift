//
//  HumanAgeConverter.swift
//  DoggieDays
//
//  Created by Josue Ballona on 9/24/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import Foundation
import UIKit

// will convert the dog age to human age
class HumanAgeConverter {
    // holds the final human age
    var humanAge: Int
    
    // initialize the instance.
    init(age: Int) {
        switch age {
            // if age is 1, then in human age it is 15
        case 1:
            self.humanAge = 15
            // if 2, then in human age, 24
        case 2:
            self.humanAge = 15 + 9
            // if 3 or more, than age is at least 29
        case (3...):
            self.humanAge = 15 + 9 + (age - 2) * 5
        default:
            self.humanAge = 0
        }
    }
    
}
