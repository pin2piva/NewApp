//
//  UILabel+countLabelLines.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 6.03.21.
//

import UIKit.UILabel


extension UILabel {
    
    func countLabelLines() -> Int {
        let myText = self.text! as NSString
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: self.font!], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
