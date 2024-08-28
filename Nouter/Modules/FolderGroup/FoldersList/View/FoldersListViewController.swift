//
//  FoldersListViewController.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 13.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class FoldersListViewController: UIViewController {

    // MARK: - Views

    private lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView()
        tableView.backgroundColor = Colors.screenBackground()
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
//        tableView.dragInteractionEnabled = true
        tableView.register(cellTypes: [
            FolderCell.self
        ])
        return tableView
    }()

    private lazy var closeButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
    }()

    private lazy var plusButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setImage(Images.plusFolder(), for: .normal)
        btn.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        return btn
    }()

    // MARK: - Properties

    var output: FoldersListViewOutput?

    private var folders: [FolderModel] = []
    private var currentFolder: FolderModel?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        Notifications.addObserver(self, selector: #selector(reloadFolders), names: [.folderCreated])
        output?.viewIsReady()
    }

    deinit {
        Notifications.removeAllObservers(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output?.viewWillDisappear(with: folders)
    }

    // MARK: - Drawing

    private func setupSubviews() {
        title = Localized.folders()
        view.backgroundColor = Colors.screenBackground()
        view.addSubview(tableView)
        tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 68)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        let backImage = Images.backArrowIcon()?
            .withInsets(.init(top: 0, left: 7, bottom: 0, right: 0))?
            .withTintColor(Colors.text()!, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
    }

    @objc private func closeButtonClick() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func plusButtonClick() {
        output?.plusButtonClick()
    }

    @objc private func reloadFolders() {
        output?.viewIsReady()
        resize()
    }

    private func resize() {
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.shouldRecognizeSimultaneouslyWith = true
        controller.resize(to: .fixed(PopUpsHeights.folders(count: folders.count).value))
    }
}

// MARK: - UITableViewDataSource
extension FoldersListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: FolderCell.className,
                                     for: indexPath) as? FolderCell,
              let folder = folders[safe: indexPath.row] else {
            return UITableViewCell()
        }

        cell.configure(with: .init(name: folder.name,
                                   count: folder.count,
                                   checked: folder.id == currentFolder?.id))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
}

// MARK: - UITableViewDelegate
extension FoldersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let folder = folders[safe: indexPath.row], currentFolder?.id != folder.id else {
            return
        }
        currentFolder = folder
        output?.selectFolder(folder: folder)
        tableView.reloadData()
    }

    func tableView( _ tableView: UITableView,
                    contextMenuConfigurationForRowAt indexPath: IndexPath,
                    point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.row != 0 else {
            return nil
        }
        let contextMenu = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath,
                                                      previewProvider: nil,
                                                      actionProvider: {  _ in
            let deleteAction = UIAction(
                title: Localized.delete(),
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [unowned self] _ in
                self.output?.deleteFolder(index: indexPath.row)
            }

            let editAction = UIAction(
                title: "Изменить"
            ) { [unowned self] _ in
                self.output?.changeFolder(index: indexPath.row)
            }

            return UIMenu(title: "",
                          image: nil,
                          children: [editAction, deleteAction])
        })
        return contextMenu
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != 0 else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: nil) { [unowned self] _, _, complete in
            self.output?.deleteFolder(index: indexPath.row)
            complete(true)
        }

        let editAction = UIContextualAction(style: .normal,
                                            title: nil) { [unowned self] _, _, complete in
            self.output?.changeFolder(index: indexPath.row)
            complete(true)
        }
        editAction.backgroundColor = Colors.separator()
        editAction.image = Images.pensil()
        deleteAction.image = Images.deleteIcon()
        deleteAction.backgroundColor = UIColor(rgb: 0xFF573D)
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }
}

// MARK: - Drag and Drop
extension FoldersListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let folder = folders[safe: indexPath.row], indexPath.row != 0 else {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = folder
        return [dragItem]
    }
}

extension FoldersListViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let source = coordinator.items.first?.sourceIndexPath,
        let destination = coordinator.destinationIndexPath,
        let model = folders[safe: source.row], destination.row != 0 else {
            return
        }

        folders.remove(at: source.row)
        folders.insert(model, at: destination.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }

}

// MARK: - SettingsViewInput
extension FoldersListViewController: FoldersListViewInput {
    func setupInitialState(_ folders: [FolderModel], current: FolderModel) {
        self.folders = folders
        self.currentFolder = current
        tableView.reloadData()
    }

    func removeRow(_ row: Int) {
        folders.remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        resize()
    }

    func setDefaultFolder() {
        currentFolder = folders.first
        tableView.reloadRows(at: [.init(row: 0, section: 0)], with: .none)
    }
}
