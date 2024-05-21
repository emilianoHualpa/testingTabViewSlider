//
//  TabViewWithControlBar.swift
//  CustomTabView
//
//  Created by Emiliano Hualpa on 20/5/24.
//

import SwiftUI

protocol TabViewWithControlBarViewModelProtocol: ObservableObject {
    associatedtype TabControlViewModel: TabViewControlViewModelProtocol
    var pages: [Page] { get }
    var tabControlViewModel: TabControlViewModel { get set }
}

final class TabViewWithControlBarViewModel<TabControlViewModel: TabViewControlViewModelProtocol>: TabViewWithControlBarViewModelProtocol {
    let pages: [Page]
    var tabControlViewModel: TabControlViewModel
    
    init(
        pages: [Page],
        tabControlViewModel: TabControlViewModel
    ) {
        self.pages = pages
        self.tabControlViewModel = tabControlViewModel
    }
}

struct TabViewWithControlBar<ViewModel: TabViewWithControlBarViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
//        let selectedIndex = Binding<Int> {
//            viewModel.tabControlViewModel.selectedIndex
//        } set: {
//            viewModel.tabControlViewModel.didChangePage($0)
//        }
        VStack {
            TabView(selection: $viewModel.tabControlViewModel.selectedIndex) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                    Text(page.title)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
            Text("Current Page is: \(viewModel.tabControlViewModel.selectedIndex)")
            TabViewControlView(viewModel: viewModel.tabControlViewModel)
        }
    }
}

protocol TabViewControlViewModelProtocol: ObservableObject {
    var selectedIndex: Int { get set }
    var previousTitle: String { get }
    var nextTitle: String { get }
    var mainTitle: String { get }
    var pagesCount: Int { get }
    var canGoToPreviousTab: Bool { get }
    var canGoToNextTab: Bool { get }
    var canShowMainCTA: Bool { get }
    func didPressPrevButton()
    func didPressNextButton()
    func didPressMainCTAButton()
    func didChangePage(_ index: Int)
}

final class TabViewControlViewModel: TabViewControlViewModelProtocol {
    var previousTitle: String
    var nextTitle: String
    var mainTitle: String
    var pagesCount: Int
    @Published var selectedIndex: Int
    init(previousTitle: String, nextTitle: String, mainTitle: String, pagesCount: Int, selectedIndex: Int) {
        self.previousTitle = previousTitle
        self.nextTitle = nextTitle
        self.mainTitle = mainTitle
        self.pagesCount = pagesCount
        self.selectedIndex = selectedIndex
    }
    var canGoToPreviousTab: Bool {
        selectedIndex > 0 && selectedIndex < pagesCount - 1
    }
    var canGoToNextTab: Bool {
        selectedIndex < pagesCount - 1
    }
    var canShowMainCTA: Bool {
        selectedIndex == pagesCount - 1
    }
    func didPressPrevButton() {
        selectedIndex -= 1
    }
    func didPressNextButton() {
        selectedIndex += 1
    }
    func didPressMainCTAButton() {
        selectedIndex = 0
    }
    func didChangePage(_ index: Int) {
        selectedIndex = index
    }
}

struct TabViewControlView<ViewModel: TabViewControlViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        HStack {
            if viewModel.canGoToPreviousTab {
                Button(viewModel.previousTitle) {
                    viewModel.didPressPrevButton()
                }
                .padding()
                .buttonStyle(BlueButton())
                Spacer()
            }
            if viewModel.canShowMainCTA {
                Spacer()
                Button(viewModel.mainTitle) {
                    viewModel.didPressMainCTAButton()
                }
                .buttonStyle(BlueButton())
                .padding()
                Spacer()
            }
            if viewModel.canGoToNextTab {
                Spacer()
                Button(viewModel.nextTitle) {
                    viewModel.didPressNextButton()
                }
                .buttonStyle(BlueButton())
                .padding()
            }
        }
    }
}

#Preview {
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
    return TabViewWithControlBar(viewModel: viewModel)
}
