//
//  Extension+UIView.swift
//  ToDoList
//
//  Created by Dmitriy Eliseev on 28.09.2025.
//

import UIKit

extension UIView {
    /// Layout constants for standard header views.
    enum Consts {
        static let edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let heightSubview: CGFloat = 36
    }
    
    /// Builds a container view with a subview and insets — useful for table headers.
    /// - Parameters:
    ///   - subview: View to embed inside the container.
    ///   - insets: Edge insets around the subview.
    ///   - backgroundColor: Container background color.
    /// - Returns: Configured header container view.
    static func getHeader(
        with subview: UIView,
        insets: UIEdgeInsets = Consts.edgeInsets,
        backgroundColor: UIColor = UIColor.theme.background
    ) -> UIView {
        let container = UIView()
        container.backgroundColor = backgroundColor
        container.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right),
            subview.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            subview.heightAnchor.constraint(equalToConstant: Consts.heightSubview)
        ])
        return container
    }
}
