//
//  BottomAlertModel.swift
//  DesignSystem
//
//  Created by Салим Абдулвагабов on 11.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

public struct BottomAlertModel {
    let text: String
    let buttonText: String?
    weak var delegate: BottomAlertViewDelegate?

    public init(
        text: String,
        buttonText: String? = nil,
        delegate: BottomAlertViewDelegate? = nil
    ) {
        self.text = text
        self.buttonText = buttonText
        self.delegate = delegate
    }
}
