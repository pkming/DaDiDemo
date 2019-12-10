//
//  AppsCell.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import SDWebImage
import UIKit

class AppsCell: UITableViewCell {
    @IBOutlet var index: UILabel!

    @IBOutlet var iconImage: UIImageView!

    @IBOutlet var title: UILabel!

    @IBOutlet var cate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ model: AppModel, row: Int) {
        index.text = String(row + 1)
        iconImage.sd_setImage(with: URL(string: model.image), completed: nil)
        title.text = model.title
        cate.text = model.category

        if row % 2 == 0 {
            iconImage.layer.cornerRadius = 10
        } else {
            iconImage.layer.cornerRadius = iconImage.frame.size.height / 2
        }
    }
}
