//
//  SquareCollectionViewCell.swift
//  Game Of LIfe
//
//  Created by Jesse Ruiz on 7/29/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.size.width/2
    }
    
    func configureWithState(_ isAlive: Bool) {
        contentView.backgroundColor = isAlive ? UIColor.mountbattenPink : UIColor.mauveTaupe
    }
}
