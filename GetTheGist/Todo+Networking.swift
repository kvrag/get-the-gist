//
//  Todo+Networking.swift
//  GetTheGist
//
//  Created by kristina on 8/28/18.
//  Copyright © 2018 kristina. All rights reserved.
//

import Foundation
import Alamofire

extension Todo {
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let userId = json["userId"] as? Int,
            let completed = json["completed"] as? Bool
            else {
                return nil
        }
        
        let idValue = json["id"] as? Int
        
        self.init(title: title, id: idValue, userId: userId, completedStatus: completed)
    }
    
    enum BackendError: Error {
        case parsing(reason: String)
    }
    
    func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["title"] = title
        if let id = id {
            json["id"] = id
        }
        json["userId"] = userId
        json["completed"] = completed
        return json
    }
    
    // POST/create
    func save(completionHandler: @escaping (Result<Int>) -> Void) {
        let fields = self.toJSON()
        Alamofire.request(TodoRouter.create(fields))
            .responseJSON { response in
                
                // handle error in getting data
                guard response.result.error == nil else {
                    print(response.result.error!)
                    completionHandler(.failure(response.result.error!))
                    return
                }
                
                // make sure we have JSON dictionary
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo as JSON from API")
                    completionHandler(.failure(BackendError.parsing(reason:
                        "Did not get JSON dictionary in response")))
                    return
                }
                
                // turn JSON into todo object
                guard let idNumber = json["id"] as? Int else {
                    completionHandler(.failure(BackendError.parsing(reason:
                        "Could not get ID number from JSON")))
                    return
                }
                
                completionHandler(.success(idNumber))
        }
    }
    
    static func todoById(id: Int, completionHandler: @escaping (Result<Todo>) -> Void) {
        Alamofire.request(TodoRouter.get(id))
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    private static func todoFromResponse(response: DataResponse<Any>) -> Result<Todo> {
        // check for errors from responseJSON
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        // make sure we got a JSON dictionary
        guard let json = response.result.value as? [String: Any] else {
            print("didn't get todo object as JSON")
            return .failure(BackendError.parsing(reason:
                "Did not get JSON dictionary in response"))
        }
        
        // turn JSON into a Todo object
        guard let todo = Todo(json: json) else {
            return .failure(BackendError.parsing(reason:
                "Could not create Todo from JSON"))
        }
        return .success(todo)
    }
}
