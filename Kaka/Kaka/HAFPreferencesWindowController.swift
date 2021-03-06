//
//  HAFPreferencesWindowController.swift
//  Kaka
//
//  Created by Jovi on 8/24/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFPreferencesWindowController: NSWindowController {
    var _scTabs: NSSegmentedControl!
    var _btnLaunchAtLogin: NSButton!
    var _btnBackupBackupConfiguration: NSButton!
    var _lbAutoHideDesktopIconTimeout: NSTextField!
    var _tfAutoHideDesktopIconTimeoutValue: NSTextField!
    var _lbAutoHideCursorTimeout: NSTextField!
    var _tfAutoHideCursorTimeoutValue: NSTextField!

    init() {
        let frame = NSMakeRect(0, 0, 580, 180)
        let wnd = NSWindow.init(contentRect: frame, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        wnd.backgroundColor = NSColor.white
        wnd.titlebarAppearsTransparent = true
        wnd.standardWindowButton(.zoomButton)?.isHidden = true
        wnd.standardWindowButton(.miniaturizeButton)?.isHidden = true
        wnd.title = NSLocalizedString("Preferences", comment: "")
        super.init(window: wnd)
        
        let visualEffectView: NSVisualEffectView = NSVisualEffectView.init(frame: frame)
        wnd.contentView = visualEffectView
        
        let tabFrame = NSMakeRect((NSWidth(frame) - 170) / 2, NSHeight(frame) - 55, 170, 23)
        _scTabs = NSSegmentedControl.init(frame: tabFrame)
        _scTabs.segmentCount = 2
        _scTabs.setLabel(NSLocalizedString("General", comment: ""), forSegment: 0)
        _scTabs.setWidth(80, forSegment: 0)
        _scTabs.setLabel(NSLocalizedString("Timer", comment: ""), forSegment: 1)
        _scTabs.setWidth(80, forSegment: 1)
        _scTabs.setSelected(true, forSegment: 0)
        _scTabs.setSelected(false, forSegment: 1)
        _scTabs.target = self
        _scTabs.action = #selector(tabs_click)
        wnd.contentView?.addSubview(_scTabs)

        //MARK: General
        _btnLaunchAtLogin = NSButton.init(frame: NSMakeRect(20, NSMinY(tabFrame) - 40, NSWidth(frame), 23))
        _btnLaunchAtLogin.title = NSLocalizedString("Launch at login", comment: "")
        _btnLaunchAtLogin.setButtonType(.switch)
        _btnLaunchAtLogin.target = self
        _btnLaunchAtLogin.action = #selector(launchAtLogin_click)
        _btnLaunchAtLogin.state = HAFConfigureManager.sharedManager.isLaunchAtLogin() ? .on : .off
        _btnLaunchAtLogin.isHidden = true
        wnd.contentView?.addSubview(_btnLaunchAtLogin)
        
        _btnBackupBackupConfiguration = NSButton.init(frame: NSMakeRect(20, NSMinY(_btnLaunchAtLogin.frame) - 35, 200, 23))
        _btnBackupBackupConfiguration.title = NSLocalizedString("Backup Configuration", comment: "")
        _btnBackupBackupConfiguration.setButtonType(.momentaryChange)
        _btnBackupBackupConfiguration.bezelStyle = .inline
        _btnBackupBackupConfiguration.target = self
        _btnBackupBackupConfiguration.action = #selector(backupConfiguration_click)
        _btnBackupBackupConfiguration.isHidden = true
        wnd.contentView?.addSubview(_btnBackupBackupConfiguration)
        
        //MARK: Timer
        
        _lbAutoHideDesktopIconTimeout = NSTextField.init(frame: NSMakeRect(0, NSMinY(tabFrame) - 40, 250, 23))
        _lbAutoHideDesktopIconTimeout.alignment = .right
        _lbAutoHideDesktopIconTimeout.isEditable = false
        _lbAutoHideDesktopIconTimeout.isBezeled = false
        _lbAutoHideDesktopIconTimeout.isSelectable = false
        _lbAutoHideDesktopIconTimeout.backgroundColor = NSColor.clear
        _lbAutoHideDesktopIconTimeout.stringValue = NSLocalizedString("Auto Hide Desktop Icon Timeout(sec)", comment: "") + ":"
        wnd.contentView?.addSubview(_lbAutoHideDesktopIconTimeout)
        
        _tfAutoHideDesktopIconTimeoutValue = NSTextField.init(frame: NSMakeRect(NSMaxX(_lbAutoHideDesktopIconTimeout.frame) + 10, NSMinY(tabFrame) - 37, 50, 23))
        _tfAutoHideDesktopIconTimeoutValue.focusRingType = .none
        _tfAutoHideDesktopIconTimeoutValue.alignment = .right
        _tfAutoHideDesktopIconTimeoutValue.stringValue = ""
        wnd.contentView?.addSubview(_tfAutoHideDesktopIconTimeoutValue)
        var timeOut = HAFConfigureManager.sharedManager.autoHideDesktopIconTimeOut()
        _tfAutoHideDesktopIconTimeoutValue.stringValue = "\(timeOut)"
        _tfAutoHideDesktopIconTimeoutValue.delegate = self
        
        _lbAutoHideCursorTimeout = NSTextField.init(frame: NSMakeRect(0, NSMinY(tabFrame) - 70, 250, 23))
        _lbAutoHideCursorTimeout.alignment = .right
        _lbAutoHideCursorTimeout.isEditable = false
        _lbAutoHideCursorTimeout.isBezeled = false
        _lbAutoHideCursorTimeout.isSelectable = false
        _lbAutoHideCursorTimeout.backgroundColor = NSColor.clear
        _lbAutoHideCursorTimeout.stringValue = NSLocalizedString("Auto Hide Cursor Timeout(sec)", comment: "") + ":"
        wnd.contentView?.addSubview(_lbAutoHideCursorTimeout)
        
        _tfAutoHideCursorTimeoutValue = NSTextField.init(frame: NSMakeRect(NSMaxX(_lbAutoHideCursorTimeout.frame) + 10, NSMinY(tabFrame) - 67, 50, 23))
        _tfAutoHideCursorTimeoutValue.focusRingType = .none
        _tfAutoHideCursorTimeoutValue.alignment = .right
        _tfAutoHideCursorTimeoutValue.stringValue = ""
        wnd.contentView?.addSubview(_tfAutoHideCursorTimeoutValue)
        timeOut = HAFConfigureManager.sharedManager.autoHideCursorTimeOut()
        _tfAutoHideCursorTimeoutValue.stringValue = "\(timeOut)"
        _tfAutoHideCursorTimeoutValue.delegate = self
        
        updateTabs()
        
        wnd.center()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        updateTimerValue()
    }
    
    func updateTimerValue() -> Void {
        var timeOut = HAFConfigureManager.sharedManager.autoHideDesktopIconTimeOut()
        _tfAutoHideDesktopIconTimeoutValue.stringValue = "\(timeOut)"
        timeOut = HAFConfigureManager.sharedManager.autoHideCursorTimeOut()
        _tfAutoHideCursorTimeoutValue.stringValue = "\(timeOut)"
    }
    
    func updateTabs() -> Void {
        _btnLaunchAtLogin.isHidden = true
        _lbAutoHideDesktopIconTimeout.isHidden = true
        _tfAutoHideDesktopIconTimeoutValue.isHidden = true
        _lbAutoHideCursorTimeout.isHidden = true
        _tfAutoHideCursorTimeoutValue.isHidden = true
        _btnBackupBackupConfiguration.isHidden = true
        
        switch _scTabs.selectedSegment {
        case 0:
            _btnLaunchAtLogin.isHidden = false
            _btnBackupBackupConfiguration.isHidden = HAFSuperModeManager.isKakaInSuperMode()
            break;
        case 1:
            _lbAutoHideDesktopIconTimeout.isHidden = false
            _tfAutoHideDesktopIconTimeoutValue.isHidden = false
            _lbAutoHideCursorTimeout.isHidden = false
            _tfAutoHideCursorTimeoutValue.isHidden = false
            break;
        default:
            break;
        }
    }
    
    @IBAction func launchAtLogin_click(sender: AnyObject?){
        HAFConfigureManager.sharedManager.setLaunchAtLogin(bFlag: _btnLaunchAtLogin.state == .on)
    }

    @IBAction func tabs_click(sender: AnyObject?){
        updateTabs()
    }
    
    @IBAction func backupConfiguration_click(sender: AnyObject?){
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "bk.kaka"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let bk = "6Z2e5rOV56C06Kej77yM6Kej5a+G5peg5pWI44CCS2FrYeaYr+WFjei0ueeahOS9oOadpeegtOino+W5suWTiO+8n+ebtOaOpeaJvuaIkeimgeS7o+eggeWRl+OAguW4jOacm+S9oOiDveaJvuWIsOaIkeeahEdpdEh1YuWVpuOAgg=="
                do {
                    try bk.write(to: savePanel.url!, atomically: false, encoding: .utf8)
                }
                catch {/* error handling here */}
            }
        }
    }
}

extension HAFPreferencesWindowController: NSControlTextEditingDelegate, NSTextFieldDelegate{
    override func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as? NSTextField
        let value = textField?.stringValue
        if nil != value  {
            let intValue = Int(value!)
            if nil == intValue || intValue! <= 0{
                return;
            }
            if textField == _tfAutoHideDesktopIconTimeoutValue{
                HAFConfigureManager.sharedManager.setAutoHideDesktopIconTimeOut(nSeconds: intValue!)
            }else if textField == _tfAutoHideCursorTimeoutValue{
                HAFConfigureManager.sharedManager.setAutoHideCursorTimeOut(nSeconds: intValue!)
            }
        }
    }
}
