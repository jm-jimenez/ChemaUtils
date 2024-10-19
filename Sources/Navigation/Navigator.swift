//
//  Navigator.swift
//  Navigation
//
//  Created by José María Jiménez on 19/10/24.
//

import UIKit

public final class Navigator {
    public static let shared = Navigator()
    public weak var navigationController: UINavigationController?

    public func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
