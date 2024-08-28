//
//  SettingsViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol SettingsViewInput: AlertPresentable, Loadable {
    func update(with viewModel: SettingsViewModel)
}

final class SettingsViewController: UIViewController {

    // MARK: - Properties

	var presenter: SettingsViewOutput?

    private let tableView = UITableView()

    private lazy var closeButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
    }()

    private var viewModel: SettingsViewModel?

    // MARK: - Life cycle

	override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        presenter?.viewIsReady()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.settings.value))
    }

    // MARK: - Drawing

    private func setupSubviews() {
        title = Localized.settings()
        view.backgroundColor = Colors.screenBackground()
        tableView.backgroundColor = Colors.screenBackground()
        let backImage = Images.backArrowIcon()?
            .withInsets(.init(top: 0, left: 7, bottom: 0, right: 0))?
            .withTintColor(Colors.text()!, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellTypes: [
            SettingsCell.self,
            SeparatorCell.self
        ])
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    @objc private func closeButtonClick() {
        presenter?.closeButtonClick()
    }

}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rows.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let row = viewModel?.rows[safe: indexPath.row] else {
            assertionFailure("Failed to init cell in \(className)")
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseId, for: indexPath)
        row.configurator.configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = viewModel?.rows[safe: indexPath.row] else {
            return
        }
        presenter?.didSelectCell(type)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = viewModel?.rows[safe: indexPath.row] else {
            return UITableView.automaticDimension
        }
        return row.configurator.cellHeight
    }
}

// MARK: - SettingsViewInput
extension SettingsViewController: SettingsViewInput {

    func update(with viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

}
