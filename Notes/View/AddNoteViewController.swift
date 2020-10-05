import UIKit

final class AddNoteViewController: UIViewController {
    weak var notesSaving: NotesSaving?
    private var note: Note?

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.backgroundColor = .systemGray
        textField.rounded()
        return textField
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .systemGray
        textView.rounded()
        return textView
    }()

    private let button: CustomTintButton = {
        let button = CustomTintButton(type: .custom)
        button.setTitleColor(.systemGray6, for: .normal)
        button.setTitle("Salvar", for: .normal)
        button.rounded()
        button.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
        return button
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
        view.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 0, trailing: 16)
    }
    
    func buildViewHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(button)
    }

    func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8.0).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true

        button.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8.0).isActive = true
        button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
}

private extension AddNoteViewController {
    @objc func didTouchSaveButton() {
        save()
        navigationController?.popViewController(animated: true)
    }

    func save() {
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
}
