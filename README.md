# Swift Example: Getting Started Guide package

An example package to be used as part of Swift's getting started guides, such as [Build a command-line tool](https://swift.org/getting-started/cli-swiftpm/).

The package is not intended to be used outside the context of these guides and does not provide complete or production ready functionality.

## Usage

Add the package as a dependency:

```bash
swift package add-dependency https://github.com/swiftlang/example-package-figlet --from 1.0.0
swift package add-target-dependency Figlet <your-target> --package example-package-figlet
```

Then print or render text as ASCII art:

```swift
import Figlet

Figlet.say("Hello, Swift!")            // prints to standard output
let banner = Figlet.render("Hello!")   // returns the rendered text
```

The package depends only on the Swift standard library, and the font is embedded in the binary at build time, so it works the same on macOS, Linux, and Windows, including in statically linked binaries.

## Credits

This example package uses fonts from http://www.figlet.org
