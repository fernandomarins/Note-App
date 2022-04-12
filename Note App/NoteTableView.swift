//
//  NoteTableView.swift
//  Note App
//
//  Created by Fernando Marins on 03/12/21.
//

var noteList = [Note]()

import UIKit
import CoreData

class NoteTableView: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    func loadData() {
        // The NSManagedObject comes with a built-in fetch request method
        let request = Note.fetchRequest()
        do {
            noteList = try context.fetch(request) as! [Note]
        } catch {
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        thisNote = noteList[indexPath.row]
        noteCell.titleLabel.text = thisNote.title
        noteCell.descriptionLabel.text = thisNote.desc
        
        return noteCell
    }
}
    
extension NoteTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteDetailVC
            
            // Sending the note to the next view
            let selectedNote: Note!
            selectedNote = noteList[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = noteList[indexPath.row]
            context.delete(commit)
            noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            try? context.save()
        }
    }

}
