//
//  ExampleSettingsController.swift
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

import UIKit
import SwiftyUserDefaults
import SwiftySettings

class Storage : SettingsStorageType {
    
    subscript(key: String) -> Bool? {
        get {
            return Defaults[key].bool
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Float? {
        get {
            return Float(Defaults[key].doubleValue)
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Int? {
        get {
            return Defaults[key].int
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> String? {
        get {
            return Defaults[key].string
        }
        set {
            Defaults[key] = newValue
        }
    }
}

class ExampleSettingsController: SwiftySettingsViewController {

    var storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettingsTopDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Method 1
    func loadSettingsTopDown() {
        /* Top Down settings */
        settings = SwiftySettings(storage: storage, title: "Intelligent Home") {
            [Section(title: "Electricity") {
                [OptionsButton(key: "tariff", title: "Tariff") {
                    [Option(title: "Day", optionId: 1),
                     Option(title: "Night", optionId: 2),
                     Option(title: "Mixed", optionId: 3)]
                    },
                Switch(key: "light-central", title: "Central Switch", icon: UIImage(named: "settings-light")),
                Screen(title: "Livingroom") {
                    [Section(title: "Lights") {
                        [Switch(key: "light1", title: "Light 1"),
                         Switch(key: "light2", title: "Light 2"),
                         Slider(key: "brightness-1", title: "Brightness",
                                minimumValueImage: UIImage(named: "slider-darker"),
                                maximumValueImage: UIImage(named: "slider-brighter"),
                                minimumValue: 0,
                                maximumValue: 100)]
                    }]
                },
                Screen(title: "Bedroom") {
                    [Section(title: "Lights", footer: "Manage lights in your bedroom") {
                        [Switch(key: "light3", title: "Light 1"),
                         Switch(key: "light4", title: "Light 2"),
                         Slider(key: "brightness-2", title: "Brightness")]
                    }]
                }]
            },
            OptionsSection(key: "alarm-status", title: "Alarm") {
                [Option(title: "Armed", optionId: 1),
                 Option(title: "Only ground floor", optionId: 2),
                 Option(title: "Disarmed", optionId: 3)]
            },
            Section(title: "Administrator") {
                [TextField(key: "password", title: "Password", secureTextEntry: true)]
            }]
        }
    }

    // Method 2
    func loadSettingsBottomUp() {

        let lightsSection1 = Section(title: "Lights")
        lightsSection1.with(Switch(key: "light1", title: "Light 1"))
                      .with(Switch(key: "light2", title: "Light 2"))
                      .with(Slider(key: "brightness-1", title: "Brightness",
                                  minimumValueImage: UIImage(named: "slider-darker"),
                                  maximumValueImage: UIImage(named: "slider-brighter"),
                                  minimumValue: 0,
                                  maximumValue: 100))

        let livingroomScreen = Screen(title: "Livingroom")
        livingroomScreen.include(section: lightsSection1)

        let lightsSection2 = Section(title: "Lights", footer: "Manage lights in your bedrom")
        lightsSection2.with(Switch(key: "light3", title: "Light 1"))
                      .with(Switch(key: "light4", title: "Light 2"))
                      .with(Slider(key: "brightness-2", title: "Brightness"))

        let bedromScreen = Screen(title: "Bedrom")
        bedromScreen.include(section: lightsSection2)

        let tariffOption = OptionsButton(key: "tariff",
                                         title: "Tariff",
                                         icon: UIImage(named: "slider-brighter"))
        tariffOption.with(option: Option(title: "Day", optionId: 1))
                    .with(option: Option(title: "Night", optionId: 2))
                    .with(option: Option(title: "Mixed", optionId: 3))


        let alarmSection = OptionsSection(key: "alarm-status", title: "Alarm")
        alarmSection.with(Option(title: "Armed", optionId: 1))
        alarmSection.with(Option(title: "Only ground floor", optionId: 2))
        alarmSection.with(Option(title: "Disarmed", optionId: 3))

        let electricitySection = Section(title: "Electricity")
        electricitySection.with(tariffOption)
        electricitySection.with(Switch(key: "light-central",
                                       title: "Central Switch",
                                       icon:UIImage(named: "settings-light")))
                          .with(livingroomScreen)
                          .with(bedromScreen)

        let mainScreen = Screen(title: "Intelligent Home")
        mainScreen.include(section: electricitySection)
        mainScreen.include(section: alarmSection)

        settings = SwiftySettings(storage: storage, main: mainScreen)
    }
}

