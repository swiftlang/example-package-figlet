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

/// A FIGlet font, parsed from the contents of a `.flf` file.
///
/// For a description of the file format, see http://www.jave.de/docs/figfont.txt
struct Font {
    /// The number of lines in each glyph.
    let height: Int

    /// The lines that make up each character's glyph, from top to bottom.
    let glyphs: [Character: [String]]

    init(_ content: String) {
        var lines = content.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)[...]

        // The header looks like `flf2a$ 6 5 16 15 11 0 24463`. The character after `flf2a` is
        // the hard blank, which glyphs use in place of spaces. The second and sixth fields are
        // the height of each glyph and the number of comment lines that follow the header.
        let header = lines.removeFirst().split(separator: " ")
        let hardBlank = header[0].last!
        let height = Int(header[1])!
        lines.removeFirst(Int(header[5])!)

        // Each line of a glyph ends with an end mark, usually `@`, which is doubled on the last line.
        func nextGlyph() -> [String] {
            let rows = lines.prefix(height)
            lines.removeFirst(height)
            return rows.enumerated().map { row, line in
                let endMarkCount = row == height - 1 ? 2 : 1
                return String(line.dropLast(endMarkCount).map { $0 == hardBlank ? " " : $0 })
            }
        }

        var glyphs = [Character: [String]]()

        // Glyphs for printable ASCII and seven German characters come first, in a fixed order.
        let requiredCodes: [UInt8] = Array(32...126) + [196, 214, 220, 228, 246, 252, 223]
        for code in requiredCodes {
            glyphs[Character(Unicode.Scalar(code))] = nextGlyph()
        }

        // Each remaining glyph follows a line that starts with its character code, in decimal
        // or hexadecimal: for example, `160  NO-BREAK SPACE` or `0x0100  LATIN CAPITAL LETTER A WITH MACRON`.
        while let tag = lines.first?.split(separator: " ").first {
            lines.removeFirst()
            let code = tag.hasPrefix("0x") ? UInt32(tag.dropFirst(2), radix: 16) : UInt32(tag)
            let glyph = nextGlyph()
            if let code, let scalar = Unicode.Scalar(code) {
                glyphs[Character(scalar)] = glyph
            }
        }

        self.height = height
        self.glyphs = glyphs
    }
}
