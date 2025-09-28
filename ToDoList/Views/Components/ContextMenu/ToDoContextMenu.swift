//
//  ToDoContextMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

final class ToDoContextMenu {
    
    enum ToDoContextMenuAction {
        case edit, share, delete
    }
    
    static func makeMenu(
        for indexPath: IndexPath,
        entity: TodoItem?,
        actions: @escaping (ToDoContextMenuAction) -> Void
    ) -> UIContextMenuConfiguration {
        UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                PreviewProviderViewController(entity: entity)
            },
            actionProvider: { _ in
                UIMenu.makeToDoActionMenu {
                    actions(.edit)
                } onShare: {
                    actions(.share)
                } onDelete: {
                    actions(.delete)
                }
            }
        )
    }
}
