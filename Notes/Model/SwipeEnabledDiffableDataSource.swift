import UIKit

final class SwipeEnabledDiffableDataSource: UITableViewDiffableDataSource<Section, UUID> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let note = itemIdentifier(for: indexPath) else {
            return
        }
        var currentSnapshot = snapshot()
        currentSnapshot.deleteItems([note])
        apply(currentSnapshot)
    }
}
