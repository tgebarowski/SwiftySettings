//
//  SettingsSliderCell.swift
//
//  SwiftySettings
//  Created by Tomasz Gebarowski on 07/08/15.
//  Copyright © 2015 codica Tomasz Gebarowski <gebarowski at gmail.com>.
//  All rights reserved.
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
//

import Foundation
import UIKit

class TextFieldCell : SettingsCell {

    var item: TextField!
    let titleLabel = UILabel()
    let textField = UITextField()
    weak var textFieldDelegate:UITextFieldDelegate? = nil

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override func updateConstraints()
    {
        if !didSetupConstraints {

            textField.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            // Title UILabel
            contentView.addConstraints(
                [NSLayoutConstraint(item: titleLabel,
                                    attribute: .Leading,
                                    relatedBy: .Equal,
                                    toItem: contentView,
                                    attribute: .Leading,
                                    multiplier: 1.0,
                                    constant: 10),
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .Top,
                                    relatedBy: .Equal,
                                    toItem: contentView,
                                    attribute: .Top,
                                    multiplier: 1.0,
                                    constant: 5),
                ])
            // UITextField
            contentView.addConstraints(
                [NSLayoutConstraint(item: textField,
                                    attribute: .Width,
                                    relatedBy: .Equal,
                                    toItem: contentView,
                                    attribute: .Width,
                                    multiplier: 0.9,
                                    constant: 0),
                 NSLayoutConstraint(item: contentView,
                                    attribute: .CenterX,
                                    relatedBy: .Equal,
                                    toItem: textField,
                                    attribute: .CenterX,
                                    multiplier: 1.0,
                                    constant: 0),
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .Bottom,
                                    relatedBy: .Equal,
                                    toItem: textField,
                                    attribute: .Top,
                                    multiplier: 1.0,
                                    constant: -10),
                 NSLayoutConstraint(item: contentView,
                                    attribute: .Bottom,
                                    relatedBy: .Equal,
                                    toItem: textField,
                                    attribute: .Bottom,
                                    multiplier: 1.0,
                                    constant: 15),
                 NSLayoutConstraint(item: textField,
                                    attribute: .Height,
                                    relatedBy: .Equal,
                                    toItem: nil,
                                    attribute: .NotAnAttribute,
                                    multiplier: 1.0,
                                    constant: 30)])

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    override func setupViews() {
        super.setupViews()

        contentView.addSubview(textField)
        contentView.addSubview(titleLabel)

        textLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()

        textField.addTarget(self, action: Selector("textInputChanged:"),
                            forControlEvents: .EditingChanged)
    }

    override func configureAppearance() {
        super.configureAppearance()

        textField.tintColor = appearance?.tintColor
        textField.borderStyle = .RoundedRect
        titleLabel.textColor = appearance?.cellTextColor
    }

    func load(item: TextField) {
        self.item = item

        self.titleLabel.text = item.title
        self.textField.text = item.value
        self.textField.secureTextEntry = item.secureTextEntry
        self.textField.delegate = textFieldDelegate

        self.configureAppearance()
        self.setNeedsUpdateConstraints()
    }

    func textInputChanged(sender: AnyObject) {
        if let text = textField.text {
            item.value = text
        }
    }
}