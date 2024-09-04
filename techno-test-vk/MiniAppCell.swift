//
//  MiniAppCell.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit

class MiniAppCell: UITableViewCell {
    static let identifier = "MiniAppCell"

    private var embeddedViewController: UIViewController?

    func configure(viewController: UIViewController) {
        embeddedViewController?.view.removeFromSuperview()
        embeddedViewController?.removeFromParent()

        embeddedViewController = viewController
        guard let embeddedView = viewController.view else { return }
        contentView.addSubview(embeddedView)

        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embeddedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            embeddedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            embeddedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            embeddedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
