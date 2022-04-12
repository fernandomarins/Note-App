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
            
            let note = returnObject()
            
            guard let note = note else {
                return
            }
            
            if note == selectedNote {
                note.title = titleTextField.text
                note.desc = descriptionTextView.text
                
                // Always save the context
                saveContext()
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        
        let note = returnObject()
        guard let note = note else {
            return
        }

        if note == selectedNote {
            context.delete(note)
            saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func returnObject() -> Note? {
        
        var object: Note?
        
        let request = Note.fetchRequest()
        
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                // Searching for the correct note to update
                object = note
            }
        } catch {
            print(error)
        }
        
        return object
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
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
