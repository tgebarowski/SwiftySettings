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

open class SwiftySettingsViewController : UISplitViewController {

    @IBOutlet open weak var defaultEmptyDetailViewController: UIViewController!
    @IBInspectable open var viewBackgroundColor: UIColor? = UIColor.swiftySettingsDefaultHeaderGray()
    @IBInspectable open var cellBackgroundColor: UIColor? = UIColor.white
    @IBInspectable open var cellTextColor: UIColor? = UIColor.black
    @IBInspectable open var cellSecondaryTextColor: UIColor? = UIColor.darkGray
    @IBInspectable open var tintColor: UIColor? = nil
    @IBInspectable open var separatorColor: UIColor? = UIColor.swiftySettingsDefaultHeaderGray()
    @IBInspectable open var selectionColor: UIColor? = UIColor.lightGray
    @IBInspectable open var forceRoundedCorners: Bool = false

    open var emptyDetailViewController: UIViewController {
        get {
            if defaultEmptyDetailViewController == nil {
                return UIViewController()
            }
            return defaultEmptyDetailViewController
        }
    }

    open var settings: SwiftySettings! {
        didSet{
            loadMasterWithSettings(settings)
        }
    }

    public convenience init(settings: SwiftySettings) {
        self.init(nibName: nil, bundle: nil)
        self.settings = settings
        initialSetup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        initialSetup()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self;
    }
}

// MARK: - UISplitViewControllerDelegate
extension SwiftySettingsViewController : UISplitViewControllerDelegate {
    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    public func splitViewController(_ svc: UISplitViewController, shouldHide vc: UIViewController, in orientation: UIInterfaceOrientation) -> Bool {
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

    func loadMasterWithSettings(_ settings: SwiftySettings) {
        if let masterNC = self.viewControllers.first as? UINavigationController,
           let masterSettings = masterNC.visibleViewController as? SettingsViewController {
                masterSettings.load(settings.main)
        }
    }
}
