import Cocoa

@objc public final class TerminatorController: NSViewController {

    /// Hosts an array of `NSRunningApplication` instances.
    /// You can find a list of the possible actions on an instance
    /// in the documentation here:
    /// https://developer.apple.com/documentation/appkit/nsrunningapplication
    @IBOutlet var processesArrayController: NSArrayController?
    private var reloadTimer: Timer?

    public override func viewWillAppear() {
        super.viewWillAppear()
        reload()
    }

    // MARK: IB Actions

    @IBAction func terminateFirstSelected(sender: AnyObject) {
        terminateFirstSelected(force: false)
    }

    @IBAction func forceTerminateSelected(sender: AnyObject) {
        terminateFirstSelected(force: true)
    }

    @IBAction func terminateAllSelected(sender: AnyObject) {
        terminateAllSelected(force: false)
    }

    @IBAction func forceTerminateAllSelected(sender: AnyObject) {
        terminateAllSelected(force: true)
    }

    // MARK: Private

    private func terminateFirstSelected(force: Bool) {
        guard let item = processesArrayController?.selectedObjects.first,
            let process = item as? NSRunningApplication
            else { return }
        terminate(process: process, force: force)
    }

    private func terminateAllSelected(force: Bool) {
        guard let processes = processesArrayController?.selectedObjects as? [NSRunningApplication] else { return }
        processes.forEach { terminate(process: $0, force: force) }
    }

    private func terminate(process: NSRunningApplication, force: Bool) {
        if force {
            process.forceTerminate()
        } else {
            process.terminate()
        }
    }

    private func reload() {
        reloadTimer?.invalidate()
        let workspace = NSWorkspace.shared
        processesArrayController?.content = workspace.runningApplications
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.reload()
        }
    }
}
