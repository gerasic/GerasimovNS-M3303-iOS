import UIKit

final class EntriesListCollectionManager: NSObject {
    var onSelectMetric: ((MetricID) -> Void)?
    var onToggleSection: ((TagID) -> Void)?

    private var sections: [EntriesListSectionViewModel] = []

    func attach(to collectionView: UICollectionView) {
        collectionView.dataSource = self    // collectionView(список (cv)) будет обращаться за данными сюда    
        collectionView.delegate = self      // cv(список) будет обращаться за поведением
        collectionView.register(            // регистрация cell чтобы cv знала что need create и reuse
            EntriesListMetricCell.self,
            forCellWithReuseIdentifier: EntriesListMetricCell.reuseIdentifier
        )
        collectionView.register(            // регистрация header чтобы cv знала что need create и reuse
            EntriesListSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EntriesListSectionHeaderView.reuseIdentifier
        )
    }

    func setSections(_ sections: [EntriesListSectionViewModel], in collectionView: UICollectionView) {
        self.sections = sections
        collectionView.reloadData() // говорит cv заново спросить data и recreate/reuse elems
    }
}

extension EntriesListCollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    // какую ячейку показать в конкретной позиции (создает новую или реюзает)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EntriesListMetricCell.reuseIdentifier,
            for: indexPath
        ) as? EntriesListMetricCell else {
            return UICollectionViewCell()
        }

        let viewModel = sections[indexPath.section].items[indexPath.item]
        cell.configure(with: viewModel)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, // supplement - header or footer
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        // проверяем что именно хедер а не футер, инача пусто
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EntriesListSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? EntriesListSectionHeaderView else {
            return UICollectionReusableView()
        }

        let section = sections[indexPath.section]
        headerView.configure(with: section) // заполняется во viewModel
        headerView.onTap = { [weak self] in
            self?.onToggleSection?(section.id) // решает viewModel
        }
        return headerView
    }
}

extension EntriesListCollectionManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]
        onSelectMetric?(item.id) // отправляем во вьюмодел
    }
}

extension EntriesListCollectionManager: UICollectionViewDelegateFlowLayout {
    // какого размера метрик секшн
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sectionInset: UIEdgeInsets
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            sectionInset = flowLayout.sectionInset
        } else {
            sectionInset = .zero
        }

        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width: availableWidth, height: 84)
    }

    // какого ращмера секшн
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 44)
    }
}
