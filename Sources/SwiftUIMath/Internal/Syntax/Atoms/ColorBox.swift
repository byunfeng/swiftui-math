import Foundation

extension Math {
  final class ColorBox: Atom {
    enum RenderStyle {
      case fill
      case stroke
    }

    var colorString: String
    var innerList: AtomList?
    var renderStyle: RenderStyle

    override var description: String {
      switch renderStyle {
      case .fill:
        return [
          "\\colorbox",
          "{\(colorString)}",
          innerList.map { "{\($0)}" },
        ]
        .compactMap(\.self)
        .joined()
      case .stroke:
        return [
          "\\boxed",
          innerList.map { "{\($0)}" },
        ]
        .compactMap(\.self)
        .joined()
      }
    }

    override var finalized: Math.Atom {
      let finalized = super.finalized

      if let colorBox = finalized as? ColorBox {
        colorBox.innerList = colorBox.innerList?.finalized
      }

      return finalized
    }

    init(_ colorBox: ColorBox) {
      self.colorString = colorBox.colorString
      self.innerList = colorBox.innerList.map { AtomList($0) }
      self.renderStyle = colorBox.renderStyle

      super.init(colorBox)
    }

    init(colorString: String = "", innerList: AtomList? = nil, renderStyle: RenderStyle = .fill) {
      self.colorString = colorString
      self.innerList = innerList
      self.renderStyle = renderStyle
      super.init(type: .colorBox)
    }
  }
}
