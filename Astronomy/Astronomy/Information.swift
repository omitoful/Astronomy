//
//  Information.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/8.
//

import Foundation
import UIKit

struct Picture {
    let url: String
    let title: String
    let hdurl: String
    let date: String
    let copyright: String
    let description: String
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255
        let greenValue = CGFloat(green) / 255
        let blueValue = CGFloat(blue) / 255
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
    }
}
