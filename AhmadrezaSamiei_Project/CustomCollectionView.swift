//
//  CustomCollectionView.swift
//  
//
//  Created by CTIS Student on 5.01.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var mContact = [Contact]()

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!

}
