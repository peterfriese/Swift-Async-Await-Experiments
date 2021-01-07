# Swift-Async-Await-Experiments

Experiments with Swift's new async/await feature (SE 0296)

## Requirements
The code in this repository makes use of the experimental Swift compiler toolchain.

* Xcode 12.3
* Swift Compiler Toolchain (Jan 04, 2021)

To compile and run the code, make sure to follow these steps:

1. Download the experimental Swift compiler toolchain from the [Snapshots/main](https://swift.org/download/#snapshots) section on the downloads page (I use the [Jan 04 2021 development snapshot](https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2021-01-04-a/swift-DEVELOPMENT-SNAPSHOT-2021-01-04-a-osx.pkg))
2. Install the toolchain by double-clicking the package
3. Activate the toolchain in Xcode (via _Settings > Components > Toolchains_)

In case you're stuck, Apple has detailed instructions [over here](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/AlternativeToolchains.html).

Please note that (for a reason I don't yet understand), it's not possible to debug your code using the experimental toolchain. If you run your code and you get an error message saying LLDB couldn't attach to your process or similar, _turn off_ debugging:

* Edit your launch scheme
* Navigate into the _Run_ section
* Make sure _Info > Debug executable_ is unchecked

Unfortunately, you can only select the toolchain on a global level, so keep in mind to select the built-in toolchain when you're done playing around with the code in this repository and want to go back working on your own app!