//
//  DataManager.swift
//  DiscoverMarvel
//
//  Created by Andrew Masters on 9/25/20.
//

import Foundation
import CryptoKit
import SwiftyJSON

func getPublicKey() -> String {
    
    if let path = Bundle.main.path(forResource: "pubKey", ofType: "txt"){
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
        }
    }
    return ""
}

func getPrivateKey() -> String {
    
    if let path = Bundle.main.path(forResource: "privKey", ofType: "txt") {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
        }
    }
    return ""
}

private let publicKey = getPublicKey()
private let privateKey = getPrivateKey()
let timeStamp = NSDate().timeIntervalSince1970.description
let toBeHash = timeStamp+privateKey+publicKey
let hash = toBeHash.MD5

let limit = 20
let baseURL = "http://gateway.marvel.com"
let key = "ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"



func downloadAllCharacters(filter: String, offset: Int, completion: @escaping (JSON) -> ()) {

    var urlString = ""
    
    if filter == "" {
        urlString = "\(baseURL)/v1/public/characters?orderBy=name&limit=\(limit)&offset=\(offset)&\(key)"
    } else {
        let cleanFilter = filter.replacingOccurrences(of: " ", with: "%20")
        urlString = "\(baseURL)/v1/public/characters?nameStartsWith=\(cleanFilter)&orderBy=name&limit=\(limit)&offset=\(offset)&\(key)"
    }
    
    let session = URLSession.shared
    print(urlString)
    let url = URL(string: urlString)!
    
    let dataTask = session.dataTask(with: url) { (data, response, error) in
        if error == nil {
            print("Download Successful - Response: \(response!)")
            
            do {
                let json = try JSON(data: data!)
                completion(json)
            } catch {
                print("There was an error when converting the data to json")
            }

        } else {
            print("Response \(response!)")
            print("Error \(error!)")
            completion(JSON())
        }
    }
    dataTask.resume()
        
}

func downloadAllCreators(filter: String, offset: Int, completion: @escaping (JSON) -> ()) {
    
    var urlString = ""
    
    if filter == "" {
        urlString = "\(baseURL)/v1/public/creators?orderBy=lastName&limit=\(limit)&offset=\(offset)&\(key)"
    } else {
        let cleanFilter = filter.replacingOccurrences(of: " ", with: "%20")
        urlString = "\(baseURL)/v1/public/creators?nameStartsWith=\(cleanFilter)&orderBy=lastName&limit=\(limit)&offset=\(offset)&\(key)"
    }
    
    let session = URLSession.shared
    print(urlString)
    let url = URL(string: urlString)!
    
    let dataTask = session.dataTask(with: url) { (data, response, error) in
        if error == nil {
            print("Download Successful - Response: \(response!)")
            
            do {
                let json = try JSON(data: data!)
                completion(json)
            } catch {
                print("There was an error when converting the data to json")
            }

        } else {
            print("Response \(response!)")
            print("Error \(error!)")
            completion(JSON())
        }
    }
    dataTask.resume()
    
}

func downloadComicsofCharacter(person: Bool, personID: Int, filter: String, offset: Int, completion: @escaping (JSON) -> ()) {
    
    var urlString = ""
    var personCategory = "creators"
    if person {
        personCategory = "characters"
    }
    
    if filter == "" {
        urlString = "\(baseURL)/v1/public/\(personCategory)/\(personID)/comics?orderBy=title%2CissueNumber&limit=\(10)&offset=\(offset)&\(key)"
    } else {
        let cleanFilter = filter.replacingOccurrences(of: " ", with: "%20")
        urlString = "\(baseURL)/v1/public/\(personCategory)/\(personID)/comics?titleStartsWith=\(cleanFilter)&orderBy=title%2CissueNumber&limit=\(limit)&offset=\(offset)&\(key)"
    }
    
    let session = URLSession.shared
    print(urlString)
    let url = URL(string: urlString)!
    
    let dataTask = session.dataTask(with: url) { (data, response, error) in
        if error == nil {
            print("Download Successful - Response: \(response!)")
            
            do {
                let json = try JSON(data: data!)
                completion(json)
            } catch {
                print("There was an error when converting the data to json")
            }

        } else {
            print("Response \(response!)")
            print("Error \(error)")
            completion(JSON())
        }
    }
    dataTask.resume()
}


extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
