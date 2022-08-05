//
//  CustomPostTableViewCell.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 20/07/2022.
//

import UIKit

protocol CustomPostTableViewCellDelegate: AnyObject {
    
    func likeButtonTapped()
    
}


class CustomPostTableViewCell: UITableViewCell {

    weak var delegate: CustomPostTableViewCellDelegate?

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var residentialDistrictLabel: UILabel!

    @IBOutlet weak var zipCodeLabel: UILabel!
    
    @IBOutlet weak var widthLabel: UILabel!

    @IBOutlet weak var depthLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        delegate?.likeButtonTapped()
    }
}
