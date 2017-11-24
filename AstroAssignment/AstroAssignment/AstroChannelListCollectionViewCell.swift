//
//  AstroChannelListCollectionViewCell.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit

class AstroChannelListCollectionViewCell: UICollectionViewCell {
   @IBOutlet weak var channelTittle: UILabel!
    
    func update(model : AstroChannelListModel){
        channelTittle.text = model.channelTitle!
    }
}
