//
//  SettingsCell.swift
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

class SettingsCell : UITableViewCell {

    let spacing: CGFloat = 10
    let height: CGFloat = 44
    var inset: CGFloat = 0
    var appearance: SettingsViewController.Appearance?
    var leftTitleConstraint: NSLayoutConstraint!
    var didSetupConstraints = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }

    override func updateConstraints() {
        /* Assure that titleLabel and iconView are present and added to contentView */
        guard let titleLabel = textLabel where textLabel?.superview != nil,
              let iconView = imageView where imageView?.superview != nil
        else {
            super.updateConstraints()
            return
        }

        if !didSetupConstraints {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            iconView.translatesAutoresizingMaskIntoConstraints = false

            // Icon UIImageView - Constraints
            contentView.addConstraints(
                // Height Constraint,
                [NSLayoutConstraint(item: contentView,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1.0,
                    constant: height),
                // Vertical Constraint
                NSLayoutConstraint(item: iconView,
                                    attribute: .CenterY,
                                    relatedBy: .Equal,
                                    toItem: contentView,
                                    attribute: .CenterY,
                                    multiplier: 1.0,
                                    constant: 0),
                // Horizontal Constraint
                NSLayoutConstraint(item: iconView,
                                   attribute: .Leading,
                                   relatedBy: .Equal,
                                   toItem: contentView,
                                   attribute: .Leading,
                                   multiplier: 1.0,
                                   constant: spacing)
                ])

            // Title UILabel - Horizontal Constraint
            leftTitleConstraint = NSLayoutConstraint(item: titleLabel,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .Leading,
                multiplier: 1.0,
                constant: spacing)

            // Title UILabel - Vertical Constraint
            contentView.addConstraints(
                [NSLayoutConstraint(item: titleLabel,
                                    attribute: .CenterY,
                                    relatedBy: .Equal,
                                    toItem: contentView,
                                    attribute: .CenterY,
                                    multiplier: 1.0,
                                    constant: 0),
                    leftTitleConstraint
                ])

            contentView.addConstraint(leftTitleConstraint)
            didSetupConstraints = true
        }

        leftTitleConstraint.constant = iconView.frame.width + spacing

        super.updateConstraints()
    }

    override var frame:CGRect {
        set {
            var f = newValue
            f.origin.x += inset;
            f.size.width -= 2 * inset;
            super.frame = f
        }
        get {
            return super.frame
        }
    }

    func setupViews() {

    }

    func load(item: TitledNode) {

        configureAppearance()

        textLabel?.text = item.title

        if (item as? Screen != nil) {
            accessoryType = .DisclosureIndicator;
        }
        if let image = item.icon {
            imageView?.image = image
        }
        setNeedsUpdateConstraints()
    }

    func configureAppearance() {

        textLabel?.textColor = appearance?.cellTextColor
        contentView.backgroundColor = appearance?.cellBackgroundColor
        backgroundColor = appearance?.cellBackgroundColor
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = appearance?.selectionColor
    }
}