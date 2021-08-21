//
//  CollapsingNavigationBarView.swift
//  CollapsingNavigationBarExample
//
//  Created by 홍희표 on 2021/08/16.
//

import SwiftUI

struct CollapsingNavigationBarView<Header: View, Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let navigationBarHeight: CGFloat = 44
    
    let title: String
    
    let headerHeight: CGFloat
    
    let scrollUpBehavior: ScrollUpHeaderBehavior
    
    let scrollDownBehavior: ScrollDownHeaderBehavior
    
    let header: () -> Header
    
    let content: () -> Content
    
    var body: some View {
        GeometryReader { globalProxy in
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { proxy -> AnyView in
                        let geometry = self.geometry(from: proxy, safeArea: globalProxy.safeAreaInsets)
                        return AnyView(header().frame(width: geometry.width, height: geometry.headerHeight).clipped().opacity(sqrt(geometry.largeTitleWeight)).offset(y: geometry.headerOffset))
                    }.frame(width: globalProxy.size.width, height: headerHeight)
                    GeometryReader { proxy -> AnyView in
                        let geometry = self.geometry(from: proxy, safeArea: globalProxy.safeAreaInsets)
                        return AnyView(ZStack {
                            BlurView().opacity(1 - sqrt(geometry.largeTitleWeight)).offset(y: geometry.blurOffset)
                            VStack {
                                geometry.largeTitleWeight == 1 ? HStack {
                                    BackButton(color: .white)
                                    Spacer()
                                }.frame(width: geometry.width, height: navigationBarHeight) : nil
                                Spacer()
                                HeaderScrollViewTitle(title: self.title, height: navigationBarHeight, largeTitle: geometry.largeTitleWeight).layoutPriority(1000)
                            }.padding(.top, globalProxy.safeAreaInsets.top).frame(width: geometry.width, height: max(geometry.elementHeight, navigationBarHeight)).offset(y: geometry.elementOffset)
                        })
                    }.frame(width: globalProxy.size.width, height: self.headerHeight).zIndex(1000).offset(y: -self.headerHeight)
                    self.content().background(Color.background(colorScheme: self.colorScheme)).offset(y: -self.headerHeight).padding(.bottom, -self.headerHeight)
                }
            }.edgesIgnoringSafeArea(.top)
        }.navigationBarTitle(Text(""), displayMode: .inline).navigationBarHidden(true).background(NavigationConfigurator())
    }
    
    struct HeaderScrollViewGeometry {
        let width: CGFloat
        
        let headerHeight: CGFloat
        
        let elementHeight: CGFloat
        
        let headerOffset: CGFloat
        
        let blurOffset: CGFloat
        
        let elementOffset: CGFloat
        
        let largeTitleWeight: Double
    }
    
    private func geometry(from proxy: GeometryProxy, safeArea: EdgeInsets) -> HeaderScrollViewGeometry {
        let minY = proxy.frame(in: .global).minY
        let hasScrolledUp = minY > 0
        let hasScrolledToMinHeight = -minY >= headerHeight - navigationBarHeight - safeArea.top
        let headerHeight = hasScrolledUp && scrollUpBehavior == .parallax ? proxy.size.height + minY : proxy.size.height
        let elementsHeight = hasScrolledUp && scrollUpBehavior == .sticky ? proxy.size.height : proxy.size.height + minY
        var headerOffset: CGFloat
        let blurOffset: CGFloat
        var elementOffset: CGFloat
        var largeTitleWeight: Double
        
        if hasScrolledUp {
            headerOffset = -minY
            blurOffset = -minY
            elementOffset = -minY
            largeTitleWeight = 1
        } else if hasScrolledToMinHeight {
            headerOffset = -minY - self.headerHeight + navigationBarHeight + safeArea.top
            blurOffset = -minY - self.headerHeight + navigationBarHeight + safeArea.top
            elementOffset = headerOffset / 2 - minY / 2
            largeTitleWeight = 0
        } else {
            headerOffset = self.scrollDownBehavior == .sticky ? -minY : 0
            blurOffset = 0
            elementOffset = -minY / 2
            let difference = headerHeight - navigationBarHeight - safeArea.top + minY
            largeTitleWeight = difference <= navigationBarHeight + 1 ? Double(difference / (navigationBarHeight + 1)) : 1
        }
        return HeaderScrollViewGeometry(width: proxy.size.width, headerHeight: headerHeight, elementHeight: elementsHeight, headerOffset: headerOffset, blurOffset: blurOffset, elementOffset: elementOffset, largeTitleWeight: largeTitleWeight)
    }
}

