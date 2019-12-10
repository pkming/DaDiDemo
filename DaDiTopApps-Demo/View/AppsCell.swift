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
    @IBOutlet var index: UILabel!  //序号

    @IBOutlet var iconImage: UIImageView!  //图片

    @IBOutlet var title: UILabel!  //标题

    @IBOutlet var cate: UILabel!   //分类

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //更新数据
    func updateCell(_ model: AppModel, row: Int) {
        index.text = String(row + 1)
        iconImage.sd_setImage(with: URL(string: model.image), completed: nil)
        title.text = model.title
        cate.text = model.category

        //切割成圆还是切角
        if row % 2 == 0 {
            iconImage.layer.cornerRadius = 10
        } else {
            iconImage.layer.cornerRadius = iconImage.frame.size.height / 2
        }
    }
}
