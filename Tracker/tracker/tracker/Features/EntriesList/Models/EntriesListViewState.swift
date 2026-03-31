enum EntriesListViewState: Equatable {
    case initial
    case loading
    case empty
    case content(sections: [MetricSection])
    case error(message: String)
}
