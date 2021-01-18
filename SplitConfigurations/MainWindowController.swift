import Cocoa

// - Tag: ItemIdentifiers
private extension NSToolbarItem.Identifier {
    static let searchItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier("SearchItem")
}

class MainWindowController: NSWindowController, NSToolbarDelegate {

    // Requires caution during the portion of the lifecycle where this is still nil, but we set it up in windowDidLoad() before most things happen.
    @IBOutlet var sidebarViewController: SidebarViewController!
    @IBOutlet var contentListViewController: ContentListViewController!
    @IBOutlet var detailViewController: DetailViewController!
    @IBOutlet weak var toolbar: NSToolbar!
    var toggleSidebar: NSTrackingSeparatorToolbarItem?
    var showFonts: NSTrackingSeparatorToolbarItem?
    
    // Dangerous convenience alias so you can access the NSSplitViewController and manipulate it later on
    private var splitViewController: NSSplitViewController! {
        get { return contentViewController as? NSSplitViewController }
        set { contentViewController = newValue }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.subtitle = "591 messages, 17 unread"

        let splitViewController = NSSplitViewController()

        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController)
        splitViewController.addSplitViewItem(sidebarItem)

        let contentListItem = NSSplitViewItem(contentListWithViewController: contentListViewController)
        splitViewController.addSplitViewItem(contentListItem)
        

        let detailItem = NSSplitViewItem(viewController: detailViewController)
        splitViewController.addSplitViewItem(detailItem)
        self.splitViewController = splitViewController
        
        
        toggleSidebar?.splitView = splitViewController.splitView
        showFonts?.splitView = splitViewController.splitView
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .showFonts,
            .showColors,
            .searchItem
        ]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var toolbarItem: NSToolbarItem?
        
        if itemIdentifier == NSToolbarItem.Identifier.toggleSidebar {
            toggleSidebar = NSTrackingSeparatorToolbarItem(identifier: NSToolbarItem.Identifier.toggleSidebar, splitView: splitViewController.splitView, dividerIndex: 0)
            toolbarItem = toggleSidebar
        }
        
        else if itemIdentifier == NSToolbarItem.Identifier.showFonts {
            showFonts = NSTrackingSeparatorToolbarItem(identifier: NSToolbarItem.Identifier.showFonts, splitView: splitViewController.splitView, dividerIndex: 1)
            toolbarItem = showFonts
        }
        
        else if itemIdentifier == NSToolbarItem.Identifier.searchItem {
            let searchItem = NSSearchToolbarItem(itemIdentifier: NSToolbarItem.Identifier.searchItem)
            searchItem.searchField = NSSearchField.init(frame: NSRect(x: 0, y: 0, width: 30, height: 22))
            toolbarItem = searchItem
        }
        
        return toolbarItem
    }
    
}
