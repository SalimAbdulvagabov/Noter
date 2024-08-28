//
//  NoutesListCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 09.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class NoutesListCell: UITableViewCell {

    // MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.interBold(size: 16)
        label.numberOfLines = 1
        label.textColor = Colors.text()
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Fonts.interRegular(size: 14)
        label.textColor = Colors.text()
        return label
    }()

    private lazy var separatoView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator()
        return view
    }()

    private let stackView = UIStackView(axis: .vertical, spacing: 8)

    var model: Model!

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
    }

    // MARK: - UI funcs

    private func setupUI() {
        backgroundColor = Colors.screenBackground()
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
        selectionStyle = .none
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        contentView.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: verticalOffset)
        stackView.autoPinEdge(toSuperviewEdge: .left, withInset: horizontalOffset)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: verticalOffset + 1)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: verticalOffset)

        contentView.addSubview(separatoView)
        separatoView.autoSetDimension(.height, toSize: 1)
        separatoView.autoPinEdge(toSuperviewEdge: .left, withInset: horizontalOffset)
        separatoView.autoPinEdge(toSuperviewEdge: .right, withInset: horizontalOffset)
        separatoView.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

// MARK: - Configurable
extension NoutesListCell: Configurable {
    
    struct Model {
        let noute: NoteModel
    }

    func configure(with model: Model) {
        self.model = model
        titleLabel.text = model.noute.name
        titleLabel.isHidden = model.noute.name == nil || model.noute.name?.isEmpty == true
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setTextWithLineSpacing(text: model.noute.name, spacing: 1.07)

        let description = model.noute.text?.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        descriptionLabel.text = description
        descriptionLabel.isHidden = model.noute.text == nil
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.setTextWithLineSpacing(text: description, spacing: 5)
        descriptionLabel.numberOfLines = model.noute.name.isNil ? 2 : 1
    }
}

private let verticalOffset: CGFloat = 24
private let horizontalOffset: CGFloat = 20
private let deleteViewSide: CGFloat = 40
