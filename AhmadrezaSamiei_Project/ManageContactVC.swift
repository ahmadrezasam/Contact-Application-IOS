//
//  ManageContactVC.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 30.12.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import CoreData

class ManageContactVC: UIViewController {

    var mContact = [Contact]()
    var selected = 0
    var isFavorite = false
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        mTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         fetchData()
         mTableView.reloadData()
     }
    
    func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")

        do {
            var results = try context.fetch(fetchRequest)
            mContact = results as! [Contact]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "edit"{
            if let indexPath = mTableView.indexPathForSelectedRow {
                let  contact = mContact[indexPath.row]

                let editVC = segue.destination as! EditContactVC
                editVC.selectedContact = contact

            }
        }

    }
    
}



extension ManageContactVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mContact.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell

        let contact = mContact[indexPath.row]

        cell.nameLabel?.text = contact.name!
        cell.profileImg.image = UIImage(data: contact.img ?? Data()) ?? UIImage()
        
        if contact.isFavorite == true{
            cell.favoriteImg.image = UIImage(named: "starY")
        }else{
            cell.favoriteImg.image = UIImage(named: "")

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        
        do {
            fetchRequest.sortDescriptors = [sortDescriptor]
            let fetchResults = try context.fetch(fetchRequest)
            mContact = fetchResults as! [Contact]

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if(editingStyle == .delete ) {

            let deleteContact = mContact[indexPath.row]
            context.delete(deleteContact)
            mContact.remove(at: indexPath.row)

            mTableView.deleteRows(at: [indexPath], with: .automatic)

            save()
        }
    }

    func getIndexPathForSelectedRow() -> IndexPath? {
        var indexPath: IndexPath?
        if mTableView.indexPathsForSelectedRows!.count > 0 {
            indexPath = mTableView.indexPathsForSelectedRows![0] as IndexPath
        }

        return indexPath
    }


}
