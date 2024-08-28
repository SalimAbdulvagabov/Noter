//
//  NoutesListViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import VisualEffectView
import CoreData

protocol NoutesListViewInput: AlertPresentable, Loadable {
    func update(noutes: [NoteModel], animateRow: Int?)
    func deleteRows(_ row: Int)
    func showEmptyView()
    func hideEmptyView()
    func hideDeleteView()
    func showBottomAlert(with model: DeleteNouteStatusView.Model)
    func changeFolderTitle(text: String)
    func updateWithMove(noutes: [NoteModel], from: Int, there: Int)
}

final class NoutesListViewController: UpdateStatusBarController {

    // MARK: - Views

    lazy private var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.screenBackground()
        tableView.register(cellTypes: [
            NoutesListCell.self
        ])
        return tableView
    }()

    lazy private var createNouteButton: LargeClickZoneButton = {
        let btn = LargeClickZoneButton()
        btn.setImage(Images.plusIcon(), for: .normal)
        btn.setTitle(Localized.createnote(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 16)
        btn.addTarget(self, action: #selector(createNouteButtonClick), for: .touchUpInside)
        return btn
    }()

    lazy private var deleteStatusView: DeleteNouteStatusView = {
        let view =  DeleteNouteStatusView()
        view.delegate = presenter as? DeleteNouteStatusViewDelegate
        return view
    }()

    private var emptyView = UIView()
    private var navigationView = NoutesListNavigationBarView()
    private var headerView = NoutesListHeaderView()

    // MARK: - Properties

    var presenter: NoutesListViewOutput?
    private var notes: [NoteModel] = []
    private var deleteNoute: NoteModel?
    private var deleteRow: Int?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        Notifications.addObserver(self, selector: #selector(updateViewController), names: [.nouteCreated, .currentFolderChanged])
        Notifications.addObserver(self, selector: #selector(nouteChanged(_:)), names: [.nouteChanged])
        Notifications.addObserver(self, selector: #selector(nouteDelete(_:)), names: [.deleteNoute])
        presenter?.viewIsReady()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }

    deinit {
        Notifications.removeAllObservers(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }

    // MARK: - Drawing
    // swiftlint:disable function_body_length
    private func setupSubviews() {
        view.backgroundColor = Colors.screenBackground()
        view.addSubview(tableView)
        tableView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)

        let createNouteView = UIView()
        view.addSubview(createNouteView)
        createNouteView.autoPinEdge(toSuperviewEdge: .left)
        createNouteView.autoPinEdge(toSuperviewEdge: .right)

        if InterfaceUtils.hasMatch {
            createNouteView.autoPinEdge(toSuperviewEdge: .bottom)
            createNouteView.autoSetDimension(.height, toSize: createNouteHeight)
        } else {
            createNouteView.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
            createNouteView.autoSetDimension(.height, toSize: createNouteHeight)
        }

        let blurView = VisualEffectView()
        blurView.colorTint = Colors.screenBackground()
        blurView.colorTintAlpha = 0.9
        blurView.blurRadius = 6
        blurView.scale = 1
        createNouteView.addSubview(blurView)
        blurView.autoPinEdgesToSuperviewEdges()

        createNouteView.addSubview(createNouteButton)

        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(createNouteButtonClick))
        upSwipe.direction = .up
        createNouteView.addGestureRecognizer(upSwipe)

        createNouteButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12,
                                                                          left: 30,
                                                                          bottom: 0,
                                                                          right: 30),
                                                       excludingEdge: .bottom)

        view.addSubview(navigationView)
        navigationView.autoPinEdge(toSuperviewEdge: .top)
        navigationView.autoPinEdge(toSuperviewEdge: .left)
        navigationView.autoPinEdge(toSuperviewEdge: .right)
        navigationView.autoSetDimension(.height, toSize: navVarHeight)

        view.addSubview(deleteStatusView)
        deleteStatusView.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
        deleteStatusView.autoPinEdge(toSuperviewEdge: .right, withInset: 8)
        deleteStatusView.autoPinEdge(.bottom, to: .top, of: createNouteView, withOffset: 8)

        headerView.delegate = self
        navigationView.delegate = self
        setupEmptyView()
    }

    private func setupEmptyView() {
        let emptyTitleLabel = UILabel()
        emptyTitleLabel.text = Localized.notesListEmptyTitle()
        emptyTitleLabel.textColor = Colors.text()
        emptyTitleLabel.font = Fonts.interSemiBold(size: 24)

        let emptyDescriptionLabel = UILabel()
        emptyDescriptionLabel.numberOfLines = 0
        emptyDescriptionLabel.textAlignment = .center
        emptyDescriptionLabel.text = Localized.notesListEmptyDescription()
        emptyDescriptionLabel.textColor = Colors.text()
        emptyDescriptionLabel.font = Fonts.interRegular(size: 16)

        let emptyImageView = UIImageView(image: Images.emptyNoutesListIcon())
        emptyView.contentMode = .scaleAspectFill

        view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.autoAlignAxis(toSuperviewAxis: .horizontal)
        emptyView.autoAlignAxis(toSuperviewAxis: .vertical)

        emptyView.addSubview(emptyTitleLabel)
        emptyView.addSubview(emptyDescriptionLabel)
        emptyView.addSubview(emptyImageView)

        emptyImageView.autoPinEdgesToSuperviewEdges()
        emptyImageView.autoSetDimensions(to: CGSize(width: 144, height: 144))

        emptyTitleLabel.autoPinEdge(.top, to: .bottom, of: emptyImageView, withOffset: 16)
        emptyTitleLabel.autoAlignAxis(toSuperviewAxis: .vertical)

        emptyDescriptionLabel.autoPinEdge(.top, to: .bottom, of: emptyTitleLabel, withOffset: 8)
        emptyDescriptionLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        emptyDescriptionLabel.autoPinEdge(toSuperviewEdge: .bottom)
    }

    private func updateNavBar() {
        let offset = -tableView.contentOffset.y + (InterfaceUtils.hasMatch ? 45 : 40)
        navigationView.contentPosition(value: offset - 2)
        headerView.alpha = offset / 13
        headerView.scrollOffset = tableView.contentOffset.y * 1.5
    }

    @objc private func createNouteButtonClick() {
        presenter?.createNouteTap()
    }

    @objc private func updateViewController() {
        presenter?.viewIsReady()
    }

    @objc private func nouteChanged(_ notification: NSNotification) {
        guard let id = notification.userInfo?["id"] as? String,
              let nouteIndex = notes.firstIndex(where: {$0.id == id}) else {
                  presenter?.viewIsReady()
                  return
              }

        let newFolderName = notification.userInfo?["newFolderName"] as? String

        presenter?.nouteChanged(nouteIndex: nouteIndex, newFolder: newFolderName)
    }

    @objc private func nouteDelete(_ notification: NSNotification) {
        guard let id = notification.userInfo?["id"] as? String,
              let nouteIndex = notes.firstIndex(where: {$0.id == id}) else {
                  return
              }

        presenter?.deleteNouteClick(nouteIndex)

    }

    private func deleteRows(_ indexPaths: IndexPath, afterTime: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterTime) { [weak self] in
            self?.presenter?.deleteNouteClick(indexPaths.row)
        }
    }
}

