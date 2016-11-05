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
                                    attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .leading,
                                    multiplier: 1.0,
                                    constant: 10),
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .top,
                                    multiplier: 1.0,
                                    constant: 5),
                ])
            // UITextField
            contentView.addConstraints(
                [NSLayoutConstraint(item: textField,
                                    attribute: .width,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .width,
                                    multiplier: 0.9,
                                    constant: 0),
                 NSLayoutConstraint(item: contentView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: textField,
                                    attribute: .centerX,
                                    multiplier: 1.0,
                                    constant: 0),
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: textField,
                                    attribute: .top,
                                    multiplier: 1.0,
                                    constant: -10),
                 NSLayoutConstraint(item: contentView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: textField,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 15),
                 NSLayoutConstraint(item: textField,
                                    attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
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

        textField.addTarget(self, action: #selector(TextFieldCell.textInputChanged(_:)),
                            for: .editingChanged)
    }

    override func configureAppearance() {
        super.configureAppearance()

        textField.tintColor = appearance?.tintColor
        textField.borderStyle = .roundedRect
        titleLabel.textColor = appearance?.cellTextColor
    }

    func load(_ item: TextField) {
        self.item = item

        self.titleLabel.text = item.title
        self.textField.text = item.value
        self.textField.isSecureTextEntry = item.secureTextEntry
        self.textField.delegate = textFieldDelegate

        self.configureAppearance()
        self.setNeedsUpdateConstraints()
    }

    func textInputChanged(_ sender: AnyObject) {
        if let text = textField.text {
            item.value = text
        }
    }
}
