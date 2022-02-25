//
//  NetworkService.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import Alamofire

protocol Endpoint {
    
    var baseUrl: String { get }
    var path: String { get }
    var fullUrl: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var body: Parameters { get }
    var headers: HTTPHeaders { get }
}

extension Endpoint {
    
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    var fullUrl: String {
        return baseUrl + path
    }
    
    var body: Parameters {
        return Parameters()
    }
}

typealias ResponseClosure = (DataResponse<Any>?) -> Void
typealias ResponseClosureString = (DataResponse<Data>?) -> Void
typealias ResponseClosureSearch = (DataResponse<Any>?, String) -> Void

// To retain the session manager
let manager: SessionManager = createSessionManager()

func createSessionManager() -> SessionManager {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    
    return SessionManager(configuration: configuration)
}

struct NetworkService {
    
    init() {}
    static let shared = NetworkService()
}

extension NetworkService {
    func request(_ endpoint: Endpoint, completion: @escaping ResponseClosure) -> Request {
        let startTime = Date().timeIntervalSince1970
        let request = manager.request(
            endpoint.fullUrl,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
            ).validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    debugPrint(response.result.description)
                } else {
                    debugPrint(response.result.error ?? "Error")
                }
                // Completion handler
                completion(response)
        }
        return request
    }
    
    func request_ResponseData(_ endpoint: Endpoint, completion: @escaping ResponseClosureString) -> Request {
        let startTime = Date().timeIntervalSince1970
        let request = manager.request(
            endpoint.fullUrl,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
            ).validate()
            .responseData(completionHandler: { (response) in
                completion(response)
            })
        return request
    }
    
    func request_Search(_ endpoint: Endpoint, _ keySearch: String, completion: @escaping ResponseClosureSearch) -> Request {
        let startTime = Date().timeIntervalSince1970
        let request = manager.request(
            endpoint.fullUrl,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
            ).validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    debugPrint(response.result.description)
                } else {
                    debugPrint(response.result.error ?? "Error")
                }
                // Completion handler
                completion(response, keySearch)
        }
        return request
    }
}
