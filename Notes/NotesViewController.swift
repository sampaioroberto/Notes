import UIKit

enum Section {
    case main
}

protocol NotesSaving: AnyObject {
    func saveNote(_ note: Note)
}

final class NotesViewController: UIViewController {

    typealias DataSource = SwipeEnabledDiffableDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UUID>

    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"

        buildViewHierarchy()
        setupConstraints()
        configureInitialDiffableSnapshot()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToNoteDetail))
    }

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemIndigo
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NoteCell.self, forCellReuseIdentifier: String(describing: NoteCell.self))
        view.delegate = self
        return view
    }()

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView, cellProvider: { tableview, indexPath, uuid in
            guard
                let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self)) as? NoteCell
                else {
                return UITableViewCell()
            }
            let note = self.notes[indexPath.row]
            cell.configureWithTitle(note.title, description: note.description)
            return cell
        })
        return dataSource
    }()
}

private extension NotesViewController {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func configureInitialDiffableSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc func goToNoteDetail() {
        let controller = AddNoteViewController(notesSaving: self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

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

extension NotesViewController: NotesSaving {
    func saveNote(_ note: Note) {
        if let index = notes.firstIndex(of: note) {
            notes[index] = note
        } else {
            notes.append(note)
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes.map(\.identifier), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AddNoteViewController(notesSaving: self, note: notes[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
