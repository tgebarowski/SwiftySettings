//
//  SwiftySettingsViewController.swift
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

class SettingsViewController : UITableViewController {

    struct Appearance {
        let viewBackgroundColor: UIColor?
        let cellBackgroundColor: UIColor?
        let cellTextColor: UIColor?
        let cellSecondaryTextColor: UIColor?
        let tintColor: UIColor?
        let separatorColor: UIColor?
        let selectionColor: UIColor?
        let forceRoundedCorners: Bool

        init (splitVC: SwiftySettingsViewController) {
            self.viewBackgroundColor = splitVC.viewBackgroundColor
            self.cellBackgroundColor = splitVC.cellBackgroundColor
            self.cellTextColor = splitVC.cellTextColor
            self.cellSecondaryTextColor = splitVC.cellSecondaryTextColor
            self.tintColor = splitVC.tintColor
            self.separatorColor = splitVC.separatorColor
            self.selectionColor = splitVC.selectionColor
            self.forceRoundedCorners = splitVC.forceRoundedCorners
        }
    }

    var sections: [Section] = []
    var appearance: Appearance
    var observerTokens: [NSObjectProtocol] = []
    var editingIndexPath: IndexPath? = nil

    var shouldDecorateWithRoundCorners: Bool {

        if appearance.forceRoundedCorners {
            return true
        }

        if let masterNC = self.splitViewController?.viewControllers.first as? UINavigationController {
            return !(masterNC.viewControllers.last == self)
        }
        return false
    }

