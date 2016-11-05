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

class SliderCell : SettingsCell {

    var item: Slider!
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let sliderView = UISlider()

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

            sliderView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false

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
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: -50),
                ])
            // UISlider
            contentView.addConstraints(
                [NSLayoutConstraint(item: sliderView,
                                    attribute: .width,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .width,
                                    multiplier: 0.9,
                                    constant: 0),
                 NSLayoutConstraint(item: contentView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: sliderView,
                                    attribute: .centerX,
                                    multiplier: 1.0,
                                    constant: 0),
                 NSLayoutConstraint(item: titleLabel,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: sliderView,
                                    attribute: .top,
                                    multiplier: 1.0,
                                    constant: 5),
                 NSLayoutConstraint(item: sliderView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: contentView,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 15)])

            // Value UILabel

            contentView.addConstraints(
                [NSLayoutConstraint(item: contentView,
                                    attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: valueLabel,
                                    attribute: .trailing,
                                    multiplier: 1.0,
                                    constant: 5),
                 NSLayoutConstraint(item: valueLabel,
                                    attribute: .lastBaseline,
                                    relatedBy: .equal,
                                    toItem: titleLabel,
                                    attribute: .lastBaseline,
                                    multiplier: 1.0,
                                    constant: 0)])

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    override func setupViews() {
        super.setupViews()

        contentView.addSubview(sliderView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)

        textLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()

        sliderView.addTarget(self, action: #selector(SliderCell.sliderChanged(_:)),
                             for: .valueChanged)
    }

    override func configureAppearance() {
        super.configureAppearance()

        sliderView.tintColor = appearance?.tintColor
        titleLabel.textColor = appearance?.cellTextColor
        valueLabel.textColor = appearance?.cellTextColor
    }

    func load(_ item: Slider) {
        self.item = item

        if !item.title.isEmpty {
            self.titleLabel.text = item.title
            self.valueLabel.text = String(Int(item.value))
        }
        self.sliderView.minimumValue = item.minimumValue
        self.sliderView.maximumValue = item.maximumValue
        self.sliderView.minimumValueImage = item.minimumValueImage
        self.sliderView.maximumValueImage = item.maximumValueImage
        self.sliderView.setValue(item.value, animated: false)

        self.configureAppearance()
        self.setNeedsUpdateConstraints()
    }

    func sliderChanged(_ sender: AnyObject) {
        item.value = sliderView.value
        DispatchQueue.main.async {
            self.valueLabel.text = String(Int(self.item.value))
        }
    }
}