// MARK: - UITableViewDataSource
extension NoutesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: NoutesListCell.className, for: indexPath) as? NoutesListCell,
              let noute = notes[safe: indexPath.row] else {
                  return UITableViewCell()
              }
        cell.configure(with: NoutesListCell.Model(noute: noute))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoutesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCell(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavBar()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        createNouteHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }

    func tableView( _ tableView: UITableView,
                    contextMenuConfigurationForRowAt indexPath: IndexPath,
                    point: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenu =  UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil, actionProvider: {  [weak self] _ in
            guard let self = self else {             return UIMenu(title: "",
                                                                   image: nil,
                                                                   children: [])  }

            let deleteAction = UIAction(title: Localized.delete(),
                                        image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self ]_ in
                self?.deleteRows(indexPath, afterTime: 0.68)
            }

            let note = self.notes[indexPath.row]
            let foldersActions = self.presenter?.getFoldersForMove(for: note).map { folder in
                UIAction(title: folder.name) { [weak self] _ in
                    self?.presenter?.moveToFolder(folder, note: note, index: indexPath.row)
                }
            } ?? []

            let moveFolderButton = UIMenu(title: "Переместить в папку", children: foldersActions)

            return UIMenu(title: "",
                          image: nil,
                          children: [moveFolderButton, deleteAction])
        })
        return contextMenu
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, complete in
            self?.presenter?.deleteNouteClick(indexPath.row)
            complete(true)
        }

        deleteAction.image = Images.deleteIcon()
        deleteAction.backgroundColor = UIColor(rgb: 0xFF573D)
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }

}

// MARK: - NoutesListNavigationBarViewDelegate
extension NoutesListViewController: NoutesListNavigationBarViewDelegate {
    func settingsButtonClick() {
        presenter?.settingsTap()
    }

    func foldersButtonClick() {
        presenter?.foldersClick()
    }
}

// MARK: - NoutesListViewInput
extension NoutesListViewController: NoutesListViewInput {
    func deleteRows(_ row: Int) {
        if notes[safe: row] != nil {
            notes.remove(at: row)
            tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        }
        if notes.isEmpty {
            showEmptyView()
        }
        updateNavBar()
    }

    func showEmptyView() {
        guard emptyView.isHidden else {
            return
        }
        tableView.isScrollEnabled = false
        emptyView.isHidden = false
    }

    func hideEmptyView() {
        guard !emptyView.isHidden else {
            return
        }
        emptyView.isHidden = true
        tableView.isScrollEnabled = true
    }

    func update(noutes: [NoteModel], animateRow: Int?) {
        if let animateRow = animateRow, noutes.count - self.notes.count == 1 {
            self.notes = noutes
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: animateRow, section: 0)], with: .automatic)
            tableView.endUpdates()
            updateNavBar()
        } else {
            self.notes = noutes
            tableView.reloadData()
        }
        noutes.isEmpty ? showEmptyView() : hideEmptyView()
    }

    func showBottomAlert(with model: DeleteNouteStatusView.Model) {
        deleteStatusView.showView(with: model)
    }

    func hideDeleteView() {
        deleteStatusView.hideView()
    }

    func updateWithMove(noutes: [NoteModel], from: Int, there: Int) {
        self.notes = noutes

        tableView.beginUpdates()
        tableView.moveRow(at: IndexPath(row: from, section: 0), to: IndexPath(row: there, section: 0))
        tableView.endUpdates()
        tableView.reloadRows(at: [.init(row: there, section: 0)], with: .automatic)
    }

    func changeFolderTitle(text: String) {
        navigationView.text = text
        headerView.text = text
    }

}

private let navVarHeight: CGFloat = InterfaceUtils.hasMatch ? 88 : 66
private let createNouteHeight: CGFloat = InterfaceUtils.hasMatch ? 94 : 64
