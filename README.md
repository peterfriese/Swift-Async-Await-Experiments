<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Discussions][discussions-shield]][discussions-url]
[![Feature Requests][featurerequest-shield]][featurerequest-url]
[![License][license-shield]][license-url]

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
The code in this repository makes use of the experimental Swift compiler toolchain.

* Xcode 12.3 or later
* Swift Compiler Toolchain (Jan 04, 2021 or later)

<!-- GETTING STARTED -->
## Getting Started

To compile and run the code, make sure to follow these steps:

1. Download the experimental Swift compiler toolchain from the [Snapshots/main](https://swift.org/download/#snapshots) section on the downloads page (I use the [Feb 02 2021 development snapshot](https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2021-02-02-a/swift-DEVELOPMENT-SNAPSHOT-2021-02-02-a-osx.pkg))
2. Install the toolchain by double-clicking the package
3. Activate the toolchain in Xcode (via _Settings > Components > Toolchains_)

In case you're stuck, Apple has detailed instructions [over here](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/AlternativeToolchains.html).

Please note that (for a reason I don't yet understand), it's not possible to debug your code using the experimental toolchain. If you run your code and you get an error message saying LLDB couldn't attach to your process or similar, _turn off_ debugging:

* Edit your launch scheme
* Navigate into the _Run_ section
* Make sure _Info > Debug executable_ is unchecked

Unfortunately, you can only select the toolchain on a global level, so keep in mind to select the built-in toolchain when you're done playing around with the code in this repository and want to go back working on your own app!

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