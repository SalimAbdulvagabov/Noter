//
//  ViewOutput.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

protocol ViewOutput: AnyObject {

    func viewIsReady()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func deInit()
    func didTapDismissButton()
    func viewWillDeinit()
}

extension ViewOutput {

    // MARK: - Default implementation

    func viewIsReady() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
    func viewWillDisappear() { }
    func deInit() { }
    func didTapDismissButton() { }
    func viewWillDeinit() { }
}
