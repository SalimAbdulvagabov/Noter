//
//  ScalledView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 12.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

class ScalledView: UIView {

    var scalledValue: CGFloat = 0.93

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: self.scalledValue, y: self.scalledValue)
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

}
