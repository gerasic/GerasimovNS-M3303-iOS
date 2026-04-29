import UIKit

enum DS {
    enum ColorToken: String, Decodable {
        case background
        case surface
        case primary
        case textPrimary
        case textSecondary
        case error
        case success
        case separator
        case disabled
        case transparent
    }

    enum SpacingToken: String, Decodable {
        case none
        case xs
        case s
        case m
        case l
        case xl
    }

    enum CornerRadiusToken: String, Decodable {
        case none
        case small
        case medium
        case large
        case pill
    }

    enum SizeToken: String, Decodable {
        case textFieldHeight
        case buttonHeight
        case statusIndicator
        case chevron
    }

    enum TypographyToken: String, Decodable {
        case screenTitle
        case sectionTitle
        case body
        case bodyMedium
        case bodySemibold
        case caption
        case footnote
        case button
    }

    enum TextAlignmentToken: String, Decodable {
        case left
        case center
        case right
        case natural
    }

    enum AxisToken: String, Decodable {
        case horizontal
        case vertical
    }

    enum StackAlignmentToken: String, Decodable {
        case fill
        case leading
        case center
        case trailing
    }

    enum StackDistributionToken: String, Decodable {
        case fill
        case fillEqually
        case fillProportionally
        case equalSpacing
        case equalCentering
    }

    struct Insets: Equatable, Decodable {
        let top: SpacingToken
        let leading: SpacingToken
        let bottom: SpacingToken
        let trailing: SpacingToken

        private enum CodingKeys: String, CodingKey {
            case top
            case leading
            case bottom
            case trailing
        }

        init(
            top: SpacingToken = .none,
            leading: SpacingToken = .none,
            bottom: SpacingToken = .none,
            trailing: SpacingToken = .none
        ) {
            self.top = top
            self.leading = leading
            self.bottom = bottom
            self.trailing = trailing
        }

        static func uniform(_ token: SpacingToken) -> Insets {
            Insets(top: token, leading: token, bottom: token, trailing: token)
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            top = try container.decodeIfPresent(SpacingToken.self, forKey: .top) ?? .none
            leading = try container.decodeIfPresent(SpacingToken.self, forKey: .leading) ?? .none
            bottom = try container.decodeIfPresent(SpacingToken.self, forKey: .bottom) ?? .none
            trailing = try container.decodeIfPresent(SpacingToken.self, forKey: .trailing) ?? .none
        }
    }

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

        static func value(for token: ColorToken) -> UIColor {
            switch token {
            case .background:
                background
            case .surface:
                surface
            case .primary:
                primary
            case .textPrimary:
                textPrimary
            case .textSecondary:
                textSecondary
            case .error:
                error
            case .success:
                success
            case .separator:
                separator
            case .disabled:
                disabled
            case .transparent:
                .clear
            }
        }
    }

    enum Spacing {
        static let none: CGFloat = 0
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32

        static func value(for token: SpacingToken) -> CGFloat {
            switch token {
            case .none:
                none
            case .xs:
                xs
            case .s:
                s
            case .m:
                m
            case .l:
                l
            case .xl:
                xl
            }
        }

        static func insets(for insets: Insets) -> NSDirectionalEdgeInsets {
            NSDirectionalEdgeInsets(
                top: value(for: insets.top),
                leading: value(for: insets.leading),
                bottom: value(for: insets.bottom),
                trailing: value(for: insets.trailing)
            )
        }
    }

    enum CornerRadius {
        static let none: CGFloat = 0
        static let small: CGFloat = 10
        static let medium: CGFloat = 12
        static let large: CGFloat = 16

        static func value(for token: CornerRadiusToken) -> CGFloat {
            switch token {
            case .none:
                none
            case .small:
                small
            case .medium:
                medium
            case .large:
                large
            case .pill:
                999
            }
        }
    }

    enum Size {
        static let textFieldHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 50
        static let statusIndicator: CGFloat = 10
        static let chevron: CGFloat = 16

        static func value(for token: SizeToken) -> CGFloat {
            switch token {
            case .textFieldHeight:
                textFieldHeight
            case .buttonHeight:
                buttonHeight
            case .statusIndicator:
                statusIndicator
            case .chevron:
                chevron
            }
        }
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

        static func value(for token: TypographyToken) -> UIFont {
            switch token {
            case .screenTitle:
                screenTitle()
            case .sectionTitle:
                sectionTitle()
            case .body:
                body()
            case .bodyMedium:
                bodyMedium()
            case .bodySemibold:
                bodySemibold()
            case .caption:
                caption()
            case .footnote:
                footnote()
            case .button:
                button()
            }
        }
    }

    enum Layout {
        static func axis(for token: AxisToken) -> NSLayoutConstraint.Axis {
            switch token {
            case .horizontal:
                .horizontal
            case .vertical:
                .vertical
            }
        }

        static func textAlignment(for token: TextAlignmentToken) -> NSTextAlignment {
            switch token {
            case .left:
                .left
            case .center:
                .center
            case .right:
                .right
            case .natural:
                .natural
            }
        }

        static func stackAlignment(for token: StackAlignmentToken) -> UIStackView.Alignment {
            switch token {
            case .fill:
                .fill
            case .leading:
                .leading
            case .center:
                .center
            case .trailing:
                .trailing
            }
        }

        static func stackDistribution(for token: StackDistributionToken) -> UIStackView.Distribution {
            switch token {
            case .fill:
                .fill
            case .fillEqually:
                .fillEqually
            case .fillProportionally:
                .fillProportionally
            case .equalSpacing:
                .equalSpacing
            case .equalCentering:
                .equalCentering
            }
        }
    }
}
