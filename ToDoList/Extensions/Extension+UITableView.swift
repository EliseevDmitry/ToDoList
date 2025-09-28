//
//  Extension+TableView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

extension UITableView {
    enum Consts {
        static let previewSize = CGSize(
            width: ScreenApp.width - 40,
            height: 106
        )
        static let cornerRadius: CGFloat = 12
    }

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
//        let dummyView = UIView(
//            frame: CGRect(
//                origin: .zero,
//                size: Consts.previewSize
//            )
//        )
//        dummyView.backgroundColor = .clear
//        dummyView.layer.cornerRadius = Consts.cornerRadius
        let dummyView = UIView()
        return UITargetedPreview(view: dummyView, parameters: parameters, target: target)
    }
}