    init (appearance: Appearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        observerTokens.removeAll()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupKeyboardHandling()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func load(_ screen: Screen) {
        self.sections = screen.sections
        self.title = screen.title
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource

extension SettingsViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = sections[indexPath.section].items[indexPath.row]

        switch (node) {
        case let item as Switch:
            let cell = tableView.dequeueReusableCell(SwitchCell.self, type: .cell)
            cell.appearance = appearance
            cell.load(item)
            return cell
        case let item as Slider:
            let cell = tableView.dequeueReusableCell(SliderCell.self, type: .cell)
            cell.appearance = appearance
            cell.load(item)
            return cell
        case let item as Option:
            let cell = tableView.dequeueReusableCell(OptionCell.self, type: .cell)
            cell.appearance = appearance
            cell.load(item)
            return cell
        case let item as OptionsButton:
            let cell = tableView.dequeueReusableCell(OptionsButtonCell.self, type: .cell)
            cell.appearance = appearance
            cell.load(item)
            return cell
        case let item as Screen:
            let cell = tableView.dequeueReusableCell(SettingsCell.self, type: .cell)
            cell.appearance = appearance
            cell.load(item)
            return cell
        case let item as TextField:
            let cell = tableView.dequeueReusableCell(TextFieldCell.self, type: .cell)
            cell.appearance = appearance
            cell.textFieldDelegate = self
            cell.load(item)
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(SectionHeaderFooter.self, type: .header)
        header.appearance = appearance
        header.load(sections[section].title)
        return header
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerText = sections[section].footer {
            let footer = tableView.dequeueReusableCell(SectionHeaderFooter.self, type: .footer)
            footer.appearance = appearance
            footer.load(footerText)
            return footer
        }
        return nil
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController {

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let node = sections[indexPath.section].items[indexPath.row]

        switch(node) {
        case _ as Screen: fallthrough
        case _ as OptionsButton: fallthrough
        case _ as Option: return true
        default: return false
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 22
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let splitVC = splitViewController as? SwiftySettingsViewController,
                  let masterNC = splitVC.viewControllers.first as? UINavigationController,
                  let detailNC = splitVC.viewControllers.last as? UINavigationController,
                  let masterVC = masterNC.topViewController as? SettingsViewController

        else {
            return
        }


        let node = sections[indexPath.section].items[indexPath.row]

        switch (node) {
        case let item as Screen:
            let vc = SettingsViewController(appearance: appearance)
            let nc = splitVC.isCollapsed ? masterNC: detailNC
            vc.load(item)
            nc.pushViewController(vc, animated: splitVC.isCollapsed)
        case let item as OptionsButton:
            let vc = SettingsViewController(appearance: appearance)
            let nc = splitVC.isCollapsed ? masterNC: detailNC
            let screen = Screen(title: item.title) {
                [Section(title: "") { item.options }]
            }
            vc.load(screen)
            nc.popToRootViewController(animated: false)
            nc.pushViewController(vc, animated: splitVC.isCollapsed)
        case let item as Option:
            item.selected = true
            tableView.reloadData()
            if item.navigateBack {
                let _ = navigationController?.popViewController(animated: true)
                masterVC.tableView.reloadData()
            }

        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {

        func decorateCellWithRoundCorners(_ cell: UITableViewCell,
                                          roundingCorners corners: UIRectCorner) {
            let maskPath = UIBezierPath(roundedRect: cell.bounds,
                byRoundingCorners:  corners ,
                cornerRadii: CGSize(width: 5.0, height: 5.0))
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = cell.bounds
            shapeLayer.path = maskPath.cgPath
            cell.layer.mask = shapeLayer
            cell.clipsToBounds = true
        }

        if shouldDecorateWithRoundCorners {
            let itemCount = sections[indexPath.section].items.count

            if itemCount == 1 {
                decorateCellWithRoundCorners(cell, roundingCorners: [.allCorners])
            } else if indexPath.row == 0 {
                decorateCellWithRoundCorners(cell, roundingCorners: [.topLeft, .topRight])
            } else if indexPath.row == itemCount - 1 {
                decorateCellWithRoundCorners(cell, roundingCorners: [.bottomLeft, .bottomRight])
            }

            if let settingsCell = cell as? SettingsCell {
                settingsCell.inset = 20
            }
        }
    }
}

// MARK: Keyboard handling

extension SettingsViewController : UITextFieldDelegate {

    func setupKeyboardHandling() {

        let nc = NotificationCenter.default

        observerTokens.append(nc.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil,
            queue: OperationQueue.main) { [weak self] note in

                guard let userInfo = note.userInfo as? [String: AnyObject],
                    let keyboardRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
                else {
                        fatalError("Could not extract keyboard CGRect")
                }
                var contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                    bottom: keyboardRect.size.height, right: 0.0)

                if (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)) {
                    contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardRect.size.height), 0.0);
                }
                self?.tableView.contentInset = contentInsets;
                self?.tableView.scrollIndicatorInsets = contentInsets;

                if let scrollToIndexPath = self?.editingIndexPath {
                    self?.tableView.scrollToRow(at: scrollToIndexPath,
                        at: .middle,
                        animated:false)
                }
            })
        observerTokens.append(nc.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil,
            queue: OperationQueue.main) { [weak self] note in
                self?.tableView.contentInset = UIEdgeInsets.zero;
                self?.tableView.scrollIndicatorInsets = UIEdgeInsets.zero;
            })
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = self.tableView.convert(textField.bounds.origin, from:textField)
        self.editingIndexPath = self.tableView.indexPathForRow(at: point)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



//MARK: Private

private extension SettingsViewController {

    func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 22
        tableView.rowHeight = UITableViewAutomaticDimension

        // Configure appearance
        tableView.backgroundColor = appearance.viewBackgroundColor
        tableView.separatorColor = appearance.separatorColor;

        tableView.registerClass(SwitchCell.self, type: .cell)
        tableView.registerClass(SliderCell.self, type: .cell)
        tableView.registerClass(OptionCell.self, type: .cell)
        tableView.registerClass(OptionsButtonCell.self, type: .cell)
        tableView.registerClass(SettingsCell.self, type: .cell)
        tableView.registerClass(TextFieldCell.self, type: .cell)
        tableView.registerClass(SectionHeaderFooter.self, type: .header)
        tableView.registerClass(SectionHeaderFooter.self, type: .footer)
    }
}
