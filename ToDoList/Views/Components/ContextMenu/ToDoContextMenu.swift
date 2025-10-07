//
//  ToDoContextMenu.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Утилитарный класс для создания контекстного меню задач (`TodoItem`) в `UITableView`.
/// Инкапсулирует логику построения `UIContextMenuConfiguration` с предопределёнными действиями: редактирование, шаринг и удаление.
/// `share` переопределён для действия "Завершить" в логике завершения задачи `ToDo`.
/// Иконка оставлена без изменений, как указано в дизайн-макете, для сохранения визуальной согласованности.
final class ToDoContextMenu {
    /// Возможные действия, доступные в контекстном меню задачи.
    enum ToDoContextMenuAction {
        case edit, share, delete
    }
    
    /// Создаёт конфигурацию контекстного меню для указанного элемента.
    ///
    /// - Parameters:
    ///   - indexPath: индекс элемента в списке, используется как идентификатор меню.
    ///   - entity: объект `TodoItem`, данные которого можно показать в превью меню.
    ///   - actions: замыкание обратного вызова с выбранным действием меню.
    ///
    /// - Returns: `UIContextMenuConfiguration`, готовая к применению в `UITableView`.
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
