//
//  SiriCommandsViewController.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import Combine
import Intents
import IntentsUI

final class SiriCommandsViewController: UIViewController {

    // MARK: - Public: properties

    var viewModel: SiriCommandsViewModel

    // MARK: - Private: properties

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.register(cellTypes: [ArrowCell.self])
        $0.bounces = false
        $0.separatorStyle = .none
    }

    private lazy var closeButton = BaseButton().then { [weak self] in
        $0.setImage(Images.closeIcon(), for: .normal)
        $0.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
    }

    private var commands: [String] = []

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(viewModel: SiriCommandsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        binding()
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.siriCommands.value))
    }

    // MARK: - Private: Funcs

    private func binding() {
        viewModel.$commands.sink(receiveValue: { [weak self] values in
            self?.commands = values
            self?.tableView.reloadData()
        })
        .store(in: &subscriptions)

        viewModel.$editShortcut.sink { [weak self] shortcut in
            guard
                let shortcut = shortcut,
                let self = self else { return }

            let editVC = INUIEditVoiceShortcutViewController(voiceShortcut: shortcut)
            editVC.delegate = self
            self.present(editVC, animated: true, completion: nil)
        }
        .store(in: &subscriptions)

        viewModel.$newShortcut.sink { [weak self] shortcut in
            guard
                let shortcut = shortcut,
                let self = self else { return }

            let addVC = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            addVC.delegate = self
            self.present(addVC, animated: true, completion: nil)
        }
        .store(in: &subscriptions)
    }

    private func setupSubviews() {
        title = Localized.siriCommands()
        view.backgroundColor = Colors.screenBackground()
        tableView.backgroundColor = Colors.screenBackground()
        let backImage = Images.backArrowIcon()?
            .withInsets(.init(top: 0, left: 7, bottom: 0, right: 0))?
            .withTintColor(Colors.text()!, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension SiriCommandsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArrowCell.className, for: indexPath) as? ArrowCell,
              let model = commands[safe: indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.configure(with: .init(text: model,
                                   hasSeparator: indexPath.row != commands.count - 1))

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        SiriCommandsHeaderView()
    }

}

// MARK: - UITableViewDelegate

extension SiriCommandsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row)
    }
}

// MARK: - INUIEditVoiceShortcutViewControllerDelegate?'

extension SiriCommandsViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        viewModel.shortcutsUpdate()
        controller.dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        viewModel.shortcutsUpdate()
        controller.dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

// MARK: - INUIAddVoiceShortcutViewControllerDelegate

extension SiriCommandsViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        viewModel.shortcutsUpdate()
        controller.dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
