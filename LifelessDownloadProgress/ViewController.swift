//
//  ViewController.swift
//  LifelessDownloadProgress
//
//  Created by Yuriy Zabroda on 2/26/19.
//  Copyright © 2019 Yuriy Zabroda. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func performRegularDownload(_ sender: UIButton) {
        regularProgressView.observedProgress = SimpleDownloadManager.shared.reqularDownload()
        cancelRegularDownloadButton.isEnabled = true
    }


    @IBAction func cancelRegularDownload(_ sender: UIButton) {
        regularProgressView.observedProgress?.cancel()
        regularProgressView.progress = 0.0
        cancelRegularDownloadButton.isEnabled = false
    }


    @IBAction func performConvertedDownload(_ sender: UIButton) {
        SimpleDownloadManager.shared.downloadDelegateProgress = { [weak self] totalBytesWritten in
            self?.totalBytesWrittenLabel.text = "totalBytesWritten: \(totalBytesWritten)"
        }

        SimpleDownloadManager.shared.downloadCompleteHandler = { [weak self] in
            let alertController = UIAlertController(title: "Download Complete", message: "Download Complete", preferredStyle: .alert)
            self?.present(alertController, animated: true, completion: nil)
        }

        SimpleDownloadManager.shared.convertedDownload { [weak self] progress in
            self?.convertedProgressView.observedProgress = progress
        }
    }


    @IBOutlet var regularProgressView: UIProgressView!
    @IBOutlet var cancelRegularDownloadButton: UIButton!
    @IBOutlet var convertedProgressView: UIProgressView!
    @IBOutlet var totalBytesWrittenLabel: UILabel!
}
