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
        if selectedNote != nil {
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
        }
        
    }

    @IBAction func saveAction(_ sender: Any) {
        
        
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
            let request = Note.fetchRequest()
            
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    if note == selectedNote {
                        note.title = titleTextField.text
                        note.desc = descriptionTextView.text
                        
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
}

