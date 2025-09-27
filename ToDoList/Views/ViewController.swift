//
//  ViewController.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 22.09.2025.
//

import UIKit

final class ViewController: UIViewController {
     
    private lazy var tableView = TodoTableView()
    private lazy var footer: FooterUIView = {
        $0.updateCount(presenter?.numberOfTodos ?? 0)
        return $0
    }(FooterUIView())
    private var presenter: ITodoListPresenter!
    private var todos: [String] = ["Todo 1", "Todo 2", "Todo 3"]
    private var currentPreviewVC: UIViewController?
    
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

extension ViewController: ITodoListView {
    func reloadData() {
        tableView.reloadData()
        footer.updateCount(presenter.numberOfTodos)
    }
    
    //отображение проброшенных ошибок
    func showError(_ message: String) {
        ToDoAlertError.present(on: self, message: message)
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




extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                // Создаём новый VC для предпросмотра
                let previewVC = UIViewController()
                previewVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                previewVC.view.layer.cornerRadius = 12
                previewVC.view.layer.masksToBounds = true
                previewVC.preferredContentSize = CGSize(width: 300, height: 100)

                // Добавляем лейбл с текстом todo
                let label = UILabel()
                label.text = "Preview for row \(indexPath.row)"
                label.textColor = .white
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                previewVC.view.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: previewVC.view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: previewVC.view.centerYAnchor)
                ])

                return previewVC
            },
            actionProvider: { _ in
                UIMenu.makeToDoActionMenu {
                    print("Edit tapped at row \(indexPath.row)")
                } onShare: {
                    print("Share tapped at row \(indexPath.row)")
                } onDelete: {
                    print("Delete tapped at row \(indexPath.row)")
                }
            }
        )
    }

    func tableView(_ tableView: UITableView,
                   previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) else { return nil }

        // размеры preview
        let previewSize = CGSize(width: 300, height: 100)
        
        // центр экрана
        let screenCenter = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        // переводим координаты в систему координат tableView
        let targetPoint = tableView.convert(screenCenter, from: tableView.superview)
        
        let target = UIPreviewTarget(container: tableView, center: targetPoint)
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: previewSize), cornerRadius: 12)
        parameters.shadowPath = nil

        // создаём dummy view для предпросмотра
        let dummyView = UIView(frame: CGRect(origin: .zero, size: previewSize))
        dummyView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        dummyView.layer.cornerRadius = 12

        return UITargetedPreview(view: dummyView, parameters: parameters, target: target)
    }
}


extension ViewController {
    private func setupViews() {
        [tableView, footer].forEach{
            view.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
                    
                    footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    footer.heightAnchor.constraint(equalToConstant: 49)
                ])
    }
}
