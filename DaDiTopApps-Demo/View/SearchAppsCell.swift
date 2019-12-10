//
//  SearchAppsCell.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import SDWebImage
import UIKit

class SearchAppsCell: UITableViewCell {
    @IBOutlet var iconImage: UIImageView!

    @IBOutlet var title: UILabel!

    @IBOutlet var cate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ model: AppModel, row _: Int) {
        iconImage.sd_setImage(with: URL(string: model.image), completed: nil)
        title.text = model.title
        cate.text = model.category

        iconImage.layer.cornerRadius = 10
    }
}
