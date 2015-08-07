//
//  SettingsOptionButtonCell.swift
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

class OptionsButtonCell : SettingsCell {

    let selectedOptionLabel = UILabel()

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

            selectedOptionLabel.translatesAutoresizingMaskIntoConstraints = false

            contentView.addConstraints([
                // Spacing Between Title and Selected UILabel
                NSLayoutConstraint(item: selectedOptionLabel,
                                   attribute: .Left,
                                   relatedBy: .GreaterThanOrEqual,
                                   toItem: textLabel!,
                                   attribute: .Right,
                                   multiplier: 1.0,
                                   constant: 15),
                // Selected Option UILabel - Horizontal Constraints
                NSLayoutConstraint(item: contentView,
                                    attribute: .Trailing,
                                    relatedBy: .Equal,
                                    toItem: selectedOptionLabel,
                                    attribute: .Trailing,
                                    multiplier: 1.0,
                                    constant: 5),
                // Selected Option UILabel - Vertical Constraints
                NSLayoutConstraint(item: contentView,
                                   attribute: .CenterY,
                                   relatedBy: .Equal,
                                   toItem: selectedOptionLabel,
                                   attribute: .CenterY,
                                   multiplier: 1.0,
                                   constant: 0)
                ])
        }
        super.updateConstraints()
    }

    override func setupViews() {
        super.setupViews()

        textLabel?.setContentHuggingPriority(UILayoutPriorityDefaultHigh,
            forAxis: .Horizontal)
        selectedOptionLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh,
            forAxis: .Horizontal)

        contentView.addSubview(selectedOptionLabel)
    }

    override func configureAppearance() {
        super.configureAppearance()
        textLabel?.textColor = appearance?.cellTextColor
        selectedOptionLabel.textColor = appearance?.cellSecondaryTextColor
        contentView.backgroundColor = appearance?.cellBackgroundColor
        accessoryView?.backgroundColor = appearance?.cellBackgroundColor
    }

    func load(item: OptionsButton) {
        self.textLabel?.text = item.title
        self.selectedOptionLabel.text = item.selectedOptionTitle
        self.accessoryType = .DisclosureIndicator

        if let image = item.icon {
            self.imageView?.image = image
        }
        configureAppearance()
        setNeedsUpdateConstraints()
    }
}