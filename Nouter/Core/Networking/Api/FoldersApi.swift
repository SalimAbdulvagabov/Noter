//
//  FoldersApi.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Alamofire

enum FoldersApi: IEndpoint {

    case update(folder: FolderModel)
    case delete(id: String)
    case load

    var path: String {
        "folder"
    }

    var method: HTTPMethod {
        switch self {
        case .update:
            return .post
        case .delete:
            return .delete
        case .load:
            return .get
        }
    }

    var parameters: Parameters? {
        var dict: Parameters

        switch self {
        case .update(let folder):
            dict = folder.toDictionary()
        case .delete(let id):
            dict = ["id": id]
        case .load:
            dict = [:]
        }
        let userUuid = DependecyContainer.shared.service.settings.userUuid()
        dict["userUuid"] = userUuid

        return dict
    }

}
