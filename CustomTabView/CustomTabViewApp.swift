//
//  CustomTabViewApp.swift
//  CustomTabView
//
//  Created by Emiliano Hualpa on 20/5/24.
//

import SwiftUI

@main
struct CustomTabViewApp: App {
    var body: some Scene {
        WindowGroup {
//            TestTabViewWithControls()
            let testPages = [
                Page(title: "Page 00"),
                Page(title: "Page 11"),
                Page(title: "Page 22"),
                Page(title: "Page 33")
            ]
            let tabControlViewModel = TabViewControlViewModel(
                previousTitle: "Prev",
                nextTitle: "Next",
                mainTitle: "Main",
                pagesCount: testPages.count,
                selectedIndex: 0
            )
            let viewModel = TabViewWithControlBarViewModel(
                pages: testPages,
                tabControlViewModel: tabControlViewModel
            )
            TabViewWithControlBar(viewModel: viewModel)
        }
    }
}
