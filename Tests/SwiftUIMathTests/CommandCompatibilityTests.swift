import SwiftUI
import Testing

@_spi(Textual) import SwiftUIMath

struct CommandCompatibilityTests {
  private let font = Math.Font(name: .latinModern, size: 20)

  @Test
  func legacyCommandsDoNotCollapseToZeroBounds() {
    let expressions: [String] = [
      #"\boxed{(-a) \times (-b) = ab \quad (a,b > 0)}"#,
      #"\therefore \quad \boxed{0.999\ldots = 1}"#,
      #"\begin{aligned}10x &= 9.999\ldots \\ -\quad x &= 0.999\ldots \\ \hline 9x &= 9\end{aligned}"#,
      #"S = \frac{a}{1-r} = \frac{\frac{9}{10}}{1-\frac{1}{10}} = \frac{\frac{9}{10}}{\frac{9}{10}} = \boxed{1}"#,
      #"|S|"#,
      #"\operatorname{Span}(S)"#,
    ]

    for latex in expressions {
      let bounds = Math.typographicBounds(
        for: latex,
        fitting: ProposedViewSize(width: 400, height: nil),
        font: font,
        style: .display
      )

      #expect(bounds.width > 0)
      #expect(bounds.ascent + bounds.descent > 0)
    }
  }
}
