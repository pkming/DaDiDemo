//
//  DaDiRequest.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import Alamofire
import Moya
import RxSwift
import SwiftyJSON

public typealias DaDiRequestSuccess = (Any) -> Void
public typealias DaDiRequestError = (Error?, Any?) -> Void

struct DaDiRequestPlugin: PluginType {
    func willSend(_ request: RequestType, target _: TargetType) {
        print("请求url: \(String(describing: request.request?.url))")
        print("请求方式：\(String(describing: request.request?.httpMethod))")
        print("请求头部：\(String(describing: request.request?.allHTTPHeaderFields))")
    }
}

public struct DaDiRequest {
    static let networkActivityPlugin = NetworkActivityPlugin { type, _ in
        switch type {
        case .began:
            print("显示loading")
        case .ended:
            print("隐藏loading")
        }
    }

    static var httpHeader: HTTPHeaders = {
        [
            "content-type": "text/javascript; charset=UTF-8",
        ]
    }()

    /// 取消所有请求
    static func cancelAllRequest() {
        provider?.manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    public static var token: String = ""

    static var provider: MoyaProvider<DaDiAPI>?

    /// 公共get请求
    ///
    /// - Parameters:
    ///   - api:
    ///   - succesCallback:
    ///   - errorCallback:
    /// - Returns:
    static func KsGet(
        api: DaDiAPI,
        succesCallback: @escaping DaDiRequestSuccess,
        errorCallback: @escaping DaDiRequestError
    ) -> Cancellable {
        provider = MoyaProvider<DaDiAPI>(plugins: [DaDiRequestPlugin(), networkActivityPlugin])
        return provider!.request(api) { reset in
            switch reset {
            case var .success(urlRequest):
                do {
                    urlRequest = try urlRequest.filterSuccessfulStatusAndRedirectCodes()

                    let jsonMap = try urlRequest.mapJSON()
                    let resp = JSON(jsonMap)

                    succesCallback(resp)

                } catch {
                    errorCallback(error, nil)
                }
            case let .failure(error):
                errorCallback(error, nil)
                return
            }
        }
    }

    /// 获取top数据
    ///
    /// - Parameters:
    ///   - succesCallback:
    ///   - errorCallback:
    /// - Returns:
    static func getTopFreApplications(
        succesCallback: @escaping DaDiRequestSuccess,
        errorCallback: @escaping DaDiRequestError
    ) -> Cancellable {
        return DaDiRequest.KsGet(api: .topfreeapplications(header: httpHeader, params: [:]), succesCallback: succesCallback, errorCallback: errorCallback)
    }

    /// 获取详情
    static func geLookUp(
        params: [String: Any],
        succesCallback: @escaping DaDiRequestSuccess,
        errorCallback: @escaping DaDiRequestError
    ) -> Cancellable {
        return DaDiRequest.KsGet(api: .lookup(header: httpHeader, params: params), succesCallback: succesCallback, errorCallback: errorCallback)
    }

    /// 搜索
    static func search(
        params: [String: Any],
        succesCallback: @escaping DaDiRequestSuccess,
        errorCallback: @escaping DaDiRequestError
    ) -> Cancellable {
        return DaDiRequest.KsGet(api: .search(header: httpHeader, params: params), succesCallback: succesCallback, errorCallback: errorCallback)
    }
}
