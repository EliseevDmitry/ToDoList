//
//  Extension+UIMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 25.09.2025.
//

import UIKit

extension UIMenu {
    /// Common constants for task context menus.
    /// Includes localized titles and template-rendered icons for Light/Dark mode support.
    enum Consts {
        static let editTitle = "Edit"
        static let shareTitle = "Complete"
        static let deleteTitle = "Delete"
        static let editImage = UIImage(resource: .edit)
            .withRenderingMode(.alwaysTemplate)
        static let shareImage = UIImage(resource: .export)
            .withRenderingMode(.alwaysTemplate)
        static let deleteImage = UIImage(resource: .trash)
            .withRenderingMode(.alwaysTemplate)
    }
    
    /// Factory for standardized task action menu.
    /// - Parameters:
    ///   - editTitle: Edit action title.
    ///   - shareTitle: Share action title.
    ///   - deleteTitle: Delete action title.
    ///   - editImage: Edit action icon.
    ///   - shareImage: Share action icon.
    ///   - deleteImage: Delete action icon.
    ///   - onEdit: Edit action handler.
    ///   - onShare: Share action handler.
    ///   - onDelete: Delete action handler.
    /// - Returns: Configured UIMenu with standard task actions.
    static func makeToDoActionMenu(
        editTitle: String = Consts.editTitle,
        shareTitle: String = Consts.shareTitle,
        deleteTitle: String = Consts.deleteTitle,
        editImage: UIImage? = Consts.editImage,
        shareImage: UIImage? = Consts.shareImage,
        deleteImage: UIImage? = Consts.deleteImage,
        onEdit: @escaping () -> Void,
        onShare: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) -> UIMenu {
        let edit = UIAction(title: editTitle, image: editImage) { _ in onEdit() }
        let share = UIAction(title: shareTitle, image: shareImage) { _ in onShare() }
        let delete = UIAction(title: deleteTitle, image: deleteImage, attributes: .destructive) { _ in onDelete() }
        return UIMenu(
            title: "",
            children: [edit, share, delete]
        )
    }
}
