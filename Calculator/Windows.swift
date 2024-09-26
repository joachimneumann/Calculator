//
//  Windows.swift
//  MGCalc
//
//  Created by Mike Griebling on 2023-02-04.
//

import SwiftUI

class GlobalViewModel : NSObject, ObservableObject {
 
    @Published var windows = Set<NSWindow>()
    @Published var mainWindow: NSWindow?

    func addWindow(window: NSWindow) {
        window.delegate = self
        windows.insert(window)
//        if window.setFrameAutosaveName("MGCalc.\(window.title)Window") {
//            print("Frame for \(window.title) set")
//        } else {
//            print("Frame for \(window.title) not set")
//        }
    }
    
    func getWindow(named name:String) -> NSWindow? {
        Array(windows).first { $0.title == name }
    }
    
    func windowIsOpen(_ name:String) -> Bool {
        getWindow(named: name) != nil
    }
    
    func closeWindow(_ name: String) {
        if let window = getWindow(named: name) {
            window.close()
        }
    }
}

extension GlobalViewModel : NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            print("Closing window \(window.title)")
            windows = windows.filter { $0.windowNumber != window.windowNumber }
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            print("Resizing window \(window.title) to \(window.frame)")
        }
    }
    
}

struct WindowFinder: NSViewRepresentable {
    
    var callback: (NSWindow?) -> ()
    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) { }
    
}

extension View {
    
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(WindowFinder(callback: callback))
    }
    
}


