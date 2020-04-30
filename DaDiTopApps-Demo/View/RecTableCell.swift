//
//  RecTableCell.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import RxDataSources
import RxSwift
import UIKit

class RecTableCell: UITableViewCell {
    @IBOutlet var recColloctionView: UICollectionView!

    let disposeBag = DisposeBag()

    var appsTop = BehaviorSubject(value: [SectionModel<String, Any>](
        [SectionModel(model: "0", items: [])]
    ))

    // 定义布局方式
    let flowLayout = UICollectionViewFlowLayout()

    override func awakeFromNib() {
        super.awakeFromNib()

        // 自定义cell
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 100, height: 180)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        // 设置colloctionvView属性
        recColloctionView.delegate = nil
        recColloctionView.dataSource = nil
        recColloctionView.showsHorizontalScrollIndicator = false
        recColloctionView.collectionViewLayout = flowLayout
        recColloctionView.register(UINib(nibName: "RecAppCell", bundle: nil),
                                   forCellWithReuseIdentifier: "RecAppCell")

        // 设置监听
        registerObs()
    }

    // 更新数据
    func updateCell(_ models: [AppModel]) {
        var valus = try! appsTop.value()
        valus[0].items = models
        appsTop.onNext(valus)
    }
}

// 设置监听
extension RecTableCell {
    @objc func registerObs() {
        let dataSoure = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(configureCell: { _, recColloctionView, indexPath, appModel in

            let cell = recColloctionView.dequeueReusableCell(withReuseIdentifier: "RecAppCell", for: indexPath) as! RecAppCell
            cell.updateCell(appModel as! AppModel)
            return cell

        })

        appsTop.asObservable()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: recColloctionView.rx.items(dataSource: dataSoure))
            .disposed(by: disposeBag)
    }
}
