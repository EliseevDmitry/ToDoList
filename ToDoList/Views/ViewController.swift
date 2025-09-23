//
//  ViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

final class ViewController: UIViewController {
     
    private lazy var tableView = TodoTableView()
    private var presenter: TodoListPresenterProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTableView()
        
        
        //viper
        let interactor = TodoListInteractor()
                presenter = TodoListPresenter(interactor: interactor, view: self)
                presenter.loadTodos()
        }
        
}

extension ViewController: TodoListViewProtocol {
    //разобраться
    func reloadData() {
        tableView.reloadData()
    }
}

extension ViewController {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            presenter.numberOfTodos
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let todo = presenter.todo(at: indexPath.row) else {
                        return UITableViewCell()
                    }
            let cell = tableView.dequeueCell(indexPath) as TodoTableViewCell
            cell.update(todo)
            return cell
        }
    }
extension ViewController: UITableViewDelegate { }


extension ViewController {
    private func setupViews() {
        [tableView].forEach{
            view.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
    }
}
