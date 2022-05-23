//
//  DetailContactVC.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 1.01.2022.
//  Copyright © 2022 CTIS. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class EditContactVC: UIViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var favoriteImgView: UIImageView!
    @IBOutlet weak var dateOfCreationLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var noteTF: UITextField!
    var profile = 0
    var selected = 0
    var isFavorite = false
    var audioPlayer: AVAudioPlayer!
    
    var selectedContact: Contact? = nil
    var mContact = [Contact]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onClickEdit(_ sender: UIBarButtonItem) {
        if  nameTF!.text!.isEmpty {
            displayAlert(header: "ERORR", msg: "Name cannot be empty.")
        }
        else if numberTF!.text!.isEmpty{
            displayAlert(header: "ERORR", msg: "Number cannot be empty.")
        }
        else {
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let dateString = formatter.string(from: currentDateTime)
            let imgData = profileImgView.image!.jpegData(compressionQuality: 1)!
            updateItem(nameTF.text!, number: Int64((numberTF.text!))!, email: emailTF.text ?? "", date: dateString, note: noteTF.text ?? "", img: imgData, isFavorite: isFavorite)

        }
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if(object == selectedContact){
                    context.delete(object)
                }
            }
            try context.save()
        } catch _ {
            // error handling
        }
        DBHelper.save()
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManageContactVC") as! ManageContactVC
        
        self.navigationController!.pushViewController(secondViewController, animated: true)    }
    
    func updateItem(_ name: String, number: Int64, email: String, date: String, note: String, img: Data, isFavorite: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let contact = result as! Contact
                if(contact == selectedContact)
                {
                    contact.name = nameTF.text
                    contact.number = Int64(numberTF.text!)!
                    contact.email = emailTF.text
                    contact.note = noteTF.text
                    contact.img = profileImgView.image!.jpegData(compressionQuality: 1)!
                    contact.isFavorite = isFavorite
                    
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
        
    }
    
    @IBAction func onTapFavorite(_ sender: UITapGestureRecognizer) {
        playSound()
        if selected == 0 {
            selected = 1
            favoriteImgView.image = UIImage(named: "starY")
            isFavorite = true
        }else{
            selected = 0
            favoriteImgView.image = UIImage(named: "starW")
            isFavorite = false
        }
    }
    
    @IBAction func onTapProfile(_ sender: UITapGestureRecognizer) {
        if profile == 0 {
            profile = 1
            profileImgView.image = UIImage(named: "man")
        }else if profile == 1{
            profile = 2
            profileImgView.image = UIImage(named: "woman")
        }else{
            profile = 0
            profileImgView.image = UIImage(named: "user")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedContact != nil)
        {
            nameTF.text = selectedContact?.name
            if let number = selectedContact?.number {
                numberTF.text = String(number)
            }
            else{
                numberTF.text = "";
            }
            emailTF.text = selectedContact?.email
            noteTF.text = selectedContact?.note
            profileImgView.image = UIImage(data: selectedContact!.img ?? Data()) ?? UIImage()
            if selectedContact!.isFavorite == true{
                favoriteImgView.image = UIImage(named: "starY")
            }
            if let index = (selectedContact!.date!.range(of: "at")?.lowerBound){
                dateOfCreationLbl.text = String(selectedContact!.date!.prefix(upTo: index))
            }
            else{
                dateOfCreationLbl.text = String(selectedContact!.date!)
            }
        }
    }
    func displayAlert(header: String, msg: String) {
        let mAlert = UIAlertController(title: header, message: msg, preferredStyle: UIAlertController.Style.alert)
        mAlert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(mAlert, animated: true, completion: nil)
    }
    func playSound() {
        let soundURL = Bundle.main.url(forResource: "select-click", withExtension: "wav")
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
        
        audioPlayer.play()
    }
}
