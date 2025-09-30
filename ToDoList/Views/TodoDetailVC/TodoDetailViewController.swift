//
//  TodoDetailViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 30.09.2025.
//

import UIKit

final class TodoDetailViewController: UIViewController {
    
    var entity: any IToDo
    
    init(entity: any IToDo) {
        self.entity = entity
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .red
    }
    
}

