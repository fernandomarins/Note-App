//
//  ViewController.swift
//  Note App
//
//  Created by Fernando Marins on 03/12/21.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var selectedNote: Note? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        // Update the view
        if selectedNote != nil {
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
        }
        
        setupTapToDismiss()
    }

    @IBAction func saveAction(_ sender: Any) {
        
        if descriptionTextView.text.isEmpty {
            displayAlert()
            return
        }
        
        // Adding a new note
        if selectedNote == nil {
            let newNote = Note(context: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.desc = descriptionTextView.text
            
            do {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            } catch {
                print(error)
            }
        } else {
            // Editing a note
            let request = Note.fetchRequest()
            
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    // Searching for the correct note to update
                    if note == selectedNote {
                        note.title = titleTextField.text
                        note.desc = descriptionTextView.text
                        
                        // Always save the context
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func displayAlert() {
        let alert = UIAlertController(title: "Attention", message: "Please add a description to the note", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

extension NoteDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
