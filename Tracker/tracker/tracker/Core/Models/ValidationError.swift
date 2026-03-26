enum ValidationError: Error, Equatable {
    case emptyTitle
    case emptyTag
    case invalidValue
}
