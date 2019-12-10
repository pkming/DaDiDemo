//
//  AppModel.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON
import WCDBSwift

public class AppModel: TableCodable, HandyJSON {
    public var title: String!

    public var image: String!

    public var category: String!

    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = AppModel

        public static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case title
        case image
        case category

        // 设置主键
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                title: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
            ]
        }
    }

    public required init() {}
    public required init(json: JSON) {
        title = json["title"]["label"].stringValue
        image = json["im:image"][0]["label"].stringValue
        category = json["category"]["attributes"]["label"].stringValue
    }

    public required init(search: JSON) {
        title = search["trackName"].stringValue
        image = search["artworkUrl60"].stringValue
        category = search["primaryGenreName"].stringValue
    }
}
