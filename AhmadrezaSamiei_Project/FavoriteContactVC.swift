//
//  FavoriteContactVC.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 5.01.2022.
//  Copyright © 2022 CTIS. All rights reserved.
//

import UIKit
import CoreData

class FavoriteContactVC: UIViewController {
    
    var mContact = [Contact]()
    @IBOutlet weak var mCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func fetchData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        do {
            fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
            let results = try context.fetch(fetchRequest)
            mContact = results as! [Contact]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "favorite"{
            if let indexPath = getIndexPathForSelectedCell() {
                let  contact = mContact[indexPath.row]

                let editVC = segue.destination as! EditContactVC
                editVC.selectedContact = contact

            }
        }

    }
}



extension FavoriteContactVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mContact.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CustomCollectionViewCell

        let contact = mContact[indexPath.row]
        if(contact.isFavorite == true){
            cell.profileImgView.image = UIImage(data: contact.img ?? Data()) ?? UIImage()
            cell.nameLbl.text = contact.name
            cell.numberLbl.text = String(contact.number)
        }
        return cell

    }
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if self.mCollectionView!.indexPathsForSelectedItems!.count > 0 {
            indexPath = self.mCollectionView!.indexPathsForSelectedItems![0] as IndexPath
        }
        
        return indexPath
    }
    
}

