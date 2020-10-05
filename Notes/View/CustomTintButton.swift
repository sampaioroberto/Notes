import UIKit

final class CustomTintButton: UIButton {
    override func tintColorDidChange() {
        super.tintColorDidChange()
        backgroundColor = tintColor
    }
}
