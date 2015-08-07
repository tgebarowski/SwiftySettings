//
//  SwiftySettingsTests.swift
//
//
//  SwiftySettings
//  Created by Tomasz Gebarowski on 24/08/15.
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
import Quick
import Nimble

@testable import SwiftySettings


class SwiftySettingsTests: QuickSpec {
    override func spec() {
        var settings: SwiftySettings!

        describe("SwiftySettings") {

            beforeEach {
                settings = SwiftySettings(storage: StorageStub(), title: "Title") {
                    [Section(title: "Section 1") {
                        [Switch(key: "key1", title: "Title 1"),
                         Slider(key: "key2", title: "Title 2")]
                    },
                    OptionsSection(key: "key3", title: "Section 2") {
                        [Option(title: "Option 1", optionId: 0),
                         Option(title: "Option 2", optionId: 1)]
                    },
                    Section(title: "Section 3") {
                        [OptionsButton(key: "key4", title: "Options Button") {
                            [Option(title: "Option 1", optionId: 0),
                             Option(title: "Option 2", optionId: 1)]
                        }]
                    }
                    ]
                }
            }

            it("should store changed Switch value") {
                let s = settings.main.sections[0].items[0] as! Switch
                s.value = true
                expect(settings.storage["key1"]).to(beTrue())
            }

            it("should store changed Slider value") {
                let magicNumber: Float = 98.9
                let s = settings.main.sections[0].items[1] as! Slider
                s.value = magicNumber
                expect(settings.storage["key2"]).to(equal(magicNumber))
            }

            it("should store changed Option from OptionsSection") {
                let optionId = 1
                let s = settings.main.sections[1].items[optionId] as! Option
                s.selected = true
                expect(settings.storage["key3"]).to(equal(optionId))
            }

            it("should store changed Option from OptionsButton") {
                let optionId = 1
                let button = settings.main.sections[2].items[0] as! OptionsButton

                let buttonToSelect = button.options.filter {
                    $0.optionId == optionId
                }.first

                buttonToSelect!.selected = true
                expect(settings.storage["key4"]).to(equal(optionId))
            }
        }
    }
}