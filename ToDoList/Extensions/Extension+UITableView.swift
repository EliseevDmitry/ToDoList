//
//  Extension+TableView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

/// Расширение для удобного создания кастомного превью контекстного меню таблицы.
/// Позволяет задать размер, скругление и прозрачный фон превью для анимации.
extension UITableView {
    /// Константы для кастомного превью контекстного меню таблицы.
    /// Включают размер превью и радиус скругления углов.
    enum Consts {
        static let previewSize = CGSize(
            width: ScreenApp.width - 40,
            height: 106
        )
        static let cornerRadius: CGFloat = 12
    }
    
    /// Создает `UITargetedPreview` для контекстного меню на основе конфигурации.
    /// - Parameter configuration: Конфигурация контекстного меню с `identifier` как `IndexPath`
    /// - Returns: Сконфигурированное превью с прозрачным фоном и заданными параметрами
    func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let _ = self.cellForRow(at: indexPath)
        else { return nil }
        let screenCenter = CGPoint(
            x: ScreenApp.width/2,
            y: ScreenApp.height/2
        )
        let targetPoint = self.convert(
            screenCenter,
            from: self.superview
        )
        let target = UIPreviewTarget(
            container: self,
            center: targetPoint
        )
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(
            roundedRect: CGRect(
                origin: .zero,
                size: Consts.previewSize
            ),
            cornerRadius: Consts.cornerRadius
        )
        parameters.shadowPath = nil
        let dummyView = UIView()
        return UITargetedPreview(view: dummyView, parameters: parameters, target: target)
    }
}
