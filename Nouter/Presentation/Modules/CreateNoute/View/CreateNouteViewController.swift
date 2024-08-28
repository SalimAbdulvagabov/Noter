//
//  CreateNouteViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol CreateNouteViewInput: AlertPresentable, Loadable {
    func setupInitialState(noute: NoteModel?)
    func updateFoldersActions()
}

final class CreateNouteViewController: UIViewController {

    // MARK: - Views

    private let scrollView = UIScrollView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.interSemiBold(size: 20)
        label.textColor = Colors.text()
        label.text = Localized.note()
        return label
    }()

    private lazy var closeView: CloseOrSaveView = { [weak self] in
        let view =  CloseOrSaveView()
        view.delegate = self
        return view
    }()

    private lazy var optionButton: LargeClickZoneButton = {
        let btn = LargeClickZoneButton()
        btn.setImage(Images.options(), for: .normal)
        btn.showsMenuAsPrimaryAction = true
        return btn
    }()

    private lazy var titleTextView: UITextView = { [weak self] in
        let textView = CustomTextView()
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = Fonts.interSemiBold(size: 24)
        textView.textColor = Colors.text()
        textView.autocorrectionType = .yes
        return textView
    }()

    private lazy var descriptionTextView: UITextView = { [weak self] in
        let textView = CustomTextView()
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.font = Fonts.interRegular(size: 16)
        textView.textColor = Colors.text()
        textView.autocorrectionType = .yes
        return textView
    }()

    private lazy var titlePlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.noteName()
        label.textColor = Colors.placeholder()
        label.font = Fonts.interSemiBold(size: 24)
        return label
    }()

    private lazy var descriptionPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.note()
        label.textColor = Colors.placeholder()
        label.font = Fonts.interRegular(size: 16)
        return label
    }()

    private lazy var keyboardHideView = KeyboardHideView().then {
        let size = $0.intrinsicContentSize
        $0.frame = .init(
            origin: .init(x: InterfaceUtils.screenWidth - 12 - size.width,
                          y: InterfaceUtils.screenHeight + 50),
            size: size
        )
        $0.addTapGestureRecognizer { [weak self] in
            self?.hideKeyboardView()
            self?.dismissKeyboard()
        }
    }

    // MARK: - Properties

    var presenter: CreateNouteViewOutput?
    private var initialNoute: NoteModel?
    private var nouteChanged = false

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addKeyboardNotifications()
        presenter?.viewIsReady()
        let newPosition = descriptionTextView.beginningOfDocument
        titleTextView.selectedTextRange = titleTextView.textRange(from: newPosition, to: newPosition)
        let tap = UITapGestureRecognizer(target: self, action: #selector(openDescriptionTextView(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if titleTextView.text == "" && descriptionTextView.text == "" {
            descriptionTextView.becomeFirstResponder()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !nouteChanged { return }
        let title = titleTextView.text
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet.whitespaces)
        let description = descriptionTextView.text
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet.whitespaces)
        presenter?.createNoteMoment(name: title == "" ? nil : title,
                                     text: description == "" ? nil : description)
    }

    // MARK: - Drawing

    private func setupSubviews() {
        view.backgroundColor = Colors.screenBackground()
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)

        view.addSubview(closeView)

        closeView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        closeView.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)

        view.addSubview(optionButton)

        optionButton.autoPinEdge(toSuperviewEdge: .left, withInset: 12)
        optionButton.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)

        view.addSubview(scrollView)
        scrollView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        scrollView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        let stackView = UIStackView(arrangedSubviews: [titleTextView, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 20

        scrollView.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24,
                                                                  left: 20,
                                                                  bottom: 24,
                                                                  right: 20))
        stackView.autoAlignAxis(toSuperviewAxis: .vertical)

        scrollView.addSubview(titlePlaceHolderLabel)
        titlePlaceHolderLabel.autoPinEdge(.top, to: .top, of: titleTextView, withOffset: 0)
        titlePlaceHolderLabel.autoPinEdge(.left, to: .left, of: titleTextView, withOffset: 6)
        titlePlaceHolderLabel.autoPinEdge(.bottom, to: .bottom, of: titleTextView, withOffset: 0)

        scrollView.addSubview(descriptionPlaceHolderLabel)
        descriptionPlaceHolderLabel.autoPinEdge(.top, to: .top, of: descriptionTextView, withOffset: 0)
        descriptionPlaceHolderLabel.autoPinEdge(.left, to: .left, of: descriptionTextView, withOffset: 6)
        descriptionPlaceHolderLabel.autoPinEdge(.bottom, to: .bottom, of: descriptionTextView, withOffset: 0)

        view.addSubview(keyboardHideView)
    }

    // MARK: - Keyboard notifications

    private func addKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }

    // MARK: - Actions

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset.bottom = 50
            hideKeyboardView()
        } else {
            scrollView.contentInset.bottom = keyboardViewEndFrame.height
            showKeyboardView(keyboardHeight: keyboardViewEndFrame.minY)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func openDescriptionTextView(_ touch: UITapGestureRecognizer) {
        let toushPoint = touch.location(in: self.view)
        if toushPoint.y >= descriptionTextView.frame.maxY && !descriptionTextView.isFirstResponder {
            descriptionTextView.becomeFirstResponder()
        }
    }

    // MARK: - TextView observer

    private func textViewPlaceholderConfig(textView: UITextView) {
        configNavigationButtons()
        switch textView {
        case titleTextView:
            titlePlaceHolderLabel.isHidden = textView.text != ""
        case descriptionTextView:
            descriptionPlaceHolderLabel.isHidden = textView.text != ""
        default:
            break
        }
    }

    private func updateStylesTextView(textView: UITextView) {
        let cursorRange = textView.selectedRange
        let style = NSMutableParagraphStyle()
        style.lineSpacing = textView == titleTextView ? 2 : 5
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: textView.font,
                          NSAttributedString.Key.foregroundColor: textView.textColor]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes as [NSAttributedString.Key: Any])
        textView.selectedRange = cursorRange
    }

    // MARK: - Option button menus

    private func configNavigationButtons() {
        nouteChanged = initialNoute?.name ?? "" != titleTextView.text ||
        initialNoute?.text ?? "" != descriptionTextView.text ||
        (presenter?.folderHasChanged() ?? false)

        let cancelChanges: UIAction!

        closeView.state = nouteChanged ? .save : .close

        if nouteChanged {
            cancelChanges = UIAction(title: Localized.noteCancelChanges()) { [weak self] _ in
                self?.presenter?.viewIsReady()
            }
        } else {
            cancelChanges = UIAction(title: Localized.noteCancelChanges(), attributes: .disabled) { [weak self] _ in
                self?.presenter?.viewIsReady()
            }
        }

        let deleteNoute = UIAction(title: Localized.noteDelete(), attributes: .destructive) { [weak self] _ in
            if self?.initialNoute == nil {
                self?.presenter?.viewIsReady()
            }
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.presenter?.deleteNouteClick()
            })
        }

        let foldersActions = presenter?.getFoldersForActions().map { folder in
            UIAction(title: folder.name) { [weak self] _ in
                self?.presenter?.moveToFolder(folder.id)
            }
        } ?? []

        let moveFolderButton = UIMenu(title: "Переместить в папку", children: foldersActions)

        optionButton.menu = UIMenu(title: "", children: [cancelChanges, moveFolderButton, deleteNoute])
    }

    // MARK: - Keyboard show and hide

    private func showKeyboardView(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0.1) { [weak self] in
            guard let self = self else { return }
            let size = self.keyboardHideView.intrinsicContentSize
            self.keyboardHideView.frame = .init(
                origin: .init(x: self.keyboardHideView.frame.minX,
                              y: keyboardHeight - 12 - size.height),
                size: size
            )
        }
    }

    private func hideKeyboardView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.keyboardHideView.frame = .init(
                origin: .init(x: self.keyboardHideView.frame.minX,
                              y: InterfaceUtils.screenHeight + 50),
                size: self.keyboardHideView.intrinsicContentSize
            )
        }
    }
}

extension CreateNouteViewController: CloseOrSaveViewDelegate {
    func saveButtonClick() {
        presenter?.closeButtonClick()
    }

    func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITextViewDelegate, NSLayoutManagerDelegate
extension CreateNouteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewPlaceholderConfig(textView: textView)
    }

    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderConfig(textView: textView)
        updateStylesTextView(textView: textView)
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if textView == titleTextView && text.contains("\n") {
            descriptionTextView.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - CreateNouteViewInput
extension CreateNouteViewController: CreateNouteViewInput {
    func setupInitialState(noute: NoteModel?) {
        initialNoute = noute
        titlePlaceHolderLabel.isHidden = (noute?.name != nil && noute?.name != "")
        descriptionPlaceHolderLabel.isHidden = (noute?.text != nil && noute?.text != "")
        titleTextView.text = noute?.name
        descriptionTextView.text = noute?.text
        updateStylesTextView(textView: titleTextView)
        updateStylesTextView(textView: descriptionTextView)
        configNavigationButtons()
    }

    func updateFoldersActions() {
        configNavigationButtons()
    }
}
