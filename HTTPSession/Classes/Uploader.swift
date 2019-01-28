//
//  Uploader.swift
//
//  Created by Jamal Alayq on 1/28/19.
//

import Foundation

public final class Uploader: NSObject, URLSessionDataDelegate {
    
    private var task: URLSessionUploadTask?,
    session: URLSession?,
    identifier: String,
    networkServiceType: URLRequest.NetworkServiceType
    
    var onCancel: Handler?,
    completion: DataHandler?,
    onError: ErrorHandler?,
    completed: DoubleHandler?
    
    
    internal init(_ requirements: HTTPSessionequirements) {
        self.identifier = requirements.backgroudIdentifier
        self.networkServiceType = requirements.networkServiceType
    }
    
    // MARK:- Functions
    
    func upload(_ data: Data?,
                orFrom file: URL?,
                to link: String,
                via method: UploadMethod = .post,
                with body: Data? = .none,
                and headers: Headers? = .none) throws {
        guard let url = URL(string: link) else { throw HTTPSessionErrors.invalidURL }
        let uploadConfig = URLSessionConfiguration.background(withIdentifier: identifier)
        uploadConfig.waitsForConnectivity = true
        uploadConfig.networkServiceType = networkServiceType
        session = URLSession(configuration: uploadConfig, delegate: self, delegateQueue: .none)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        guard data != nil && file != nil else { throw HTTPSessionErrors.uploadingFail }
        if let data = data {
            task = session?.uploadTask(with: request, from: data)
        } else if let file = file {
            task = session?.uploadTask(with: request, fromFile: file)
        } else {
            throw HTTPSessionErrors.uploadingFail
        }
        task?.resume()
    }
    
    func pause() {
        let progress = task?.progress
        if case progress?.isPausable = true && progress?.isPaused == false && progress?.isFinished == false && progress?.isCancelled == false {
            progress?.pause()
        }
    }
    
    func resume() {
        let progress = task?.progress
        if case progress?.isFinished = false && progress?.isPaused == true && progress?.isCancelled == false {
            progress?.resume()
        }
    }
    
    func cancel() {
        let progress = task?.progress
        if case progress?.isCancellable = true {
            progress?.cancel()
            task?.cancel()
            onCancel = progress?.cancellationHandler
            task = .none
        }
    }
    
    // MARK:- Delegete functions
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print(#function, session.configuration.identifier ?? "", "for background session did finished.")
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onError?(error)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        completed?(progress)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        completion?(data)
    }
    
}
