//
//  Extension+UIMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 25.09.2025.
//

import UIKit

extension UIMenu {
    enum Consts {
        static let editTitle = "Редактировать"
        static let shareTitle = "Поделиться"
        static let deleteTitle = "Удалить"
        static let editImage = UIImage(resource: .edit)
        static let shareImage = UIImage(resource: .export)
        static let deleteImage = UIImage(resource: .trash)
    }
    
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
