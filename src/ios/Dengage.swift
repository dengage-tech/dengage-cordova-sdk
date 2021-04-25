import Foundation
import Dengage_Framework

@objc(CordovaDengage)
public class CordovaDengage : CDVPlugin {

    @objc
    public func setupDengage(_ command: CDVInvokedUrlCommand) {
        let key = command.argument(at: 0) as! String? ?? ""
        let launchOptions = command.argument(at: 1) as! NSDictionary?

        Dengage.setIntegrationKey(key: key as String)

        if (launchOptions != nil) {
            Dengage.initWithLaunchOptions(withLaunchOptions: launchOptions as! [UIApplication.LaunchOptionsKey : Any])
        } else {
            Dengage.initWithLaunchOptions(withLaunchOptions: nil)
        }

        Dengage.promptForPushNotifications()

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    public func registerForPushToken(_ command: CDVInvokedUrlCommand) {
        let deviceToken: Data = command.argument(at: 0) as! Data

        var token = "";
        if #available(iOS 13.0, *){
            token = deviceToken.map { String(format: "%02x", $0) }.joined()
        }
        else {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            token = tokenParts.joined()
        }
        sendToken(token)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setIntegrationKey(_ command: CDVInvokedUrlCommand) -> Void {
        let key: String = command.argument(at: 0) as! String? ?? ""

        Dengage.setIntegrationKey(key: key)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func promptForPushNotifications(_ command: CDVInvokedUrlCommand) {
        Dengage.promptForPushNotifications()

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func promptForPushNotificationsWithPermission(_ command: CDVInvokedUrlCommand) {
        Dengage.promptForPushNotifications() {
            hasPermission in self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: hasPermission), callbackId: command.callbackId)
        }
    }

    @objc
    func echo(_ command: CDVInvokedUrlCommand) {
        let echo = command.argument(at: 0) as! String?
        let pluginResult:CDVPluginResult

        if echo != nil && echo!.count > 0 {
            pluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: echo!)
        } else {
            pluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    private func sendToken(_ token: String ){
        Dengage.setToken(token: token)
    }
}
