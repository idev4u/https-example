//
//  HttpsUrlSession.swift
//  https-example
//
//  Created by Norman Sutorius on 20.02.18.
//

import Foundation
import Dispatch

class HttpsURLSession: URLSession, URLSessionDelegate {
    
    func httpGet() {
        let url = URL(string: "https://127.0.0.1:10443/")
//        let url = URL(string: "https://gist.github.com/6174/9ff5063a43f0edd82c8186e417aae1dc/")
        
//        let url = URL(string: "https://localhost:10443/")
//        var responseData = Data()
        let request = URLRequest.init(url: url!)
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue.main
//        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:queue)
        let session = URLSession.shared
        let runQueue = DispatchQueue.global()
        let invokeGroup = DispatchGroup()
        invokeGroup.enter()
        runQueue.async {
            print("run in sync")
            self.execTask(session: session, request: request, group: invokeGroup)
        }
        switch invokeGroup.wait(timeout: DispatchTime.distantFuture) {
        case DispatchTimeoutResult.success:
            break
        case DispatchTimeoutResult.timedOut:
            break
        }
        print("done")
//        print(responseData.debugDescription)
    }
    
    internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("host: \(challenge.protectionSpace.host)")
        print("trust: \(String(describing: challenge.protectionSpace.serverTrust))")
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func execTask(session: URLSession, request: URLRequest, group: DispatchGroup){
        let task = session.dataTask(with: request){(data, response, error) -> Void in
            // code
            print("execute data task")
            defer {
                group.leave()
                print("run in defer")
            }
            
            print("response:\(response.debugDescription)")
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if let responseData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                print(response.debugDescription)
                print(responseData.debugDescription)
                
            }
            
            
        }
        task.resume()
    }
}
