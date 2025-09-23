//
//  TodoTableView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 23.09.2025.
//

import UIKit

final class TodoTableView: UITableView {
    
    override init(
        frame: CGRect = .zero,
        style: UITableView.Style = .plain
    ) {
        super.init(frame: frame, style: style)
        customInitTanleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TodoTableView {
    private func customInitTanleView() {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        registerCell(TodoTableViewCell.self)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        rowHeight = UITableView.automaticDimension
        
        separatorStyle = .singleLine      // линии между ячейками
                separatorColor = .lightGray       // цвет линии
                separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) 
    }
    
    
}
