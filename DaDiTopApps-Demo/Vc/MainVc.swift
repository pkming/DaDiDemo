//
//  MainVc.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import MJRefresh
import RxCocoa
import RxDataSources
import RxSwift
import SwiftyJSON
import UIKit

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height
public typealias successBack = (_ appModels: [AppModel]) -> Void
public typealias errorBack = () -> Void
class MainVc: UIViewController {
    let disposeBag = DisposeBag()

    var appsTop100 = BehaviorSubject(value: [SectionModel<String, Any>](
        [SectionModel(model: "1", items: []),
         SectionModel(model: "2", items: [])]
    ))

    var resultVC: SearchResultsVc?
    var searchBarController: UISearchController?
    var activityIndicator: UIActivityIndicatorView!
    var isNetworkError: Bool? //判断网络请求是否失败

    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 56 + 64 + SafeArea.topSafeAreaHeight(), width: width, height: height - (56 + 64 + SafeArea.topSafeAreaHeight() - SafeArea.bottomSafeAreaHeight())), style: .plain)
        tableView.register(UINib(nibName: "AppsCell", bundle: nil), forCellReuseIdentifier: "AppsCell")
        tableView.register(UINib(nibName: "RecTableCell", bundle: nil), forCellReuseIdentifier: "RecTableCell")
        tableView.separatorStyle = .singleLine

        return tableView
    }()

    override func viewDidLoad() {
        setUpUI()
        setTablViewObserver()
        setSearchBarObserver()

        let allApps: [AppModel]? = DaDiAppsDB.shard()?.findAll()
        if allApps?.count ?? 0 > 0 {
            // 更新数据源
            var valueArr: Array = try! appsTop100.value()
            if valueArr[0].items.count == 0 {
                valueArr[0].items = [allApps ?? [AppModel()]]
            }
            tableView.isHidden = false
            valueArr[1].items = valueArr[1].items + (allApps ?? [AppModel()])
            appsTop100.onNext(valueArr)
        } else {
            activityIndicator.startAnimating()
        }

        getDataSource(succesCallback: { apps in
            _ = DaDiAppsDB.shard()?.add(apps)
            // 更新数据源
            var valueArr: Array = try! self.appsTop100.value()
            if valueArr[0].items.count == 0 {
                valueArr[0].items = [apps]
            }
            if apps.count > 0, self.tableView.isHidden {
                self.tableView.isHidden = false
            }
            valueArr[1].items = apps
            self.appsTop100.onNext(valueArr)
            self.activityIndicator.stopAnimating()
        }) {
            self.isNetworkError = true
            self.activityIndicator.stopAnimating()
        }
    }

    func setUpUI() {
        title = "Top100Apps"
        setUpSearchBar()
        setUpTableView()
        setUpActivity()
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        activityIndicator.startAnimating()
        getDataSource(succesCallback: { apps in
            _ = DaDiAppsDB.shard()?.add(apps)
            // 更新数据源
            var valueArr: Array = try! self.appsTop100.value()
            if valueArr[0].items.count == 0 {
                valueArr[0].items = [apps]
            }
            if apps.count > 0, self.tableView.isHidden {
                self.tableView.isHidden = false
            }
            valueArr[1].items = apps
            self.appsTop100.onNext(valueArr)
            self.isNetworkError = false
            self.activityIndicator.stopAnimating()
        }) {
            self.isNetworkError = true
            self.activityIndicator.stopAnimating()
        }
    }

    func setUpSearchBar() {
        resultVC = SearchResultsVc()
        searchBarController = UISearchController(searchResultsController: resultVC)
        searchBarController?.searchBar.placeholder = "搜索"
        searchBarController?.delegate = self
        searchBarController?.searchBar.setPositionAdjustment(UIOffset(horizontal: (width - 120) / 2, vertical: 0), for: .search)

        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = nil
        tableView.mj_header = CustomRefreshHeader()
        tableView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(pullToRefresh))
        tableView.mj_footer = CustomRefreshFooter()
        tableView.mj_footer?.setRefreshingTarget(self, refreshingAction: #selector(pullToLoadMore))
        tableView.isHidden = true
        view.addSubview(tableView)
    }

    // 设置转圈圈
    func setUpActivity() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

// 设置观察者
extension MainVc {
    func setTablViewObserver() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(configureCell: { _, tableView, indexPath, appModel in
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppsCell") as! AppsCell
                cell.updateCell(appModel as! AppModel, row: indexPath.row)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecTableCell") as! RecTableCell
                let apps: Array = appModel as! [AppModel]
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.updateCell(apps)
                return cell
            }
        })

        appsTop100.asObserver()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    func setSearchBarObserver() {
        searchBarController?.searchBar.searchTextField.rx.text.orEmpty
            .asObservable()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { element in
                let vaule = try! self.appsTop100.value()
                let resultArray = vaule[1].items.filter { (item) -> Bool in
                    let appModel = item as! AppModel
                    if appModel.title.range(of: element) != nil {
                        return true
                    } else {
                        return false
                    }
                }

                self.resultVC?.updateUI(resultArray as! [AppModel])

            })
            .disposed(by: disposeBag)
    }
}

// 设置代理
extension MainVc: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        }
        return 100
    }
}

// 设置代理改变搜索栏字体居中
extension MainVc: UISearchControllerDelegate {
    @available(iOS 11, *)
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setPositionAdjustment(UIOffset.zero, for: .search)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: (width - 120) / 2, vertical: 0), for: .search)
    }
}

// 请求数据
extension MainVc {
    @objc func pullToRefresh() {
        getDataSource(succesCallback: { apps in

            // 更新数据源
            var valueArr: Array = try! self.appsTop100.value()
            if valueArr[0].items.count == 0 {
                valueArr[0].items = [apps]
            }
            if apps.count > 0, self.tableView.isHidden {
                self.tableView.isHidden = false
            }
            valueArr[1].items = apps
            self.appsTop100.onNext(valueArr)
            self.tableView.mj_header?.endRefreshing()
        }) {
            self.tableView.mj_header?.endRefreshing()
        }
    }

    @objc func pullToLoadMore() {
        getDataSource(succesCallback: { apps in

            // 更新数据源
            var valueArr: Array = try! self.appsTop100.value()
            if apps.count > 0, self.tableView.isHidden {
                self.tableView.isHidden = false
            }
            valueArr[1].items = valueArr[1].items + apps
            self.appsTop100.onNext(valueArr)
            self.tableView.mj_footer?.endRefreshing()
        }) {
            self.tableView.mj_footer?.endRefreshing()
        }
    }

    // 获取网络数据
    func getDataSource(succesCallback: @escaping successBack, errorCallback: @escaping errorBack) {
        _ = DaDiRequest.getTopFreApplications(succesCallback: { resp in

            let entryJSON: JSON = resp as! JSON
            let feed = entryJSON["feed"].dictionaryValue
            let entry: Array = feed["entry"]?.array ?? []

            var apps: [AppModel] = []
            _ = entry.map { (json: JSON) -> AppModel in
                autoreleasepool {
                    let app: AppModel = AppModel(json: json)
                    apps.append(app)
                    return app
                }
            }

            succesCallback(apps)

        }) { _, _ in
            errorCallback()
        }
    }
}
