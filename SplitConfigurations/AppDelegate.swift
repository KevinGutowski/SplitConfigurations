import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = MainWindowController(windowNibName: "MainWindowController")
        mainWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            mainWindowController.showWindow(nil)
            return false
        }
        return true
    }

}

