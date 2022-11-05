<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Discussions][discussions-shield]][discussions-url]
[![Feature Requests][featurerequest-shield]][featurerequest-url]
[![License][license-shield]][license-url

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/peterfriese/Swift-Async-Await-Experiments">
    <img src="images/swift-logo-512.png" alt="Logo" width="256" height="256">
  </a>

  <h1 align="center">Swift async/await Experiments</h1>

  <p align="center">
    Experiments with Swift's new async/await feature (SE 0296)
    <br />
    <br />
    <a href="https://github.com/peterfriese/Swift-Async-Await-Experiments/discussions">Join the discussion</a>
    ·
    <a href="https://github.com/peterfriese/Swift-Async-Await-Experiments/issues">Report Bug</a>
    ·
    <a href="https://github.com/peterfriese/Swift-Async-Await-Experiments/issues">Request Feature</a>
  </p>
</p>


<!-- ABOUT THE PROJECT -->
## About The Project

Experiments with Swift's new async/await feature ([SE 0296](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md))

[Here's an article](https://peterfriese.dev/async-await-in-swiftui/) that shows you how to use this feature.

## Requirements
Previous versions of the code in this repository made use of the experimental Swift compiler toolchain. Since WWDC 2021, support for async/await is now available in the default compiler toolchain.

* Xcode 13 or later
* ~~Swift Compiler Toolchain (Jan 04, 2021 or later)~~

<!-- GETTING STARTED -->
<!-- ## Getting Started

To compile and run the code, make sure to follow these steps:

1. Download the experimental Swift compiler toolchain from the [Snapshots/main](https://swift.org/download/#snapshots) section on the downloads page (I use the [May 18 2021 Swft 5.5 development snapshot](https://swift.org/builds/swift-5.5-branch/xcode/swift-5.5-DEVELOPMENT-SNAPSHOT-2021-05-18-a/swift-5.5-DEVELOPMENT-SNAPSHOT-2021-05-18-a-osx.pkg))
2. Install the toolchain by double-clicking the package
3. Activate the toolchain in Xcode (via _Settings > Components > Toolchains_)

In case you're stuck, Apple has detailed instructions [over here](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/AlternativeToolchains.html).

Please note that (for a reason I don't yet understand), it's not possible to debug your code using the experimental toolchain. If you run your code and you get an error message saying LLDB couldn't attach to your process or similar, _turn off_ debugging:

* Edit your launch scheme
* Navigate into the _Run_ section
* Make sure _Info > Debug executable_ is unchecked

Unfortunately, you can only select the toolchain on a global level, so keep in mind to select the built-in toolchain when you're done playing around with the code in this repository and want to go back working on your own app! -->

## Breaking changes

As this is still in development, there will be changes. I updated the code to reflect those changes, and wouldn't be surprised to see further breaking changes before a final release is cut. If you run into any issues, feel free to open an issue on this repo (or even better - send a PR if you've got time time to build a solution).

### 2022-11-05
* Updated the code to use `Task { }` instead of `async { }`

### 2021-08-06 (WWDC 21)
* Xcode 13 now contains Swift 5.5, we no longer need to download the experimental compiler toolchain
* [According to the Swift team](https://twitter.com/AirspeedSwift/status/1401992834194952200), the correct way to launch an async task from with in SwiftUI is `async { }` (in beta 1) or `Task { }` (after beta 1).

### 2021-05-25

The Swift Development team has been making a couple of breaking changes (after all, this is still pre-release software):
* `@asyncHandler` has been removed from the language (see [PR #37415](https://github.com/apple/swift/pull/37415)). According to [this discussion](https://forums.swift.org/t/new-concurrency-api-not-available-in-latest-toolchain/47389/2), we can wrap asynchronous code in a call to `detach { }` as an alternative. As of yet, it is unclear what if there will be a replacement for `@asyncHandler`.
* Since Swift can now be shipped with the OS, all new features in the Swift standard library will need to have an availability annotation. To be able to mark new APIs as available for unreleased versions of future versions of the OS, a special case of `9999` has been introduced. This also means that all code using those new APIs will need to use availability flags as well. For details, see [this discussion on the Swift forums](https://forums.swift.org/t/availability-and-the-standard-library/20932).

<!-- LICENSE -->
## License

Distributed under the Apache 2 License. See `LICENSE` for more information.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/peterfriese/Swift-Async-Await-Experiments.svg?style=flat-square
[contributors-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/peterfriese/Swift-Async-Await-Experiments.svg?style=flat-square
[forks-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/network/members
[stars-shield]: https://img.shields.io/github/stars/peterfriese/Swift-Async-Await-Experiments.svg?style=flat-square
[stars-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/stargazers
[issues-shield]: https://img.shields.io/github/issues/peterfriese/Swift-Async-Await-Experiments.svg?style=flat-square
[issues-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/issues
[license-shield]: https://img.shields.io/github/license/peterfriese/Swift-Async-Await-Experiments.svg?style=flat-square
[license-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/blob/master/LICENSE.txt

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/peterfriese
[product-screenshot]: images/screenshot.png

[swift-shield]: https://img.shields.io/badge/swift-5.4_trunk-FA7343?logo=swift&color=FA7343&style=flat-square
[swift-url]: https://swift.org

[xcode-shield]: https://img.shields.io/badge/xcode-12.5_beta-1575F9?logo=Xcode&style=flat-square
[xcode-url]: https://developer.apple.com/xcode/

[featurerequest-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/issues/new?assignees=&labels=type%3A+feature+request&template=feature_request.md
[featurerequest-shield]: https://img.shields.io/github/issues/peterfriese/Swift-Async-Await-Experiments/feature-request?logo=github&style=flat-square
[discussions-url]: https://github.com/peterfriese/Swift-Async-Await-Experiments/discussions
[discussions-shield]: https://img.shields.io/badge/discussions-brightgreen?logo=github&style=flat-square