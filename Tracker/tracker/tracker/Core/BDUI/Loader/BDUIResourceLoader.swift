import Foundation

enum BDUIResourceLoader {
    static func loadNode(
        named resourceName: String,
        subdirectory: String? = nil,
        bundle: Bundle = .main
    ) throws -> BDUIViewNode {
        let url = bundle.url(
            forResource: resourceName,
            withExtension: "json",
            subdirectory: subdirectory
        ) ?? bundle.url(
            forResource: resourceName,
            withExtension: "json"
        )

        guard let url else {
            throw LoaderError.resourceNotFound(resourceName, subdirectory: subdirectory)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(BDUIViewNode.self, from: data)
    }
}

extension BDUIResourceLoader {
    enum LoaderError: LocalizedError {
        case resourceNotFound(String, subdirectory: String?)

        var errorDescription: String? {
            switch self {
            case let .resourceNotFound(resourceName, subdirectory):
                if let subdirectory {
                    return "BDUI resource not found: \(subdirectory)/\(resourceName).json"
                }
                return "BDUI resource not found: \(resourceName).json"
            }
        }
    }
}
