protocol MetricDetailsRouter: AnyObject {
    func openEntry(entryId: EntryID)
    func close()
}
