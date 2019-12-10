//
//  DaDiContactDB.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import Foundation
import WCDBSwift

class DaDiAppsDB {
    static let instanse = DaDiAppsDB()

    static func shard() -> DaDiAppsDB? {
        if instanse.createTableIfNeed() {
            return instanse
        }

        return nil
    }

    let tableName: String = "appModel"

    let dbPath = DaDiFileManager.shard().getPath(.DB, userId: nil, fileName: "appModel.db")

    func createTableIfNeed() -> Bool {
        print("数据库地址：\(dbPath!.path)")
        let db = Database(withPath: dbPath!.path)

        // 2.创建数据库表
        do {
            try db.create(table: tableName, of: AppModel.self)
            return true
        } catch {
            print("\(tableName)创建失败")
            return false
        }
    }

    func getDB() -> (Bool, Database) {
        let db = Database(withPath: dbPath!.path)

        if !db.canOpen {
            print("\(tableName)数据库无法打开")
            return (false, db)
        }

        return (true, db)
    }

    /// 插入
    ///
    /// - Parameter contacts: 通讯录
    /// - Returns: 成功失败
    func add(_ apps: [AppModel]) -> Bool {
        let (isCanOpen, db) = getDB()
        if !isCanOpen {
            return false
        }

        do {
            // insert(objects:intoTable:) 接口内置了事务，并对批量数据做了针对性的优化，性能更好
            try db.insertOrReplace(objects: apps, intoTable: tableName)
            return true
        } catch {
            print("ERROR，未插入\(apps.count)条数据库")
            return false
        }
    }

    func findAll() -> [AppModel]? {
        let (isCanOpen, db) = getDB()
        if !isCanOpen {
            return []
        }

        do {
            let contacts: [AppModel] = try db.getObjects(on: AppModel.CodingKeys.all, fromTable: tableName)
            return contacts
        } catch {
            return nil
        }
    }
}
