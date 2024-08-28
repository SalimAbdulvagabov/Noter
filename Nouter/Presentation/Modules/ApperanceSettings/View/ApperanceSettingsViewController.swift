//
//  ApperanceSettingsViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol ApperanceSettingsViewInput: AlertPresentable, Loadable {
    func setupInitialState(apperance: ThemeType, icon: AppIconType)
}

final class ApperanceSettingsViewController: UIViewController {

    // MARK: - Views

    private lazy var themesView = ThemeSettingsView()

    private lazy var iconsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Иконка приложения"
        label.textAlignment = .left
        label.font = Fonts.interMedium(size: 16)
        label.textColor = Colors.loading()
        return label
    }()

    private lazy var iconsCollectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.decelerationRate = .normal
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(cellTypes: [
            ChangeIconAppCell.self
        ])

        return collection
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator()
        return view
    }()

    private lazy var closeButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
    }()

    // MARK: - Properties

    var presenter: ApperanceSettingsViewOutput?
    private var selectIcon: AppIconType = .bluewLightLines

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        presenter?.viewIsReady()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.apperance.value))
    }

    // MARK: - Drawing

    private func setupSubviews() {
        title = "Внешний вид"
        view.backgroundColor = Colors.screenBackground()
        let backImage = Images.backArrowIcon()?
            .withInsets(.init(top: 0, left: 7, bottom: 0, right: 0))?
            .withTintColor(Colors.text()!, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        view.addSubview(themesView)
        view.addSubview(iconsCollectionView)
        [themesView, iconsCollectionView, iconsTitleLabel, separatorView].forEach {
            view.addSubview($0)
        }
        iconsTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        iconsTitleLabel.autoPin(toTopLayoutGuideOf: self, withInset: 25)

        iconsCollectionView.autoPinEdge(.left, to: .left, of: iconsTitleLabel)
        iconsCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        iconsCollectionView.autoPinEdge(.top, to: .bottom, of: iconsTitleLabel, withOffset: 24)
        iconsCollectionView.autoSetDimension(.height, toSize: 68)

        separatorView.autoSetDimension(.height, toSize: 16)
        separatorView.autoPinEdge(toSuperviewEdge: .left)
        separatorView.autoPinEdge(toSuperviewEdge: .right)
        separatorView.autoPinEdge(.top, to: .bottom, of: iconsCollectionView, withOffset: 24)

        themesView.autoPinEdge(.left, to: .left, of: iconsCollectionView)
        themesView.autoPinEdge(.right, to: .right, of: iconsCollectionView)
        themesView.autoPinEdge(.top, to: .bottom, of: separatorView, withOffset: 20)
        themesView.delegate = self
    }

    // MARK: - Actions

    @objc private func closeButtonClick() {
        presenter?.closeButtonClick()
    }

}

extension ApperanceSettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let icon = AppIconType.allCases[safe: indexPath.row] else { return }
        selectIcon = icon
        collectionView.reloadData()
        presenter?.iconSelect(icon: icon)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 68
        let height = 68

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

}

extension ApperanceSettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppIconType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChangeIconAppCell.className, for: indexPath) as? ChangeIconAppCell,
              let iconType = AppIconType.allCases[safe: indexPath.row] else {
            assertionFailure("Failed to init cell in \(className)")
            return UICollectionViewCell()
        }
        cell.configure(with: .init(type: iconType, selected: iconType == selectIcon))

        return cell
    }

}

// MARK: - ApperanceSettingsViewInput
extension ApperanceSettingsViewController: ApperanceSettingsViewInput {
    func setupInitialState(apperance: ThemeType, icon: AppIconType) {
        selectIcon = icon
        iconsCollectionView.reloadData()
        themesView.themeSelect(type: apperance)
    }

}

extension ApperanceSettingsViewController: ThemeSettingsViewDelegate {
    func selectTheme(theme: ThemeType) {
        iconsCollectionView.reloadData()
        presenter?.themeSelect(theme: theme)
    }
}
