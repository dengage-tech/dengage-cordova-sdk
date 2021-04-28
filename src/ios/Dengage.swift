import Foundation
import Dengage_Framework

@objc(Dengage)
public class Dengage : CDVPlugin {
    @objc(registerForPushToken:)
    public func registerForPushToken(deviceToken: Data) {
        var token = "";
        if #available(iOS 13.0, *){
            token = deviceToken.map { String(format: "%02x", $0) }.joined()
        }
        else {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            token = tokenParts.joined()
        }
        sendToken(token)
    }


    @objc
    func setupDengage(_ command: CDVInvokedUrlCommand) {
        let isVisible = command.argument(at: 0) as! Bool ?? false
        let key = command.argument(at: 1) as! String? ?? ""
        let launchOptions = command.argument(at: 2) as! NSDictionary?

        Dengage_Framework.Dengage.setIntegrationKey(key: key as String)

        if (launchOptions != nil) {
            Dengage_Framework.Dengage.initWithLaunchOptions(withLaunchOptions: launchOptions as! [UIApplication.LaunchOptionsKey : Any])
        } else {
            Dengage_Framework.Dengage.initWithLaunchOptions(withLaunchOptions: nil)
        }

        Dengage_Framework.Dengage.promptForPushNotifications()

        Dengage_Framework.Dengage.setLogStatus(isVisible: isVisible)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setIntegrationKey(_ command: CDVInvokedUrlCommand) -> Void {
        let key: String = command.argument(at: 0) as! String? ?? ""

        Dengage_Framework.Dengage.setIntegrationKey(key: key)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func promptForPushNotifications(_ command: CDVInvokedUrlCommand) {
        Dengage_Framework.Dengage.promptForPushNotifications()

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func promptForPushNotificationsWithPermission(_ command: CDVInvokedUrlCommand) {
        Dengage_Framework.Dengage.promptForPushNotifications() {
            hasPermission in self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: hasPermission), callbackId: command.callbackId)
        }
    }

    @objc
    func setContactKey(_ command: CDVInvokedUrlCommand) {
        let contactKey: String = command.argument(at: 0) as! String? ?? ""

        Dengage_Framework.Dengage.setContactKey(contactKey: contactKey)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: contactKey)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getContactKey(_ command: CDVInvokedUrlCommand) {
        let contactKey = Dengage_Framework.Dengage.getContactKey()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: contactKey)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func getMobilePushToken(_ command: CDVInvokedUrlCommand) {
        let token = Dengage_Framework.Dengage.getToken()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: token)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
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
        Dengage_Framework.Dengage.setToken(token: token)
    }

}
