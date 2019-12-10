//
//  CustomRefresh.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//

import MJRefresh
import UIKit

// 自定义下拉刷新控件
public class CustomRefreshHeader: MJRefreshNormalHeader {
    public override func prepare() {
        super.prepare()
        stateLabel?.font = UIFont.systemFont(ofSize: 14.0)
        stateLabel?.textColor = UIColor.black
        lastUpdatedTimeLabel?.font = UIFont.systemFont(ofSize: 14.0)
        lastUpdatedTimeLabel?.textColor = UIColor.black
    }
}

// 自定义上拉刷新控件
public class CustomRefreshFooter: MJRefreshAutoNormalFooter {
    public override func prepare() {
        super.prepare()
        setTitle("正在获取数据中...", for: .refreshing)
        setTitle("加载更多", for: .idle)
        setTitle("没有更多", for: .noMoreData)
        stateLabel?.font = UIFont.systemFont(ofSize: 14.0)
        stateLabel?.textColor = UIColor.black
    }

    // 隐藏footer
    func hideFooter() {
        stateLabel?.isHidden = true
    }

    // 显示footer
    func showFooter() {
        stateLabel?.isHidden = false
    }

    public override func placeSubviews() {
        super.placeSubviews()
        let loadingView = subviews[1] as! UIActivityIndicatorView
        // 圈圈
        var arrowCenterX = mj_w * 0.5
        if !isRefreshingTitleHidden {
            arrowCenterX -= 80
        }
        let arrowCenterY = mj_h * 0.5
        loadingView.center = CGPoint(x: arrowCenterX, y: arrowCenterY)
    }
}
