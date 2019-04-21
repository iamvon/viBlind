# Emoji Map 😎
> Map Strings to emojis

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Emoji Map is a lightweight library to map Strings to Emojis, similar to the prediction of iOS Keyboard. Currently working for English, Spanish, German and French.

![](header.png)

## 👩‍🚀 Features

- [x] Transform String into an Emoji
- [x] Get several Emoji matches for each word
- [x] Input paragraphs and get an array of Emojis


## 👩‍🎓 Requirements

- iOS 11.0+
- Xcode 8+

## 🔧 Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `EmojiMap` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'Emojimap'
```

#### Manually
1. Download and drop ```EmojiMap.swift``` in your project.
2. Download and drop ```emojis-es.json```, ```emojis-en.json```, ```emojis-fr.json```, ```emojis-de.json``` in your project.
2. Congratulations!  

## 🚀 Usage example

```swift
let mapping = EmojiMap()
for match in mapping.getMatchesFor("Dog Elephant Apple") {
    print(match.emoji)
}

// "🐶 🐾 🐩 🐘 🍎 📱"
```

## 🤗 Contribute

We would love you to contribute to **EmojiMap**, check the ``LICENSE`` file for more info.

## 🙌 Credits

Emoji keyword library is based on [emojilib](https://github.com/muan/emojilib).

## 📞 Meta

Matias Villaverde – [@matiasverdee](https://twitter.com/matiasverdee) – contact@matiasvillaverde.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/matiasvillaverde/emojimap](https://github.com/matiasvillaverde/emojimap)

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
