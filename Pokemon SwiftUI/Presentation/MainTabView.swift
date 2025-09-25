//
//  MainTabView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import XLPagerTabStrip

struct MainTabView: View {
    @ObservedObject var databaseManager: CouchbaseManager

    var body: some View {
        PagerTabStripView(databaseManager: databaseManager)
            .edgesIgnoringSafeArea(.bottom)
    }
}
