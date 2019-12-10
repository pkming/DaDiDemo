//
//  SearchResultsVc.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class SearchResultsVc: UIViewController {
    let disposeBag = DisposeBag()

    var searchResult = BehaviorSubject(value: [SectionModel<String, Any>](
        [SectionModel(model: "1", items: [])]
    ))

    let resultTabView: UITableView = {
        let resultTabView = UITableView(frame: CGRect.zero, style: .plain)
        resultTabView.register(UINib(nibName: "SearchAppsCell", bundle: nil), forCellReuseIdentifier: "SearchAppsCell")
        resultTabView.separatorStyle = .singleLine
        resultTabView.tableFooterView = UIView()
        return resultTabView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        setUpUI()
    }

    func setUpUI() {
        resultTabView.delegate = self
        resultTabView.dataSource = nil
        resultTabView.frame = view.frame
        setTablViewObserver()
        view.addSubview(resultTabView)
    }

    public func updateUI(_ models: [AppModel]) {
        do {
            var valus = try searchResult.value()
            valus[0].items = models
            searchResult.onNext(valus)
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

// 设置监听
extension SearchResultsVc {
    func setTablViewObserver() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(configureCell: { _, tableView, indexPath, appModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAppsCell") as! SearchAppsCell
            cell.updateCell(appModel as! AppModel, row: indexPath.row)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell

        })

        searchResult.asObserver()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: resultTabView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SearchResultsVc: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
