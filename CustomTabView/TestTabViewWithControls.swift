import SwiftUI

struct Page: Identifiable {
    let id = UUID()
    let title: String
}

let pages = [
    Page(title: "Page 1"),
    Page(title: "Page 2"),
    Page(title: "Page 3"),
    Page(title: "Page 4")
]

struct TestTabViewWithControls: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Color.gray
            VStack {
                // TabView
                TabView(selection: $selectedTab) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, element in
                        Text("Tab \(element.title)")
                            .tag(index)
                    }
                }
                .animation(.easeIn, value: UUID())
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // External view with ViewModel
                TabViewWithControlsView(viewModel: TabViewWithControlsViewModel(selectedTab: $selectedTab, pagesCount: pages.count))
            }
        }
    }
}

struct TabViewWithControlsView: View {
    var viewModel: TabViewWithControlsViewModel

    var body: some View {
        HStack {
            if viewModel.canGoToPreviousTab {
                Button("Previous") {
                    viewModel.goToPreviousTab()
                }
                .padding()
                .buttonStyle(BlueButton())
                Spacer()
            }
            
            if viewModel.canGoToNextTab {
                if !viewModel.canGoToPreviousTab {
                    Spacer()
                }
                Button("Next") {
                    viewModel.goToNextTab()
                }
                .buttonStyle(BlueButton())
                .padding()
            }
            if viewModel.canShowMainCTA {
                Spacer()
                Button("MainCTA") {
                    viewModel.mainCTApressed()
                }
                .buttonStyle(BlueButton())
                .padding()
                Spacer()
            }
        }
    }
}

class TabViewWithControlsViewModel {
    @Binding var selectedTab: Int
    private var pagesCount: Int
    init(selectedTab: Binding<Int>, pagesCount: Int) {
        _selectedTab = selectedTab
        self.pagesCount = pagesCount
    }

    var canGoToPreviousTab: Bool {
        selectedTab > 0 && selectedTab < pagesCount - 1
    }

    var canGoToNextTab: Bool {
        selectedTab < pagesCount - 1
    }
    
    var canShowMainCTA: Bool {
        selectedTab == pagesCount - 1
    }

    func goToPreviousTab() {
        selectedTab -= 1
    }

    func goToNextTab() {
        selectedTab += 1
    }
    
    func mainCTApressed() {
        selectedTab = 0
        print("main CTA")
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    TestTabViewWithControls()
}
