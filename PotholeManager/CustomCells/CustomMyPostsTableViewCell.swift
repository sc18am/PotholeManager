//
//  CustomMyPostTableViewCell.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 08/08/2022.
//

import UIKit

protocol CustomMyPostsTableViewCellDelegate: AnyObject {
    
    func deleteButtonTapped(with postid: String)
    
}


class CustomMyPostsTableViewCell: UITableViewCell {

    var postId = ""
    
    weak var delegate: CustomMyPostsTableViewCellDelegate?
    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(with: postId)
    }
    
    func configure(with postid: String) {
        postId = postid
    }
}
