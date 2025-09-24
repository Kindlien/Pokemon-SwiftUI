//
//  HUDManager.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import MBProgressHUD

class HUDManager: ObservableObject {
    @Published var isShowing = false
    @Published var text = ""

    private var currentHUD: MBProgressHUD?

    func show(_ message: String) {
        DispatchQueue.main.async {
            self.isShowing = true
            self.text = message
            self.showHUD()
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.isShowing = false
            self.hideHUD()
        }
    }

    private func showHUD() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        hideHUD()

        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.label.text = text
        hud.mode = .indeterminate
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        hud.backgroundView.style = .blur
        hud.backgroundView.blurEffectStyle = .systemMaterial
        hud.backgroundView.color = UIColor.clear
        hud.bezelView.color = UIColor.systemBackground

        currentHUD = hud
    }

    private func hideHUD() {
        currentHUD?.hide(animated: true)
        currentHUD = nil
    }
}
