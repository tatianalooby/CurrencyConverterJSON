//
//  CustomCell.swift
//  CurrencyConverterJSON
//
//  Created by Tatiana Looby on 22/02/2017.
//  Copyright © 2017 Tatiana Looby. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
