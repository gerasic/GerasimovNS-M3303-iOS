import UIKit

enum DS {
    enum Colors {
        static let background = UIColor.systemBackground
        static let surface = UIColor.secondarySystemBackground
        static let primary = UIColor.systemBlue
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let error = UIColor.systemRed
        static let success = UIColor.systemGreen
        static let separator = UIColor.systemGray4
        static let disabled = UIColor.systemGray3
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }

    enum Size {
        static let textFieldHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 50
        static let statusIndicator: CGFloat = 10
        static let chevron: CGFloat = 16
    }

    enum Typography {
        static func screenTitle() -> UIFont {
            .systemFont(ofSize: 28, weight: .bold)
        }

        static func sectionTitle() -> UIFont {
            .systemFont(ofSize: 20, weight: .bold)
        }

        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }

        static func bodyMedium() -> UIFont {
            .systemFont(ofSize: 17, weight: .medium)
        }

        static func bodySemibold() -> UIFont {
            .systemFont(ofSize: 17, weight: .semibold)
        }

        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .regular)
        }

        static func footnote() -> UIFont {
            .systemFont(ofSize: 14, weight: .regular)
        }

        static func button() -> UIFont {
            .systemFont(ofSize: 17, weight: .semibold)
        }
    }
}
