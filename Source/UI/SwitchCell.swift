//
//  SettingsSwitchCell.swift
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

class SwitchCell : SettingsCell {

    var item: Switch!
    let switchView = UISwitch()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override func updateConstraints() {

        if !didSetupConstraints {
            switchView.translatesAutoresizingMaskIntoConstraints = false

            // Spacing Between Title and Selected UISwitch
            contentView.addConstraint(NSLayoutConstraint(
                item: textLabel!,
                attribute: .right,
                relatedBy: .equal,
                toItem: switchView,
                attribute: .left,
                multiplier: 1.0,
                constant: -15))

            // UISwitch Constraints
            contentView.addConstraint(NSLayoutConstraint(item: contentView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: switchView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: switchView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 5))
        }
        super.updateConstraints()
    }


    override func setupViews() {

        super.setupViews()

        contentView.addSubview(switchView)

        configureAppearance()

        switchView.addTarget(self, action: #selector(SwitchCell.switchChanged(_:)), for: .valueChanged)
    }

    override func configureAppearance() {
        super.configureAppearance()
        switchView.tintColor = appearance?.tintColor
        switchView.onTintColor = appearance?.tintColor
    }

    func load(_ item: Switch) {
        super.load(item)
        self.item = item
        DispatchQueue.main.async(execute: {
            self.switchView.setOn(item.value as Bool, animated: false)
        })
        setNeedsUpdateConstraints()
    }

    func switchChanged(_ sender: AnyObject) {
        item.value = switchView.isOn
    }
}
