//
//  ViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

class ViewController: UIViewController {
     
    var todo: [TodoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let networkService: () = NetworkServices().fetchEntityData(url: Constants.todosURL, type: TodosResponse.self) { result in
            switch result {
            case .success(let data):
                self.todo = data.todos
                print(self.todo)
            case .failure(let failure):
                print("Ошибка запроса")
            }
        }
        
    }


}

