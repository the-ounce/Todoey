//
//  UIColor+Random.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 07.08.2022.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        return UIColor(hexString: K.Colors.mdColors.randomElement() ?? "red")
    }
}
