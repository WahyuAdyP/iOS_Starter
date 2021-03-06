//
//  DownloadRequestor.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 11/3/17.
//  Copyright © 2017 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/// File document that will search or use to save downloaded file
fileprivate let savedDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

class DirectoryFileHelper {
    /// Durectory of files
    private static var directory: URL {
        let directory = savedDirectory as String
        let dirUrl    = URL(fileURLWithPath: directory)
        return dirUrl
    }
    
    /// Get file from name of file
    ///
    /// - Parameter name: Name of file
    /// - Returns: File data and file url
    static func file(name: String) -> (data: Data?, url: String) {
        let fileUrl  = directory.appendingPathComponent(name)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                let file = try Data(contentsOf: fileUrl)
                return (file, fileUrl.absoluteString)
            } catch {
                return (nil, "File not found in directory")
            }
        } else {
            return (nil, "File not found in directory")
        }
    }
    
    /// Get file in directory
    ///
    /// - Parameter url: url of file
    /// - Returns: File data and full file path
    static func file(from url: URL) -> (data: Data?, url: String) {
        let fileName = url.lastPathComponent.removingPercentEncoding?.replacingOccurrences(of: " ", with: "_") ?? ""
        
        return file(name: fileName)
    }
}

class DownloadFileHelper {
    private static var queue: [(url: URL, data: Data?)] = []
    
    /// Data for resuming paused download data
    private var resumeData: Data?
    /// Result of download data
    private var downloadData: Data?
    /// Url to download with regenerate to valid download url
    private var downloadUrl: URL? {
        if let url = _dlUrl, UIApplication.shared.canOpenURL(url) {
            return url
        }
        let urlPercentEncoding = _dlUrl?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: urlPercentEncoding)
    }
    /// Original url to download
    private var _dlUrl: URL?
    
    /// Initialize download url
    ///
    /// - Parameter url: File url will be download
    init(url: URL?) {
        _dlUrl = url
    }
    
    /// Initialize url from string type data
    ///
    /// - Parameter string: File url will be download
    init(url string: String) {
        _dlUrl = URL(string: string)
    }
    
    /// Starting download file
    ///
    /// - Parameters:
    ///   - progress: Download progress closure
    ///   - completion: Complete download progress closure
    func fetch(progress: ((Progress) -> Void)? = nil, completion: @escaping ((Data?, String) -> Void)) {
        guard let downloadUrl = downloadUrl else {
            return
        }
        
        let localFile = DirectoryFileHelper.file(from: downloadUrl)
        guard localFile.data == nil else {
            completion(localFile.data, localFile.url)
            return
        }
        guard downloadData == nil else {
            completion(localFile.data, localFile.url)
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = URL(fileURLWithPath: savedDirectory)
            let fileName = downloadUrl.lastPathComponent
                .removingPercentEncoding?.replacingOccurrences(of: " ", with: "_") ?? ""
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let request: DownloadRequest
        if let data = DownloadFileHelper.queue.first(where: { $0.url == downloadUrl }) {
            self.resumeData = data.data
        } else {
            DownloadFileHelper.queue.append((downloadUrl, self.resumeData))
        }
        if let resumeData = resumeData {
            request = Alamofire.download(resumingWith: resumeData, to: destination).downloadProgress { (progressDownload) in
                progress?(progressDownload)
            }
        } else {
            request = Alamofire.download(downloadUrl, to: destination).downloadProgress { (progressDownload) in
                progress?(progressDownload)
            }
        }
        
        request.responseData { response in
            switch response.result {
            case .success(let data):
                self.downloadData = data
                
                if let index = DownloadFileHelper.queue.firstIndex(where: { $0.url == downloadUrl }) {
                    DownloadFileHelper.queue.remove(at: index)
                }
                
                let localFile = DirectoryFileHelper.file(from: downloadUrl)
                completion(localFile.data, localFile.url)
            case .failure:
                self.resumeData = response.resumeData
                
                if let index = DownloadFileHelper.queue.firstIndex(where: { $0.url == downloadUrl }) {
                    DownloadFileHelper.queue[index].data = self.resumeData
                }
            }
        }
    }
}
