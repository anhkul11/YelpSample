//
//  Requestable.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import Alamofire
import RxSwift
import Foundation
enum NetworkError: Error {
    case requestInvalid
    case generic(Error)
    case noResponse
}

public protocol Requestable: URLRequestConvertible {
    associatedtype Output
    
    var basePath: String { get }
    
    var endpoint: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var params: Parameters { get }
    
    var defaultHeaders: HTTPHeaders { get }
    
    var additionalHeaders: HTTPHeaders { get }
    
    var parameterEncoding: ParameterEncoding { get }
    
    var contentType: [String] { get }
    
    var statusCode: Range<Int> { get }
    
    func execute() -> Observable<Output>
    
    func decode(data: Any) -> Output
}

public extension Requestable {
    var basePath: String {
        return Constanst.baseURL
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        return [:]
    }
    
    var defaultHeaders: HTTPHeaders {
        return [HTTPHeader.accept(contentType.joined(separator: ",")),
                HTTPHeader.authorization(bearerToken: Constanst.privateKey)]
    }
    
    var additionalHeaders: HTTPHeaders {
        return [:]
    }

    var urlPath: String {
        return basePath + endpoint
    }
    
    var customData: Data {
        return Data()
    }
    
    var url: URL {
        return URL(string: urlPath)!
    }
    
    var parameterEncoding: ParameterEncoding {
        switch httpMethod {
        case .post, .put, .delete:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var statusCode: Range<Int> {
        return 200..<300
    }
    
    var contentType: [String] {
        return ["application/json"]
    }
    
    @discardableResult
    func execute() -> Observable<Output> {
        return asObservable()
    }
    
    fileprivate func buildURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest = try parameterEncoding.encode(urlRequest, with: params)
        var headers = defaultHeaders
        for header in additionalHeaders {
            headers.add(header)
        }
        urlRequest.headers = headers
        
        return urlRequest
    }
    
    func connectWithRequest(
        _ urlRequest: URLRequest,
        complete: @escaping (AFDataResponse<Any>) -> Void
    ) -> DataRequest? {
        
        return httpRequest(urlRequest: urlRequest,
                           complete: complete)

    }
    
    private func httpRequest(
        urlRequest: URLRequest,
        complete: @escaping (AFDataResponse<Any>) -> Void
        ) -> DataRequest {
            let request = AF.request(urlRequest)

        debugPrint(request)

        requestJSON(request: request, complete: complete)
    
        return request
    }
    
    private func requestJSON(
        request: DataRequest,
        complete: @escaping (AFDataResponse<Any>) -> Void
    ) {
        request.validate(statusCode: statusCode)
        request.validate(contentType: contentType)
    
        request.responseJSON(completionHandler: { response in
            complete(response)
        })
    }
    
    private func asObservable() -> Observable<Output> {
        return Observable.create { observer in
            guard let urlRequest = try? self.asURLRequest() else {
                observer.onError(NetworkError.requestInvalid)
                return Disposables.create()
            }
            
            let connection = self.connectWithRequest(urlRequest, complete: { response in
                switch response.result {
                case let .success(data):
                        observer.onNext(self.decode(data: data))
                        observer.onCompleted()
                        return
                case let .failure(error):
                        observer.onError(NetworkError.generic(error))
                }
            })
            
            return Disposables.create {
                connection?.cancel()
            }
        }
    }
}

// MARK: - Conform URLConvertible from Alamofire
public extension Requestable {
    
    func asURLRequest() throws -> URLRequest {
        return try buildURLRequest()
    }
    
}
