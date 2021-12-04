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
    var positionNote = 0
    
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
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
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
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
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
    
    @IBAction func deleteAction(_ sender: Any) {
//        let toDelete = noteList[positionNote].id!
//        noteList.remove(at: Int(truncating: toDelete))
//        print(noteList[positionNote])
        context.delete(noteList[positionNote])
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
        
    }
    
}

