//
//  DaDiApi.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import Foundation
import Moya

enum DaDiAPI {
    case topfreeapplications(header: [String: String], params: [String: Any])

    case lookup(header: [String: String], params: [String: Any])

    case search(header: [String: String], params: [String: Any])
}

extension DaDiAPI: TargetType {
    var headers: [String: String]? {
        switch self {
        case let .topfreeapplications(header, _):
            return header

        case let .lookup(header, _):
            return header

        case let .search(header, _):
            return header
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "测试")!
    }

    public var baseURL: URL {
        return URL(string: "https://itunes.apple.com/hk/")!
    }

    public var path: String {
        switch self {
        case .topfreeapplications:
            return "rss/topfreeapplications/limit=10/json"
        case .lookup:
            return "lookup"

        case .search:
            return "search"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case let .topfreeapplications(_, params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .lookup(_, params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .search(_, params):
            let keyWord: String = params["keyWord"] as! String
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: URLEncoding.httpBody, urlParameters: ["term": keyWord])
        }
    }
}
