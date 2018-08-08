//
//  ViewController.swift
//  GetTheGist
//
//  Created by kristina on 8/8/18.
//  Copyright © 2018 kristina. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(todoEndpoint, method: .get)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                // get and print the title of the todo
                guard let todoTitle = json["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
            }
            .responseString { response in
                if let error = response.result.error {
                    print(error)
                }
                if let value = response.result.value {
                    print(value)
                }
            }
        
        let todosEndpoint = "https://jsonplaceholder.typicode.com/todos"
        let newTodo: [String: Any] = ["title": "My First Todo", "completed": 0, "userId": 1]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got JSON since that's what we're expecting
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                // see if the todo was successfully created / has an ID
                guard let todoID = json["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
        }
        
        let firstTodoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(firstTodoEndpoint, method: .delete)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling DELETE on /todos/1")
                    print(response.result.error!)
                    return
                }
                print("DELETE ok")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

