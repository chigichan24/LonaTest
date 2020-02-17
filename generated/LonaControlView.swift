import UIKit

// MARK: - LonaControl

protocol LonaControl {}

// MARK: - LonaControlView

public class LonaControlView: UIControl, LonaControl {

  var onHighlight: (() -> Void)?

  var onAccessibilityActivate: (() -> Void)?

  var showsHighlight: Bool {
    return isControlPressed || isHighlighted
  }

  public var isControlPressed = false {
    didSet {
      onHighlight?()
    }
  }

  public override var isHighlighted: Bool {
    didSet {
      onHighlight?()
    }
  }

  public override func accessibilityActivate() -> Bool {
    if let onAccessibilityActivate = onAccessibilityActivate {
      onAccessibilityActivate()
      return true
    }

    return false
  }
}
