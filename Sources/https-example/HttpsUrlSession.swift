//
//  HttpsUrlSession.swift
//  https-example
//
//  Created by Norman Sutorius on 20.02.18.
//

import Foundation

class HttpsURLSession: URLSession, URLSessionDelegate {
    
    func httpGet() {
        let url = URL(string: "https://127.0.0.1:10443/")
        var responseData = Data()
        let request = URLRequest.init(url: url!)
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue.main
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:queue)
//        let session = URLSession.shared
        let task = session.dataTask(with: request){(data, response, error) -> Void in
            // code
            // 5
            print("response:\(response.debugDescription)")
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if let _ = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                print(response.debugDescription)
                
            }
            
        }
        task.resume()
        print(responseData.debugDescription)
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

}
