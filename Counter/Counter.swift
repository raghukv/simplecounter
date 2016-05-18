//
//  Counter.swift
//  Counter
//
//  Created by RaghuKV on 12/27/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import Foundation
import UIKit

class CounterCell : UITableViewCell
{
    var name = "";
    
    // default is zero
    var countNum = 0;

    // default is 1
    var increment = 1;
    
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}