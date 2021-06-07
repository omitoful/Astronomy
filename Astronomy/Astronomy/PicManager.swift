//
//  PicManager.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import Foundation

protocol PicManagerDelegate: AnyObject {
    func information(_ manager: PicManager, didFetch picInfo: [Picture])
    
    func information(_ manager: PicManager, didFetch detailInfo: [DetailInfo])
}


class PicManager {
    static let shared = PicManager.init()
    weak var delegate: PicManagerDelegate? = nil
    
    func getPic() -> Void {
        let component = URLComponents(string: "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json")
        if let endPoint: URL = component?.url {
            var picReq = URLRequest(url: endPoint)
            picReq.httpMethod = "GET"
            
            let picSession = URLSession.shared
            
            let task = picSession.dataTask(
                with: picReq,
                completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                    if let data: Data = data {
                        do {
                            let json: Any = try JSONSerialization.jsonObject(with: data)
                            print(json)
                        
                        
                        } catch (let error) {
                            print(error)
                        }
                    } else {
                        print("task error")
                    }
                }
            )
            task.resume()
        } else {
            print("endpoint Error")
        }
    }
}
