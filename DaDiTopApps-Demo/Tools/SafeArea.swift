//
//  SafeArea.swift
//  DaDiTopApps-Demo
//
//  Created by 夏以铭 on 2019/12/9.
//  Copyright © 2019 夏以铭. All rights reserved.
//
import Foundation
import UIKit
public struct SafeArea {
    static func topSafeAreaHeight() -> CGFloat {
        if isIPhoneXorLater() {
            return 24
        } else {
            return 0
        }
    }

    static func bottomSafeAreaHeight() -> CGFloat {
        if isIPhoneXorLater() {
            return 34
        } else {
            return 0
        }
    }
}

func isIPhoneXorLater() -> Bool {
    let screenHieght = UIScreen.main.nativeBounds.size.height
    if screenHieght == 2436 || screenHieght == 1792 || screenHieght == 2688 || screenHieght == 1624 {
        return true
    } else {
        return false
    }
}
