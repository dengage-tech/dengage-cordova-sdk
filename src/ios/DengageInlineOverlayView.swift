import UIKit
import WebKit
import Dengage

@objcMembers
class DengageInlineOverlayView: UIView {

    private let inlineElement: InAppInlineElementView = {
        let configuration = WKWebViewConfiguration()
        let view = InAppInlineElementView(frame: .zero, configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isOpaque = false
        return view
    }()

    private var propertyId: String?
    private var screenName: String?
    private var customParams: [String: String]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        clipsToBounds = true
        addSubview(inlineElement)
        NSLayoutConstraint.activate([
            inlineElement.leadingAnchor.constraint(equalTo: leadingAnchor),
            inlineElement.trailingAnchor.constraint(equalTo: trailingAnchor),
            inlineElement.topAnchor.constraint(equalTo: topAnchor),
            inlineElement.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(bounds: CGRect, propertyId: String, screenName: String, customParams: [String: String]?) {
        self.frame = bounds
        self.propertyId = propertyId
        self.screenName = screenName
        self.customParams = customParams
        layer.zPosition = 9999
        renderInline()
    }

    private func renderInline() {
        guard let propertyId = propertyId, let screenName = screenName else {
            return
        }

        Dengage.showInAppInLine(
            propertyID: propertyId,
            inAppInlineElement: inlineElement,
            screenName: screenName,
            customParams: customParams,
            hideIfNotFound: false
        )
    }
}

