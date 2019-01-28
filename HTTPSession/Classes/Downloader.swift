//
//  Downloader.swift
//
//  Created by Jamal Alayq on 1/28/19.
//

import Foundation

public final class Downloader: NSObject, URLSessionDownloadDelegate {
    
    private var task: URLSessionDownloadTask?,
    session: URLSession?,
    identifier: String
    
    var onCancel: Handler?,
    completion: URLHandler?,
    onError: ErrorHandler?,
    completed: DoubleHandler?
    
    
    internal init(_ identifier: String) {
        self.identifier = identifier
    }
    
    // MARK:- Functions
    
    /// Download files
    ///
    /// - Parameters:
    ///   - link: string url of file need to download it
    ///   - headers: custom headers
    func download(from link: String,
                  with headers: Headers? = .none) throws {
        guard let url = URL.init(string: link) else { throw HTTPSessionErrors.invalidURL }
        let downloadConfig = URLSessionConfiguration.background(withIdentifier: identifier)
        downloadConfig.networkServiceType = .background
        downloadConfig.waitsForConnectivity = true
        session = URLSession.init(configuration: downloadConfig, delegate: self, delegateQueue: .none)
        var request = URLRequest.init(url: url)
        request.httpMethod = Methods.get
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        task = session?.downloadTask(with: request)
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
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completion?(location)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        let pausedCompleted = fileOffset / expectedTotalBytes
        print(#function, pausedCompleted)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        completed?(downloadTask.progress.fractionCompleted)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onError?(error)
    }
}
