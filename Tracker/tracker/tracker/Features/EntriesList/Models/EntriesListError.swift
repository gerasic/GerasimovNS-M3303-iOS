enum EntriesListError: Error, Equatable {
    case noInternet
    case serviceUnavailable
    case invalidData
    case unknown
}
