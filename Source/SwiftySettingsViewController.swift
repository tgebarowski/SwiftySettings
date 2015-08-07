//
//  SwiftySettingsSplitViewController.swift
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

public class SwiftySettingsViewController : UISplitViewController {

    @IBOutlet public weak var defaultEmptyDetailViewController: UIViewController!
    @IBInspectable public var viewBackgroundColor: UIColor? = UIColor.swiftySettingsDefaultHeaderGray()
    @IBInspectable public var cellBackgroundColor: UIColor? = UIColor.whiteColor()
    @IBInspectable public var cellTextColor: UIColor? = UIColor.blackColor()
    @IBInspectable public var cellSecondaryTextColor: UIColor? = UIColor.darkGrayColor()
    @IBInspectable public var tintColor: UIColor? = nil
    @IBInspectable public var separatorColor: UIColor? = UIColor.swiftySettingsDefaultHeaderGray()
    @IBInspectable public var selectionColor: UIColor? = UIColor.lightGrayColor()
    @IBInspectable public var forceRoundedCorners: Bool = false

    public var emptyDetailViewController: UIViewController {
        get {
            if defaultEmptyDetailViewController == nil {
                return UIViewController()
            }
            return defaultEmptyDetailViewController
        }
    }

    public var settings: SwiftySettings! {
        didSet{
            loadMasterWithSettings(settings)
        }
    }

    public convenience init(settings: SwiftySettings) {
        self.init(nibName: nil, bundle: nil)
        self.settings = settings
        initialSetup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        initialSetup()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self;
    }
}

// MARK: - UISplitViewControllerDelegate
extension SwiftySettingsViewController : UISplitViewControllerDelegate {
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }

    public func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        return false
    }
}

// MARK: - Private
private extension SwiftySettingsViewController {
    func initialSetup() {
        let masterNC = UINavigationController()
        masterNC.viewControllers = [SettingsViewController(appearance:  SettingsViewController.Appearance(splitVC: self))]

        let detailNC = UINavigationController()
        detailNC.viewControllers = [emptyDetailViewController]

        viewControllers = [masterNC, detailNC]
    }

    func loadMasterWithSettings(settings: SwiftySettings) {
        if let masterNC = self.viewControllers.first as? UINavigationController,
           let masterSettings = masterNC.visibleViewController as? SettingsViewController {
                masterSettings.load(settings.main)
        }
    }
}