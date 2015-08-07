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
        return String(mirror.subjectType)
    }
}

extension UITableViewCell : Reusable {}
extension UITableViewHeaderFooterView: Reusable {}


extension UITableView {

    enum Type {
        case Cell
        case Header
        case Footer
    }

    func registerClass<T: UIView where T: Reusable>(aClass: T.Type, type: Type) {
        switch (type) {
        case .Cell:
            registerClass(aClass, forCellReuseIdentifier: T.reuseIdentifier)
        case .Header: fallthrough
        case .Footer:
            registerClass(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func registerNib<T: UIView where T: Reusable>(aNib: UINib, aClass: T.Type, type: Type) {
        switch (type) {
        case .Cell:
            registerNib(aNib, forCellReuseIdentifier: T.reuseIdentifier)
        case .Header: fallthrough
        case .Footer:
            registerNib(aNib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UIView where T: Reusable>(aClass: T.Type, type: Type) -> T {
        switch (type) {
        case .Cell:
            return dequeueReusableCellWithIdentifier(T.reuseIdentifier) as! T
        case .Header: fallthrough
        case .Footer:
            return dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T

        }

    }
}