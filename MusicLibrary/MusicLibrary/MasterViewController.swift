//
//  MasterViewController.swift
//  MusicLibrary
//
//  Created by Josue Ballona on 11/28/20.
//  Copyright © 2020 Josue Ballona. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        // add the add button to the bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    /*
     inserts a new album into the database
     
     - Parameters: sender: the add button
     */
    @objc
    func insertNewObject(_ sender: Any) {
        
             
        // If appropriate, configure the new managed object.
        // create an alert when add is pressed
        let alert = UIAlertController(title: "New Album", message: "Please add a new album", preferredStyle: .alert)
        
        // create error label
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 270, height: 18))
        label.textAlignment = .center
        label.textColor = .red
        label.font = label.font.withSize(12)
        alert.view.addSubview(label)
        label.isHidden = true
        
        // create save action
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            [unowned self] action in
            

            
            // save the input
            guard let nameTextField = alert.textFields?[0], let titleToSave = nameTextField.text
                else {
                    return
            }
            guard let artistTextField = alert.textFields?[1], let artistToSave = artistTextField.text
                else {
                    return
            }
            
            guard let releaseyearTextField = alert.textFields?[2], let releaseYearToSave = releaseyearTextField.text
                else {
                return
            }
            
            // validate input, make sure no empty fields or a year over 2020
            if titleToSave == "" {
                label.text = ""
                label.text = "Please enter an album title."
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            } else if artistToSave == "" {
                label.text = ""
                label.text = "Please enter an artist."
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            } else if Int(releaseYearToSave) ?? 9999 > 2020 || releaseYearToSave == "" {
                label.text = ""
                label.text = "Please enter a valid year."
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            } else {
                // save the title, artist, and release year and then add it to database
                // create the new album to add
                let context = self.fetchedResultsController.managedObjectContext
                let newAlbum = Album(context: context)
                newAlbum.title = titleToSave
                newAlbum.artist = artistToSave
                newAlbum.releaseyear = releaseYearToSave
                // Save the context.
                do {
                    try context.save()
                } catch {
                    // alert for possible data errors
                    let alert = UIAlertController(title: "No album created", message: "Data was unable to be saved.", preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
                self.tableView.reloadData()
            }
        })
        
        // cancel button action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // add text fields and actions to alert and present
        alert.addTextField { (textField) in textField.placeholder = "Title"; textField.autocapitalizationType = .words }
        alert.addTextField { (textField) in textField.placeholder = "Artist"; textField.autocapitalizationType = .words }
        alert.addTextField { (textField) in textField.placeholder = "Release Year"; textField.keyboardType = UIKeyboardType.numberPad }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    // MARK: - Segues

    /*
     Deals with changing from master to detail view controller
     
     - parameters:
        - segue: the UIStoryboard segue
        - sender: the master view controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    /*
     decides the number of sections in the master view controller
     
     - Parameters: tableView: the table view
     
     - Returns: an int representing the number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    /*
     populates the cells
     
     - Parameters:
        - tableView: the table
        - section: the section we are populating
     
     - Returns: int representing the number of items in the section
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                print("Unable to save album")
                return
            }
        }
    }

    func configureCell(_ cell: UITableViewCell, withEvent album: Album) {
        cell.textLabel!.text = album.title
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Album> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            print("Unable to fetch albums")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Album>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Album)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Album)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

