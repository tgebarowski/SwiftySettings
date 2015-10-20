# SwiftySettings

SwiftySettings is a Swift library for building and presenting in app settings.
It helps to declare complex settings trees, provides a protocol to store and retrieve data and supports both iPhone and iPad user interface using UISplitViewController.

## Features

- [x] Declarative settings model
- [x] iOS Settings app look & feel
- [x] Seamless integration with storage interfaces (e.g NSUserDefaults)
- [x] Supports various settings types (i.e. switch, slider, single choice)

## Requirements
- Swift 2
- iOS 8.0+ (iPhone and iPad compatible)
- Xcode 7

## TL;DR

Using SwiftySettings you can declare a complex settings tree, map it to user interface and integrate with your persistance layer.
User interface depicted below can be created using following code snippet.

![SwiftySettings Preview](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-Preview.png)

```swift
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
        }
        ]
    }
}
```

## Installation

### CocoaPods

Use CocoaPods 0.36+, which adds support for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftySettings into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'SwiftySettings'
```

## Step by step

### Provide a class implementing SettingsStorageType protocol

In order to load and save settings, a storage class implementing SettingsStorageType protocol has to be defined.

```swift
public protocol SettingsStorageType {

    subscript(key: String) -> Bool? { get set }
    subscript(key: String) -> Float? { get set }
    subscript(key: String) -> Int? { get set }
    subscript(key: String) -> String? { get set }
}
```

### Subclass SwiftySettingsViewController

#### Create a class inheriting from SwiftySettingsViewController

```swift
class ExampleSettingsController: SwiftySettingsViewController {

    var storage = Storage()
    ...
```
#### Create SwiftySettings object and assign it to settings member

```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        settings = SwiftySettings(storage: storage, title: "Main Screen Name") {
                                  [Section(title: "Section Name") {
                                      [Switch(key: "key", title: "Switch",
                                              icon: UIImage(named: "settings-1")]
                                  }
                    })
    }
}
```

Note: The SwiftySettings object is responsible for declaring a tree of settings. The above snippet declares a single UITableViewController titled "Main Screen Name", having section named "Section Name" and one UISwitch setting with title and icon. SwiftySettings object uses Storage object to load and save settings state.

![SwiftySettings Single Screen](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-SingleScreen.png)

## SwiftySettings DSL

SwiftySettings allows to represent a complex, multi level tree of settings. As depicted in the figure below, the root of such a tree is a Screen object.
Screen acts as a container for all settings that are visible on a single UITableView. It is initiated with an array of Section and Option Section elements.
Each Section and Option Section is mapped to UITableView Header or Footer. Section object can include Switch, Slider or Option Button settings, while Option Section includes only Option elements. Additionally Section may include other Screen objects, thus introducing new level of settings navigation.

![SwiftySettings Model](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-Model.png)

## Switch

![SwiftySettings Switch](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-Switch.png)

Switch represents a UITableViewCell with UISwitch, UILabel and optional icon. Switch elements can be only added to Section and may be initialized as follows:

```swift
init(key: String,
     title: String,
     defaultValue: Bool = false,
     icon: UIImage? = nil,
     valueChangedClosure: ValueChanged? = nil)
```

Arguments:

- _key_: Storage key used to loading and saving switch state using SettingsStorageType protocol
- _title_: Text displayed on a UILabel
- _defaultValue_: If not provied by SettingsStorageType, defaultValue used to initialize UISwitch
- _icon_: Optional icon
- _valueChangedClosure_: Closure triggered when UISwitch state is changed

## Slider

![SwiftySettings Slider](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-Slider.png)

Slider represents a UITableViewCell with UISlider, UILabels and optional icon. Slider elements can be only added to Section and may be initialized as follows:

```swift
init(key: String,
     title: String,
     defaultValue: Float = 0,
     icon: UIImage? = nil,
     minimumValueImage: UIImage? = nil,
     maximumValueImage: UIImage? = nil,
     minimumValue: Float = 0,
     maximumValue: Float = 100,
     valueChangedClosure: ValueChanged? = nil)
