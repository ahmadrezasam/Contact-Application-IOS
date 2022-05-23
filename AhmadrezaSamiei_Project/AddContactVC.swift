//
//  AddContactVC.swift
//  AhmadrezaSamiei_Project
//
//  Created by CTIS Student on 29.12.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
//import MaterialComponents.MaterialTextControls_FilledTextAreas
//import MaterialComponents.MaterialTextControls_FilledTextFields
//import MaterialComponents.MaterialTextControls_OutlinedTextAreas
//import MaterialComponents.MaterialTextControls_OutlinedTextFields
//import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
//import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
//import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
//import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

// *******Command PhaseScriptExecution failed with a nonzero exit code**********

class AddContactVC: UIViewController {

    var mContact = [Contact]()
//    @IBOutlet var nameTF: MDCFilledTextField!
//    @IBOutlet var numberTF: MDCFilledTextField!
//    @IBOutlet var emailTF: MDCFilledTextField!
//    @IBOutlet var noteTF: MDCFilledTextField!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var numberTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var noteTF: UITextField!
    @IBOutlet weak var mImgView: UIImageView!
    @IBOutlet weak var mFavoriteImg: UIImageView!
    var profile = 0
    var selected = 0
    var isFavorite = false
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let personImg = UIImageView(image: UIImage(named: "person"))
//        personImg.frame = CGRect(x:20, y:230,width:40 , height:40)
//        view.addSubview(personImg)
//        nameTF = MDCFilledTextField(frame: CGRect(x:70, y:220,width:self.view.frame.width - 90 , height:40))
//        nameTF.label.text = "Name"
//        nameTF.sizeToFit()
//        view.addSubview(nameTF)
//
//        let phoneImg = UIImageView(image: UIImage(named: "phone"))
//        phoneImg.frame = CGRect(x:20, y:320,width:40 , height:40)
//        view.addSubview(phoneImg)
//        numberTF = MDCFilledTextField(frame: CGRect(x:70, y:310,width:self.view.frame.width - 90 , height:40))
//        numberTF.label.text = "Phone number"
//        numberTF.placeholder = "555-555-5555"
//        numberTF.keyboardType = .asciiCapableNumberPad
//        numberTF.sizeToFit()
//        view.addSubview(numberTF)
//
//        let emailImg = UIImageView(image: UIImage(named: "email"))
//        emailImg.frame = CGRect(x:20, y:410,width:40 , height:40)
//        view.addSubview(emailImg)
//        emailTF = MDCFilledTextField(frame: CGRect(x:70, y:400,width:self.view.frame.width - 90 , height:40))
//        emailTF.label.text = "Email"
//        emailTF.placeholder = "email@email.com"
//        emailTF.sizeToFit()
//        view.addSubview(emailTF)
//
//        let noteImg = UIImageView(image: UIImage(named: "note"))
//        noteImg.frame = CGRect(x:20, y:500,width:40 , height:40)
//        view.addSubview(noteImg)
//        noteTF = MDCFilledTextField(frame: CGRect(x:70, y:490,width:self.view.frame.width - 90 , height:40))
//        noteTF.label.text = "Note"
//        noteTF.placeholder = "Description"
//        noteTF.sizeToFit()
//        view.addSubview(noteTF)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onSingleTapProfile(_ sender: UITapGestureRecognizer) {
        if profile == 0 {
            profile = 1
            mImgView.image = UIImage(named: "man")
        }else if profile == 1{
            profile = 2
            mImgView.image = UIImage(named: "woman")
        }else{
            profile = 0
            mImgView.image = UIImage(named: "user")
        }
    }
    
    @IBAction func onSingleTapFavorite(_ sender: UITapGestureRecognizer) {
        playSound()
        if selected == 0 {
            selected = 1
            mFavoriteImg.image = UIImage(named: "starY")
            isFavorite = true
        }else{
            selected = 0
            mFavoriteImg.image = UIImage(named: "starW")
            isFavorite = false
        }
    }
    
    func someEntityExists(number: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "number = %d", number)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var results: Any = []
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return (results as AnyObject).count > 0
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
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

            let imgData = mImgView.image!.jpegData(compressionQuality: 1)!

            if someEntityExists(number: Int64((numberTF.text!))!) == false{
                DBHelper.saveNewItem(nameTF.text!, number: Int64((numberTF.text!))!, email: emailTF.text ??
                    "", date: dateString, note: noteTF.text ?? "", img: imgData, isFavorite: isFavorite)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ManageContactVC") as! ManageContactVC
                        self.present(newViewController, animated: true, completion: nil)
            }else{
                displayAlert(header: "Erorr", msg: "A contact with the same number exist!")
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
