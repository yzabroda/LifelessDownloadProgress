//
//  SimpleDownloadManager.swift
//  LifelessDownloadProgress
//
//  Created by Yuriy Zabroda on 2/26/19.
//  Copyright © 2019 Yuriy Zabroda. All rights reserved.
//

import UIKit



private let downloadLink = "https://devstreaming-cdn.apple.com/videos/wwdc/2018/714px070n75l8ri/714/714_sd_optimizing_your_app_for_todays_internet.mp4?dl=1"



class SimpleDownloadManager: NSObject {

    static let shared = SimpleDownloadManager()


    func reqularDownload() -> Progress {
        let url = URL(string: downloadLink)!

        let downloadTask = URLSession.shared.downloadTask(with: url) { location, response, error in
            if let path = location?.path {
                print("\(path)")
            }
        }

        downloadTask.resume()

        return downloadTask.progress
    }


    func convertedDownload(_ progressObtainingHandler: @escaping (Progress) -> Void) {
        self.progressObtainingHandler = progressObtainingHandler
        let url = URL(string: downloadLink)!
        theURLSession.dataTask(with: url).resume()
    }


    var downloadDelegateProgress: ((Int64) -> Void)?
    var downloadCompleteHandler: (() -> Void)?


    private override init() {
        super.init()
    }


    private lazy var theURLSession: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        return session
    }()


    private var progressObtainingHandler: ((Progress) -> Void)?
}



extension SimpleDownloadManager: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.becomeDownload)
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        DispatchQueue.main.async { [weak self] in
            self?.progressObtainingHandler?(downloadTask.progress)
        }
    }
}



extension SimpleDownloadManager: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.downloadCompleteHandler?()
        }
    }


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async { [weak self] in
            self?.downloadDelegateProgress?(totalBytesWritten)
        }
    }
}
