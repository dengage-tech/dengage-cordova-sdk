import UIKit
import Dengage

@objcMembers
class DengageAppStoryOverlayView: UIView {

    private let storyContainer = UIView()
    private var storyPropertyId: String?
    private var storyScreenName: String?
    private var storyCustomParams: [String: String]?

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
        storyContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(storyContainer)
        NSLayoutConstraint.activate([
            storyContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            storyContainer.topAnchor.constraint(equalTo: topAnchor),
            storyContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(bounds: CGRect, propertyId: String, screenName: String, customParams: [String: String]?) {
        frame = bounds
        storyPropertyId = propertyId
        storyScreenName = screenName
        storyCustomParams = customParams
        layer.zPosition = 9999
        renderStories()
    }

    private func renderStories() {
        guard let propertyId = storyPropertyId, let screenName = storyScreenName else {
            return
        }

        if let existing = storyContainer.subviews.first {
            existing.removeFromSuperview()
        }

        Dengage.showAppStory(storyPropertyID: propertyId, screenName: screenName, customParams: storyCustomParams) { [weak self] storiesView in
            guard let self = self, let storiesView = storiesView else {
                return
            }
            storiesView.translatesAutoresizingMaskIntoConstraints = false
            self.storyContainer.addSubview(storiesView)
            NSLayoutConstraint.activate([
                storiesView.leadingAnchor.constraint(equalTo: self.storyContainer.leadingAnchor),
                storiesView.trailingAnchor.constraint(equalTo: self.storyContainer.trailingAnchor),
                storiesView.topAnchor.constraint(equalTo: self.storyContainer.topAnchor),
                storiesView.bottomAnchor.constraint(equalTo: self.storyContainer.bottomAnchor)
            ])
        }
    }
}




