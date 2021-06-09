//
//  PicManager.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import Foundation

protocol PicManagerDelegate: AnyObject {
    func information(_ manager: PicManager, didFetch picInfo: [Picture])
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
                            if let eachData: [[String: Any]] = json as? [[String: Any]] {
                                // for loop
//                                print(eachData.count)
                                var cellpictures: [Picture] = []
                                
                                for i in Range(0...eachData.count-1) {
                                    if let title: String = eachData[i]["title"] as? String {
                                        if let url: String = eachData[i]["url"] as? String {
                                            if let hdurl: String = eachData[i]["hdurl"] as? String {
                                                if let date: String = eachData[i]["date"] as? String {
                                                    if let copyright: String = eachData[i]["copyright"] as? String {
                                                        if let description: String = eachData[i]["description"] as? String {
                                                            
                                                            let picture = Picture(url: url, title: title, hdurl: hdurl, date: date, copyright: copyright, description: description)
                                                            cellpictures.append(picture)
                                                            
                                                            
                                                        } else {
                                                            print("description error.")
                                                        }
                                                    } else {
                                                        print("copyright error.")
                                                    }
                                                } else {
                                                    print("date error.")
                                                }
                                            } else {
                                                print("hdurl error.")
                                            }
                                        } else {
                                            print("url error.")
                                        }
                                    } else {
                                        print("title error.")
                                    }
                                }
                                self.delegate?.information(self, didFetch: cellpictures)
                            } else {
                                print("eachData error.")
                            }
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
