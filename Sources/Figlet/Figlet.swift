//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===--------------------------------------------------------------------

public struct Figlet {
    /// The standard FIGlet font, embedded in the binary at build time.
    private static let font = Font(String(decoding: PackageResources.standard_flf, as: UTF8.self))

    /// Renders text as ASCII art using the standard FIGlet font.
    ///
    /// Characters that the font doesn't include are skipped.
    /// - Parameter text: The text to render.
    /// - Returns: The rendered text, with lines separated by newlines.
    public static func render(_ text: String) -> String {
        (0..<font.height)
            .map { row in text.compactMap { character in font.glyphs[character]?[row] }.joined() }
            .joined(separator: "\n")
    }

    /// Prints text as ASCII art using the standard FIGlet font.
    /// - Parameter text: The text to print.
    public static func say(_ text: String) {
        print(render(text))
    }
}