public enum ScrollUpHeaderBehavior {
    case parallax
    case sticky
}

public enum ScrollDownHeaderBehavior {
    case offset
    case sticky
}

public struct BlurView: UIViewRepresentable {
    public func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<BlurView>) {
        guard let effectView = uiView.subviews.first as? UIVisualEffectView else { return }
        effectView.effect = UIBlurEffect(style: context.environment.colorScheme == .dark ? .dark : .light)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<BlurView>) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }
}

struct BackButton: View {
    @State private var hasBeenShownAtLeastOnce: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let color: Color
    
    var body: some View {
        (presentationMode.wrappedValue.isPresented || hasBeenShownAtLeastOnce) ?
            Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                Image(systemName: "chevron.left").resizable().aspectRatio(contentMode: .fit).frame(height: 20, alignment: .leading).foregroundColor(color).padding(.horizontal, 16).font(Font.body.bold())
            }).onAppear(perform: {
                hasBeenShownAtLeastOnce = true
            }) : nil
    }
}

struct HeaderScrollViewTitle: View {
    let title: String
    
    let height: CGFloat
    
    let largeTitle: Double
    
    var body: some View {
        ZStack {
            HStack {
                Text(title).font(.largeTitle).foregroundColor(.white).fontWeight(.black).padding(.horizontal, 16)
                Spacer()
            }.padding(.bottom, 8).opacity(sqrt((max(largeTitle, 0.5) - 0.5) * 2)).minimumScaleFactor(0.5)
            ZStack {
                HStack {
                    BackButton(color: .primary)
                    Spacer()
                }
                HStack {
                    Text(title).font(.system(size: 18)).fontWeight(.bold).foregroundColor(.primary)
                }
            }.padding(.bottom, (height - 18) / 2).opacity(sqrt(1 - min(largeTitle, 0.5) * 2))
        }.frame(height: height)
    }
    
    
}

extension Color {
    static func background(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .black
        case .light:
            fallthrough
        @unknown default:
            return .white
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var navigationController: UINavigationController?
        
        weak var originalDelegate: UIGestureRecognizerDelegate?
        
        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            return originalDelegate
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let navigationController = navigationController, navigationController.isNavigationBarHidden {
                 return true
            } else if let result = originalDelegate?.gestureRecognizerShouldBegin?(gestureRecognizer) {
                return result
            } else {
                return false
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if let navigationController = navigationController, navigationController.isNavigationBarHidden {
                return true
            } else if let result = originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) {
                return result
            } else {
                return false
            }
        }
        
        @available(iOS 13.4, *)
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
            if let navigationController = navigationController, navigationController.isNavigationBarHidden {
                return true
            } else if let result = originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: event) {
                return result
            } else {
                return false
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
            if let navigationController = navigationController, navigationController.isNavigationBarHidden {
                return true
            } else if let result = originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: press) {
                return result
            } else {
                return false
            }
        }
        
        deinit {
            navigationController?.interactivePopGestureRecognizer?.delegate = originalDelegate
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        let controller = UIViewController()
        controller.title = "Some Title"
        return controller
    }
    
    func makeCoordinator() -> NavigationConfigurator.Coordinator {
        return Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        guard let originalDelegate = uiViewController.navigationController?.interactivePopGestureRecognizer?.delegate, !(originalDelegate is Coordinator) else {
            return
        }
        context.coordinator.navigationController = uiViewController.navigationController
        context.coordinator.originalDelegate = originalDelegate
        uiViewController.navigationController?.interactivePopGestureRecognizer?.delegate = context.coordinator
    }
}

