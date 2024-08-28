//
//  IntentViewController.swift
//  NouterIntentUI
//
//  Created by Салим Абдулвагабов on 13.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

final class IntentViewController: UIViewController, INUIHostedViewControlling {

    @IBOutlet private weak var textLabel: UILabel!

    private let notesService = NotesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let note = notesService.getRandonNote()
        textLabel.text = note.text ?? note.name ?? "Здесь могла быть гениальная мысль."
    }

    // MARK: - INUIHostedViewControlling

    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {

        completion(true, parameters, self.desiredSize)
    }

    var desiredSize: CGSize {
        let width = self.extensionContext!.hostedViewMaximumAllowedSize.width
        let height = textLabel.intrinsicContentSize.height + 32
        return .init(width: width, height: height)
    }

}
