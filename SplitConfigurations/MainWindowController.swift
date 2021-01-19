import Cocoa

// - Tag: ItemIdentifiers
private extension NSToolbarItem.Identifier {
    static let searchItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier("SearchItem")
    static let toggleFirstSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier("ToggleFirstSidebarItem")
    static let toggleLastSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier("ToggleLastSidebarItem")
    static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
}

class MainWindowController: NSWindowController, NSToolbarDelegate {

    // Requires caution during the portion of the lifecycle where this is still nil, but we set it up in windowDidLoad() before most things happen.
    @IBOutlet var sidebarViewController: SidebarViewController!
    @IBOutlet var contentListViewController: ContentListViewController!
    @IBOutlet var detailViewController: DetailViewController!
    @IBOutlet weak var toolbar: NSToolbar!
    
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
        
        toolbar.insertItem(withItemIdentifier: .itemListTrackingSeparator, at: 5)
    }
    
    @objc func toggleFirstPanel() {
        guard let firstSplitView = splitViewController.splitViewItems.first else { return }
        if firstSplitView.animator().isCollapsed {
            firstSplitView.animator().isCollapsed = false
        } else {
            firstSplitView.animator().isCollapsed = true
        }
    }
    
    @objc func toggleLastPanel() {
        guard let lastSplitView = splitViewController.splitViewItems.last else { return }
        if lastSplitView.animator().isCollapsed {
            lastSplitView.animator().isCollapsed = false
        } else {
            lastSplitView.animator().isCollapsed = true
        }
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return  [
            .toggleFirstSidebarItem,
            .flexibleSpace,
            .showColors,
            .sidebarTrackingSeparator,
            .showFonts,
            .searchItem,
            .flexibleSpace,
            .toggleLastSidebarItem
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleFirstSidebarItem,
            .showColors,
            .flexibleSpace,
            .space,
            .showFonts,
            .searchItem,
            .toggleLastSidebarItem
        ]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .itemListTrackingSeparator:
            if ((splitViewController) != nil) {
                return NSTrackingSeparatorToolbarItem(identifier: .itemListTrackingSeparator, splitView: splitViewController.splitView, dividerIndex: 1)
            } else {
                return nil
            }
        case .searchItem:
            return NSSearchToolbarItem(itemIdentifier: .searchItem)
        case .toggleFirstSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleFirstSidebarItem)
            toolbarItem.label = "Sidebar"
            toolbarItem.paletteLabel = "Sidebar"
            toolbarItem.toolTip = "Toggle Sidebar"
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleFirstPanel)
            toolbarItem.image = NSImage(systemSymbolName: "sidebar.leading", accessibilityDescription: nil)
            
            let menuItem = NSMenuItem()
            menuItem.submenu = nil
            menuItem.title = "Sidebar"
            
            toolbarItem.menuFormRepresentation = menuItem
            return toolbarItem
        case .toggleLastSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleFirstSidebarItem)
            toolbarItem.label = "Sidebar"
            toolbarItem.paletteLabel = "Sidebar"
            toolbarItem.toolTip = "Toggle Sidebar"
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleLastPanel)
            toolbarItem.image = NSImage(systemSymbolName: "sidebar.trailing", accessibilityDescription: nil)
            
            let menuItem = NSMenuItem()
            menuItem.submenu = nil
            menuItem.title = "Sidebar"
            
            toolbarItem.menuFormRepresentation = menuItem
            return toolbarItem
        default:
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
    
    func customToolbarItem(
        itemForItemIdentifier itemIdentifier: String,
        label: String,
        paletteLabel: String,
        toolTip: String,
        itemContent: AnyObject) -> NSToolbarItem? {
        
        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: itemIdentifier))
        
        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip
        toolbarItem.target = self
        
        // Set the right attribute, depending on if we were given an image or a view.
        if itemContent is NSImage {
            if let image = itemContent as? NSImage {
                toolbarItem.image = image
            }
        } else if itemContent is NSView {
            if let view = itemContent as? NSView {
                toolbarItem.view = view
            }
        } else {
            assertionFailure("Invalid itemContent: object")
        }
        
        // We actually need an NSMenuItem here, so we construct one.
        let menuItem: NSMenuItem = NSMenuItem()
        menuItem.submenu = nil
        menuItem.title = label
        toolbarItem.menuFormRepresentation = menuItem
        
        return toolbarItem
    }
}
