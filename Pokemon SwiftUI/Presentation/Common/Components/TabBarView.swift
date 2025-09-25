//
//  TabBarView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import XLPagerTabStrip

struct PagerTabStripView: UIViewControllerRepresentable {
    let databaseManager: CouchbaseManager

    func makeUIViewController(context: Context) -> MainPagerViewController {
        return MainPagerViewController(databaseManager: databaseManager)
    }

    func updateUIViewController(_ uiViewController: MainPagerViewController, context: Context) { }
}

class MainPagerViewController: ButtonBarPagerTabStripViewController {
    private let databaseManager: CouchbaseManager

    init(databaseManager: CouchbaseManager) {
        self.databaseManager = databaseManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        configureButtonBarStyle()
        super.viewDidLoad()
    }

    private func createGradientColor() -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(PokemonTheme.primaryBlue).cgColor, UIColor(PokemonTheme.purple).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 4)

        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: gradientImage!)
    }

    private func configureButtonBarStyle() {
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = createGradientColor()
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 0.1)
        settings.style.buttonBarItemTitleColor = UIColor.clear
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, changeCurrentIndex: Bool, _) in
            guard changeCurrentIndex else { return }

            oldCell?.imageView.tintColor = UIColor.systemGray

            if let newImageView = newCell?.imageView {
                newImageView.image = newImageView.image?.withRenderingMode(.alwaysTemplate)
                newImageView.tintColor = UIColor.systemPurple
            }
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let homeVC = SwiftUITabViewController(
            rootView: HomeView(databaseManager: databaseManager),
            iconName: "house.fill"
        )

        let profileVC = SwiftUITabViewController(
            rootView: ProfileView(databaseManager: databaseManager),
            iconName: "person.fill"
        )

        return [homeVC, profileVC]
    }
}

extension UIImage {
    static func fromGradient(gradientLayer: CAGradientLayer, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage ?? UIImage()
    }
}

class SwiftUITabViewController<Content: View>: UIViewController, IndicatorInfoProvider {
    private let rootView: Content
    private let iconName: String

    init(rootView: Content, iconName: String) {
        self.rootView = rootView
        self.iconName = iconName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }

    private func setupSwiftUIView() {
        let hostingController = UIHostingController(rootView: rootView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(
            title: "",
            image: UIImage(systemName: iconName),
            highlightedImage: UIImage(systemName: iconName)
        )
    }
}
