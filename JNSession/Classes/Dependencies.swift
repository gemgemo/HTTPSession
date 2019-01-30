//
//  Dependencies.swift
//
//  Created by Jamal Alayq on 1/28/19.
//

import Foundation

public typealias Headers = [String: String]
public typealias Handler = () -> Void
public typealias ErrorHandler = (Error?) -> Void
public typealias DoubleHandler = (Double) -> Void
public typealias URLHandler = (URL) -> Void
public typealias DataHandler = (Data) -> Void
public protocol Endpoint: RawRepresentable where Self.RawValue == String { }

public enum Result<T> {
    case fail(Error?), success(T?)
}

public enum JNSessionErrors: Error {
    case invalidURL, uploadingFail
}

public enum UploadMethod: String {
    case put = "PUT", post = "POST"
}

public final class JNSessionequirements {
    
    internal var base: String
    public var timeoutInterval = TimeInterval(60.0),
    backgroudIdentifier = "com.jemo.id.background",
    keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.useDefaultKeys,
    dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.deferredToDate,
    dataDecodingStrategy = JSONDecoder.DataDecodingStrategy.base64,
    networkServiceType = URLRequest.NetworkServiceType.default
    
    public required init(baseLink: String) {
        self.base = baseLink
    }
    
}

internal struct Methods {
    static let get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE"
}
