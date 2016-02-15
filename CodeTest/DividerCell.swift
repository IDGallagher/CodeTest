//
//  DividerCell.swift
//  CodeTest
//
//  Created by Ian Gallagher on 14/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import UIKit

class DividerCell : BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    
    static let reuseIdentifier = "DividerCell"
    
    func configureWithDivider(divider:LarkItem) {
        titleLabel.text = divider.heading
    }
    
}
