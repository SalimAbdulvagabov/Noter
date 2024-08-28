//
//  CorneredLabel.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 12.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

final class CorneredLabel: UIView {

    private lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    var text: String? {
        didSet {
            label.text = text
        }
    }

    var font: UIFont? {
        didSet {
            label.font = font
        }
    }

    var textAligment: NSTextAlignment? {
        didSet {
            label.textAlignment = textAligment ?? .center
        }
    }

    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: .init(top: 5,
                                                       left: 14,
                                                       bottom: 5,
                                                       right: 14))
    }

}
