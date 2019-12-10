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
    @IBOutlet var iconImage: UIImageView!  //图片

    @IBOutlet var title: UILabel!  //标题

    @IBOutlet var cate: UILabel!   //分类

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //更新数据
    func updateCell(_ model: AppModel, row _: Int) {
        iconImage.sd_setImage(with: URL(string: model.image), completed: nil)
        title.text = model.title
        cate.text = model.category

        iconImage.layer.cornerRadius = 10
    }
}
