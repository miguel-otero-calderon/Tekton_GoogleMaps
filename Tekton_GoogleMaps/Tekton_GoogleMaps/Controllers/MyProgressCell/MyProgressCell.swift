//
//  MyProgressCell.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 20/05/22.
//

import UIKit

class MyProgressCell: UITableViewCell {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    static let identifier = "MyProgressCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCell(data: MyProgressCellData) {
        self.timerLabel.text = data.timer
        self.sourceLabel.text = data.source
        self.targetLabel.text = data.target
        self.distanceLabel.text = data.distance
    }
}
struct MyProgressCellData {
    
    let timer: String
    let source: String
    let target: String
    let distance: String
    
    init(timer: String, source: String, target: String, distance: String) {
        self.timer = timer
        self.source = source
        self.target = target
        self.distance = distance
    }
}
