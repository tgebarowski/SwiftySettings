//
// UITableViewExtensions.swift
// Created by Tomasz on 09/08/15.
//
// The MIT License (MIT)
// Copyright © 2015 codica. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        let mirror = Mirror(reflecting: self)
        return String(describing: mirror.subjectType)
    }
}

extension UITableViewCell : Reusable {}
extension UITableViewHeaderFooterView: Reusable {}


extension UITableView {

    enum CellType {
        case cell
        case header
        case footer
    }

    func registerClass<T: UIView>(_ aClass: T.Type, type: CellType) where T: Reusable {
        switch (type) {
        case .cell:
            register(aClass, forCellReuseIdentifier: T.reuseIdentifier)
        case .header: fallthrough
        case .footer:
            register(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func registerNib<T: UIView>(_ aNib: UINib, aClass: T.Type, type: CellType) where T: Reusable {
        switch (type) {
        case .cell:
            register(aNib, forCellReuseIdentifier: T.reuseIdentifier)
        case .header: fallthrough
        case .footer:
            register(aNib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UIView>(_ aClass: T.Type, type: CellType) -> T where T: Reusable {
        switch (type) {
        case .cell:
            return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
        case .header: fallthrough
        case .footer:
            return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T

        }

    }
}
