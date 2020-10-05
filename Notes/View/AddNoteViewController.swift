import UIKit

final class AddNoteViewController: UIViewController {
    private let padding: CGFloat = 8.0

    weak var notesSaving: NotesSaving?
    private var note: Note?

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.backgroundColor = .systemBackground
        textField.rounded()
        return textField
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .systemBackground
        textView.rounded()
        return textView
    }()

    init(notesSaving: NotesSaving, note: Note? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.notesSaving = notesSaving
        self.note = note

        guard let note = note else {
            return
        }

        titleTextField.text = note.title
        descriptionTextView.text = note.description
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildViewHierarchy()
        setupConstraints()
    }

    override func viewDidDisappear(_ animated: Bool) {
        guard
            let titleText = titleTextField.text,
            let descriptionText = descriptionTextView.text,
            titleText.isEmpty == false,
            descriptionText.isEmpty == false
            else {
                return
        }

        guard var note = note else {
            let note = Note(title: titleText, description: descriptionText)
            notesSaving?.saveNote(note)
            return
        }
        note.title = titleText
        note.description = descriptionText
        notesSaving?.saveNote(note)
    }

    func buildViewHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
    }

    func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
    }
}
