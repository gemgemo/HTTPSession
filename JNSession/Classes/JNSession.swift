//
//  JNSession.swift
//
//  Created by Jamal Alayq on 1/28/19.
//

import Foundation

public final class JNSession {
    
    private let session: URLSession, dependencies: JNSessionequirements
    private var task: URLSessionDataTask?,
    code: Int?,
    requestBodyValue = "",
    responseStringValue = ""
    
    public lazy var downloader = Downloader.init(dependencies.backgroudIdentifier)
    public lazy var uploader = Uploader.init(dependencies)
    
    public required init(with requirements: JNSessionequirements, _ session: URLSession = .shared) {
        self.session = session
        self.dependencies = requirements
        self.session.configuration.waitsForConnectivity = true
    }
    
    // MARK:- Private Functions
    
    private func send<D: Decodable>(this request: URLRequest,
                                    _ type: D.Type,
                                    _ handler: @escaping(Result<D>) -> Void) {
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.responseStringValue = "\(String(decoding: data ?? .init(), as: UTF8.self)) for url: \(request.url?.absoluteString ?? "empty url")"
            self.code = (response as? HTTPURLResponse)?.statusCode
            guard error == nil else {
                return handler(.fail(error))
            }
            let decoder = JSONDecoder.init()
            decoder.dateDecodingStrategy = self.dependencies.dateDecodingStrategy
            decoder.keyDecodingStrategy = self.dependencies.keyDecodingStrategy
            decoder.dataDecodingStrategy = self.dependencies.dataDecodingStrategy
            do {
                let decodedObject = try decoder.decode(type, from: data ?? .init())
                handler(.success(decodedObject))
            } catch {
                handler(.fail(error))
            }
        }
        task?.resume()
    }
    
    private func createRequest<E: Endpoint>(for endpoint: E,
                                            _ headers: Headers?) throws -> URLRequest {
        guard let url = URL.init(string: dependencies.base + endpoint.rawValue) else { throw JNSessionErrors.invalidURL }
        var request = URLRequest.init(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.timeoutInterval = self.dependencies.timeoutInterval
        // Need to handle cache policy, network service type
        return request
    }
    
    // MARK:- functions
    
    public func get<E, D: Decodable>(from endpoint: E,
                              _ type: D.Type,
                              with headers: Headers? = .none,
                              _ handler: @escaping(Result<D>) -> Void) where E: Endpoint {
        do {
            var request = try createRequest(for: endpoint, headers)
            request.httpMethod = Methods.get
            send(this: request, type, handler)
        } catch {
            handler(.fail(error))
        }
    }
    
    public func post<E: Endpoint, D>(_ data: Data?,
                              _ type: D.Type,
                              for endpoint: E,
                              with headers: Headers? = .none,
                              _ handler: @escaping(Result<D>) -> Void) where D: Decodable{
        do {
            var request = try createRequest(for: endpoint, headers)
            request.httpMethod = Methods.post
            request.httpBody = data
            self.requestBodyValue = "\(String.init(decoding: data ?? .init(), as: UTF8.self)) for url: \(request.url?.absoluteString ?? "empty url")"
            send(this: request, type, handler)
        } catch {
            handler(.fail(error))
        }
    }
    
    public func put<E, D: Decodable>(_ data: Data?,
                              in endpoint: E,
                              _ type: D.Type,
                              with headers: Headers? = .none,
                              _ handler: @escaping(Result<D>) -> Void) where E: Endpoint {
        do {
            var request = try createRequest(for: endpoint, headers)
            request.httpMethod = Methods.put
            request.httpBody = data
            self.requestBodyValue = "\(String.init(decoding: data ?? .init(), as: UTF8.self)) for url: \(request.url?.absoluteString ?? "empty url")"
            send(this: request, type, handler)
        } catch {
            handler(.fail(error))
        }
    }
    
    public func patch<E: Endpoint, D>(_ data: Data?,
                               this endpoint: E,
                               _ type: D.Type,
                               with headers: Headers? = .none,
                               _ handler: @escaping(Result<D>) -> Void) where D: Decodable{
        do {
            var request = try createRequest(for: endpoint, headers)
            request.httpMethod = Methods.patch
            request.httpBody = data
            self.requestBodyValue = "\(String.init(decoding: data ?? .init(), as: UTF8.self)) for url: \(request.url?.absoluteString ?? "empty url")"
            send(this: request, type, handler)
        } catch {
            handler(.fail(error))
        }
    }
    
    public func delete<E: Endpoint, D>(from endpoint: E,
                                _ type: D.Type,
                                with headers: Headers? = .none,
                                _ handler: @escaping(Result<D>) -> Void) where D: Decodable {
        do {
            var request = try createRequest(for: endpoint, headers)
            request.httpMethod = Methods.delete
            send(this: request, type, handler)
        } catch {
            handler(.fail(error))
        }
    }
    
    public func cancel() {
        task?.cancel()
        task = .none
    }
    
    // MARK:- Computed properties
    
    public var statusCode: Int? {
        return code
    }
    
    public var requestValue: String {
        return requestBodyValue
    }
    
    public var responseValue: String {
        return responseStringValue
    }
    
}
