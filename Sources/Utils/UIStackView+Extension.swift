//
//  UIStackView+Extension.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 20/10/24.
//

import UIKit

public extension UIStackView {
    func addHorizontalSpacer(width: CGFloat) {
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        addArrangedSubview(spacer)
    }
}
