//
//  LanguageType.swift
//  ChemaUtils
//
//  Created by José María Jiménez on 31/10/24.
//

import UIKit

public enum LanguageType: String {
    case spanish = "es"
    case english = "en"

    public init?(identifier: String) {
        if identifier.starts(with: LanguageType.spanish.rawValue) {
            self = .spanish
        } else if identifier.starts(with: LanguageType.english.rawValue) {
            self = .english
        } else {
            return nil
        }
    }

    public var icon: UIImage? {
        UIImage(named: "\(rawValue).svg", in: Bundle.module , with: nil)
    }
}
