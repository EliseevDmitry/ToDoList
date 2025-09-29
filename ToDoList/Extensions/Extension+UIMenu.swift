//
//  Extension+UIMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 25.09.2025.
//

import UIKit

extension UIMenu {
    /// Константы, используемые для формирования стандартного контекстного меню задач. /// Включают локализованные строки иконок и их `UIImage`-ресурсы. /// Иконки принудительно переводятся в `.alwaysTemplate` режим для корректного отображения /// в зависимости от системной темы (Light/Dark).
    enum Consts {
        static let editTitle = "Редактировать"
        static let shareTitle = "Завершить"
        static let deleteTitle = "Удалить"
        static let editImage = UIImage(resource: .edit)
            .withRenderingMode(.alwaysTemplate)
        static let shareImage = UIImage(resource: .export)
            .withRenderingMode(.alwaysTemplate)
        static let deleteImage = UIImage(resource: .trash)
            .withRenderingMode(.alwaysTemplate)
    }
    
    /// Фабричный метод для создания стандартизированного меню действий с задачей
    /// - Parameters:
    ///   - editTitle: Локализованное название действия редактирования
    ///   - shareTitle: Локализованное название действия публикации
    ///   - deleteTitle: Локализованное название действия удаления
    ///   - editImage: Кастомная иконка для действия редактирования (опционально)
    ///   - shareImage: Кастомная иконка для действия публикации (опционально)
    ///   - deleteImage: Кастомная иконка для действия удаления (опционально)
    ///   - onEdit: Closure, выполняемый при выборе действия редактирования
    ///   - onShare: Closure, выполняемый при выборе действия публикации
    ///   - onDelete: Closure, выполняемый при выборе действия удаления
    /// - Returns: Сконфигурированный экземпляр UIMenu с тремя основными действиями
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
