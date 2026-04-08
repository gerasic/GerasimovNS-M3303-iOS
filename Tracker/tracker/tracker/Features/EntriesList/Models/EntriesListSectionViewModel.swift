struct EntriesListSectionViewModel: Equatable {
    let id: TagID
    let title: String
    let isCollapsed: Bool
    let items: [EntriesListMetricCellViewModel]
}
