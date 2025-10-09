//
//  ToDoContextMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Utility class to create a context menu for `TodoItem` in `UITableView`.
/// Encapsulates `UIContextMenuConfiguration` logic with predefined actions: edit, share, delete.
/// The `share` action is used for marking a task as complete. Icons match the design spec.
final class ToDoContextMenu {
    /// Available actions in the context menu.
    enum ToDoContextMenuAction {
        case edit, share, delete
    }
    
    /// Creates a context menu configuration for a given item.
    ///
    /// - Parameters:
    ///   - indexPath: Item index used as menu identifier.
    ///   - entity: `TodoItem` whose data can be shown in the preview.
    ///   - actions: Callback invoked with the selected menu action.
    ///
    /// - Returns: Configured `UIContextMenuConfiguration` for the table view.
    static func makeMenu(
        for indexPath: IndexPath,
        entity: (any IToDo)?,
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
