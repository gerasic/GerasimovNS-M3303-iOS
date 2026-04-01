enum EntriesListViewState: Equatable {
    case initial
    case loading
    case empty
    case content(sections: [EntriesListSectionViewModel])
    case error(EntriesListErrorViewModel)
}
