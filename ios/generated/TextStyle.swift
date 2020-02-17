import Foundation
import UIKit

public class TextStyle {
  public let family: String?
  public let name: String?
  public let weight: UIFont.Weight
  public let size: CGFloat
  public let lineHeight: CGFloat?
  public let kerning: Double
  public let color: UIColor?
  public let alignment: NSTextAlignment

  public init(
    family: String? = nil,
    name: String? = nil,
    weight: UIFont.Weight = UIFont.Weight.regular,
    size: CGFloat = UIFont.systemFontSize,
    lineHeight: CGFloat? = nil,
    kerning: Double = 0,
    color: UIColor? = nil,
    alignment: NSTextAlignment = .left) {
    self.family = family
    self.name = name
    self.weight = weight
    self.size = size
    self.lineHeight = lineHeight
    self.kerning = kerning
    self.color = color
    self.alignment = alignment
  }

  public func with(
    family: String? = nil,
    name: String? = nil,
    weight: UIFont.Weight? = nil,
    size: CGFloat? = nil,
    lineHeight: CGFloat? = nil,
    kerning: Double? = nil,
    color: UIColor? = nil,
    alignment: NSTextAlignment? = nil
    ) -> TextStyle {
    return TextStyle(
      family: family ?? self.family,
      name: name ?? self.name,
      weight: weight ?? self.weight,
      size: size ?? self.size,
      lineHeight: lineHeight ?? self.lineHeight,
      kerning: kerning ?? self.kerning,
      color: color ?? self.color,
      alignment: alignment ?? self.alignment)
  }

  public lazy var paragraphStyle: NSMutableParagraphStyle = {
    let paragraphStyle = NSMutableParagraphStyle()
    if let lineHeight = lineHeight {
      paragraphStyle.minimumLineHeight = lineHeight
      paragraphStyle.maximumLineHeight = lineHeight
    }
    paragraphStyle.alignment = alignment
    return paragraphStyle
  }()

  public lazy var uiFontDescriptor: UIFontDescriptor = {
    var attributes: [UIFontDescriptor.AttributeName: Any] = [:]
    var family = self.family

    if family == nil && name == nil {
      family = UIFont.systemFont(ofSize: UIFont.systemFontSize).familyName
    }

    if let family = family {
      attributes[UIFontDescriptor.AttributeName.family] = family
    }

    if let name = name {
      attributes[UIFontDescriptor.AttributeName.name] = name
    }

    attributes[UIFontDescriptor.AttributeName.traits] = [
      UIFontDescriptor.TraitKey.weight: weight
    ]

    return UIFontDescriptor(fontAttributes: attributes)
  }()

  public lazy var uiFont: UIFont = {
    return UIFont(descriptor: uiFontDescriptor, size: size)
  }()

  public lazy var attributeDictionary: [NSAttributedString.Key: Any] = {
    var attributes: [NSAttributedString.Key: Any] = [
      .font: uiFont,
      .kern: kerning,
      .paragraphStyle: paragraphStyle
    ]

    if let lineHeight = lineHeight {
      attributes[.baselineOffset] = (lineHeight - uiFont.ascender + uiFont.descender) / 4
    }

    if let color = color {
      attributes[.foregroundColor] = color
    }

    return attributes
  }()

  public func apply(to string: String) -> NSAttributedString {
    return NSAttributedString(
      string: string,
      attributes: attributeDictionary)
  }

  public func apply(to attributedString: NSAttributedString) -> NSAttributedString {
    let styledString = NSMutableAttributedString(attributedString: attributedString)
    styledString.addAttributes(
      attributeDictionary,
      range: NSRange(location: 0, length: styledString.length))
    return styledString
  }

  public func apply(to attributedString: NSMutableAttributedString, at range: NSRange) {
    attributedString.addAttributes(
      attributeDictionary,
      range: range)
  }
}

// MARK: - Equatable

extension TextStyle: Equatable {
  public static func == (lhs: TextStyle, rhs: TextStyle) -> Bool {
    return (
      lhs.family == rhs.family &&
      lhs.name == rhs.name &&
      lhs.weight == rhs.weight &&
      lhs.size == rhs.size &&
      lhs.lineHeight == rhs.lineHeight &&
      lhs.kerning == rhs.kerning &&
      lhs.color == rhs.color &&
      lhs.alignment == rhs.alignment)
  }
}
