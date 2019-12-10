//
//  DaDiFileManager.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import Foundation

public enum DaDiFilePathKey: String {
    // 日志文件路径
    case Logs

    // 音频文件路径
    case Audios

    // 视频文件路径
    case Videos

    // 图片文件路径
    case Images

    // 自定义表情包文件路径
    case Emojis

    // 聊天文件路径
    case Files

    // 本地数据库路径
    case DB

    // ReactNative 模块路径
    case RNModules

    // javascript 路径
    case JavaScripts

    // 邮箱路径
    case Mails

    // 其他文件路径
    case Others
}

public struct DaDiFileManager {
    static let instanse: DaDiFileManager = DaDiFileManager()

    public static func shard() -> DaDiFileManager {
        return instanse
    }

    // 项目主文件路径
    public let homeDir: String = {
        NSHomeDirectory()
    }()

    // document路径
    public let docDir: String = {
        let documentPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

        return documentPath
    }()

    // 缓存路径
    public let cacheDir: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }()

    // Library 路径
    public let libDir: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return paths[0]
    }()

    // 临时文件夹r路径
    public let tempDir: String = {
        NSTemporaryDirectory()
    }()

    // Bundle
    public let mainBundle: Bundle = {
        Bundle.main
    }()

    /// 获取文件分配的文件j路径
    ///
    /// - Parameters:
    ///   - type: 文件类型
    ///   - userId: 用户id
    ///   - fileName: 文件名
    /// - Returns: 路径
    public func getPath(_ type: DaDiFilePathKey, userId: String?, fileName: String?) -> URL? {
        var url: URL?

        switch type {
        case .Videos:
            url = URL(string: "\(tempDir)/\(userId ?? "common")/\(type.rawValue)") ?? URL(string: tempDir)
        default:
            url = URL(string: "\(docDir)/\(userId ?? "common")/\(type.rawValue)") ?? URL(string: homeDir)
        }

        if DaDiFileManager.createIfNeed(path: url!) {
            if fileName != nil, !fileName!.isEmpty {
                url = url?.appendingPathComponent(fileName!)
            }

            return url
        }

        return URL(string: tempDir)
    }

    /// 路径是否存在
    ///
    /// - Parameter path: s路径
    /// - Returns: 属否存在
    public static func isExist(_ path: String) -> Bool {
        guard path.isEmpty else {
            return false
        }

        if FileManager.default.fileExists(atPath: path) {
            return true
        }

        return false
    }

    /// 创建文件，如果存在就不创建
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 成功失败
    public static func createIfNeed(path: URL) -> Bool {
        if DaDiFileManager.isExist(path.path) {
            return true
        }

        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)

            return true
        } catch {
            return false
        }
    }

    /// 获取文件路径属性
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 属性
    public static func pathAttributes(_ path: String) -> [FileAttributeKey: Any] {
        do {
            let attr: [FileAttributeKey: Any] = try FileManager.default.attributesOfItem(atPath: path)

            return attr
        } catch {
            return [:]
        }
    }

    /// 获取文件路径的大小
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 大小
    public static func sizeFor(path: URL) -> UInt64 {
        guard DaDiFileManager.isExist(path.path) else {
            return 0
        }

        var totalSize: UInt64 = 0

        let resourceKeys: [URLResourceKey] = [.localizedNameKey, .creationDateKey, .localizedTypeDescriptionKey]

        do {
            let urls: [URL] = try FileManager.default.contentsOfDirectory(at: path,
                                                                          includingPropertiesForKeys: resourceKeys,
                                                                          options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)

            for url in urls {
                var pointer = ObjCBool(false)
                let isDir = FileManager.default.fileExists(atPath: url.path, isDirectory: &pointer)
                if isDir, pointer.boolValue {
                    let fileAttr: [FileAttributeKey: Any] = DaDiFileManager.pathAttributes(url.path)

                    totalSize += fileAttr[FileAttributeKey.size] as! UInt64
                } else {
                    totalSize += DaDiFileManager.sizeFor(path: url)
                }
            }
        } catch {
            return totalSize
        }

        return totalSize
    }
}
