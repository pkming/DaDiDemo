//
//  RecAppCell.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import UIKit

class RecAppCell: UICollectionViewCell {
    @IBOutlet var iconImage: UIImageView!

    @IBOutlet var title: UILabel!

    @IBOutlet var cate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 10
    }

    public func updateCell(_ model: AppModel) {
        title.text = model.title
        cate.text = model.category
        iconImage.sd_setImage(with: URL(string: model.image), completed: nil)
    }
}