```

Arguments:

- _key_: Storage key used to loading and saving slider state using SettingsStorageType protocol
- _title_: Text displayed on a UILabel
- _defaultValue_: If not provied by SettingsStorageType, defaultValue used to initialize UISlider
- _icon_: Optional icon
- _minimumValueImage_: Optional icon for minimum value
- _maximumValueImage_: Optional icon for maximum value
- _minimumValue_: UISlider minimum value
- _maximumValue_: UISlider maximum value
- _valueChangedClosure_: Closure triggered when UISlider state is changed

## Options Button

![SwiftySettings Options Button](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-OptionsButton.png)

OptionsButton represents a UITableViewCell with two UILabels, one with settings title, second with currently selected option. When tapping on OptionsButton cell, navigation is moved to new UITableView with Option cells defined as a part of OptionsButton object. If Option is selected navigation moves back to previous view.

Note: OptionButton objects can be added as a children to Section object only.

```swift
init(key: String,
     title: String,
     icon: UIImage? = nil,
     optionsClosure: (() -> [Option])? = nil)
```

Arguments:

- _key_: Storage key used to load and save currently selected Option
- _title_: Title for the OptionsButton cell
- _icon_: Optional icon to be set at the left side of the cell
- _optionsClosure_: Block returning an array of Options from which selection is possible

## TextField

![SwiftySettings TextField](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-TextField.png)

TextField represents a UITableViewCell with UITextField for editable content.

```swift
init(key: String,
     title: String,
     secureTextEntry: Bool = false,
     defaultValue: String = "",
     valueChangedClosure: ValueChanged? = nil)
```

Arguments:

- _key_: Storage key used to load and save currently selected Option
- _title_: Title for the OptionsButton cell
- _secureTextEntry_: Optional flag indicating if TextField has secured content (i.e. password)
- _valueChangedClosure_: Optional closure invoked when value is changed

## Screen

When added to a Section, Screen object will be mapped to UITableViewCell with UILabel set to Screen title.
Upon tapping on such an element, navigation will move to new UITableView represented by Screen object and all its children Section elements will be displayed.

![SwiftySettings Screen](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-ScreenButton.png)

```swift
init(title: String,
     sectionsClosure: (() -> [Section])? = nil)
```

## Section

Section is a SwiftySettings representation of UITableViewHeaderFooter. It can be only added to a Screen object. Each section should include title and optional footer.

```swift
init(title: String,
     footer: String? = nil,
     nodesClosure: (() -> [TitledNode])? = nil)
```


Arguments:

- _title_: Title for the Section with options
- _footer_: Optional text added at the bottom of the section
- _nodesClosure_: Closure returning an array of TitledNodes (Switch, Slider, OptionsButton, Screen)

## Options Section

![SwiftySettings Options Section](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-OptionsSection.png)

OptionsSection is a type of Section that can be added directly to a Screen object. The difference between Section and OptionsSection is that, the latter can contain only Option objects. From the UI perspective, OptionSection represents a UITableView section filled with UITableViewCells with single choice selection options.

```swift
init(key: String,
     title: String,
     nodesClosure: (() -> [Option])? = nil)
```

Arguments:

- _key_: Storage key used to load and save currently selected Option
- _title_: Title for the Section with options
- _optionsClosure_: Block returning an array of Options from which selection is possible

## SwiftySettings object

SwiftySettings is a root object used by SwiftySettingsViewController. It is a starting point when creating settings tree for your app.

```swift
init(storage: SettingsStorageType,
     title: String,
     sectionsClosure: () -> [Section])
```

Arguments:

- _storage_: Object conforming to SettingsStorageType protocol, used for loading and saving options
- _title_: Title used for the first Screen of Settings tree
- _sectionsClosure_: Closure returning Sections for the first Screen of settings


Note: When using SwiftySettings object, the first Screen object is created automatically from title and sectionsClosure. This is for convenience sake, to avoid creating first Screen manually.

## Customization

SwiftySettings appearance can be configured using Interface Builder.

![SwiftySettings Interface Builder](https://github.com/tgebarowski/SwiftySettings/blob/master/doc/SwiftySettings-InterfaceBuilder.png)


## License

SwiftySettings is released under the MIT license. See LICENSE for details.