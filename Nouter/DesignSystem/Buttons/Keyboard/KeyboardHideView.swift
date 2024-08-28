//
//  KeyboardHideButton.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 25.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import VisualEffectView

final class KeyboardHideView: ScalledView {
    private let blurView = VisualEffectView().then { blurView in
        blurView.colorTint = Colors.deleteView()
        blurView.colorTintAlpha = 0.6
        blurView.blurRadius = 6
        blurView.scale = 1
    }

    override var intrinsicContentSize: CGSize {
        .init(width: .side, height: .side)
    }

    private let imageView = UIImageView(image: Images.hideKeyboard())

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = .side/2
        clipsToBounds = true

        addSubviews([
            blurView,
            imageView
        ])

        blurView.autoSetDimensions(to: .init(width: .side, height: .side))
        blurView.autoPinEdgesToSuperviewEdges()

        imageView.autoSetDimensions(to: .init(width: .imageSide, height: .imageSide))
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
}

private extension CGFloat {
    static let side: Self = 40
    static let imageSide: Self = 24
}
