//
//  BaseTableViewCell.swift
//  CodeTest
//
//  Created by Ian Gallagher on 14/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import UIKit

class BaseTableViewCell : UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    func initialize() {
        
    }
}
