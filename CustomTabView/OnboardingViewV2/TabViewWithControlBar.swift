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
    var tabControlViewModel: TabControlViewModel { get }
}

final class TabViewWithControlBarViewModel<TabControlViewModel: TabViewControlViewModelProtocol>: TabViewWithControlBarViewModelProtocol {
    let pages: [Page]
    @Published var tabControlViewModel: TabControlViewModel
    
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

        let selectedIndex = Binding <Int>  {
            viewModel.tabControlViewModel.selectedIndex
        } set: {
            viewModel.tabControlViewModel.didChangePage($0)
        }

        VStack {
            TabView(selection: selectedIndex) {
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
    var selectedIndex: Int { get }
    var previousTitle: String? { get }
    var nextTitle: String? { get }
    var mainTitle: String? { get }
    var pagesCount: Int { get }
    func didPressPrevButton()
    func didPressNextButton()
    func didPressMainCTAButton()
    func didChangePage(_ index: Int)
}

final class TabViewControlViewModel: TabViewControlViewModelProtocol {
    var previousTitle: String?
    var nextTitle: String?
    var mainTitle: String?
    var pagesCount: Int
    @Published var selectedIndex: Int
    
    init(previousTitle: String? = nil, nextTitle: String? = nil, mainTitle: String? = nil, pagesCount: Int, selectedIndex: Int) {
        self.previousTitle = previousTitle
        self.nextTitle = nextTitle
        self.mainTitle = mainTitle
        self.pagesCount = pagesCount
        self.selectedIndex = selectedIndex
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
            Button("Previous") {
                viewModel.didPressPrevButton()
            }
            .padding()
            .buttonStyle(BlueButton())
            Spacer()
            
            Button("MainCTA") {
                viewModel.didPressMainCTAButton()
            }
            .buttonStyle(BlueButton())
            .padding()
            
            Spacer()
            
            Button("Next") {
                viewModel.didPressNextButton()
            }
            .buttonStyle(BlueButton())
            .padding()
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
    let tabControlViewModel = TabViewControlViewModel(pagesCount: testPages.count, selectedIndex: 0)
    let viewModel = TabViewWithControlBarViewModel(
        pages: testPages,
        tabControlViewModel: tabControlViewModel
    )
    return TabViewWithControlBar(viewModel: viewModel)
}
