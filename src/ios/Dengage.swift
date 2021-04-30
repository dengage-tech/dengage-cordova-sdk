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
    func promptForPushNotificationsWithCallback(_ command: CDVInvokedUrlCommand) {
        Dengage_Framework.Dengage.promptForPushNotifications() {
            hasPermission in self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: hasPermission), callbackId: command.callbackId)
        }
    }

    @objc
    func setPermission(permission: Bool) {
        Dengage_Framework.Dengage.setUserPermission(permission: permission)
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
    func pageView (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.pageView(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func addToCart (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.addToCart(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func removeFromCart (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.removeFromCart(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func viewCart (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.viewCart(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func beginCheckout (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.beginCheckout(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func placeOrder (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.order(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func cancelOrder (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.cancelOrder(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func addToWishList (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.addToWithList(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func removeFromWishList (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.removeFromWithList(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func search (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try DengageEvent.shared.search(params: data as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func sendDeviceEvent (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let tableName: String = command.argument(at: 0) as! String
            let withData: NSDictionary = command.argument(at: 1) as! NSDictionary

            try Dengage_Framework.Dengage.SendDeviceEvent(toEventTable: tableName, andWithEventDetails: withData as! NSMutableDictionary)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func getSubscription (_ command: CDVInvokedUrlCommand) -> Void {

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: "This method is yet not available in iOS")

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

    }

    @objc
    func getInboxMessages (_ command: CDVInvokedUrlCommand) -> Void {
        let offset: Int = command.argument(at: 0) as? Int ?? 10
        let limit: Int = command.argument(at: 1) as? Int ?? 20


        Dengage_Framework.Dengage.getInboxMessages(offset: offset, limit: limit) { (result) in
            switch result {
            case .success(let resultType):
                do {
                    let encodedData = try JSONEncoder().encode(resultType)
                    let jsonString = String(data: encodedData,
                                            encoding: .utf8)

                    let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: jsonString)

                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                } catch {
                    let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                }
                break;
            case .failure(let error): // Handle the error
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

                break;

            }
        }
    }

    @objc
    func deleteInboxMessage (_ command: CDVInvokedUrlCommand) -> Void {
        let id: String = command.argument(at: 0) as! String


        Dengage_Framework.Dengage.deleteInboxMessage(with: id as String) { (result) in
            switch result {
            case .success:
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: ["success": true, "id": id])
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

                break;
            case .failure (let error):
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                break;
            }
        }
    }

    @objc
    func setInboxMessageAsClicked (_ command: CDVInvokedUrlCommand) -> Void {
        let id: String = command.argument(at: 0) as! String


        Dengage_Framework.Dengage.setInboxMessageAsClicked(with: id as String) { (result) in
            switch result {
            case .success:
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: ["success": true, "id": id])
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

                break;
            case .failure (let error):
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                break;
            }
        }
    }


    @objc
    func handleNotificationActionBlock (_ command: CDVInvokedUrlCommand) {
        Dengage_Framework.Dengage.handleNotificationActionBlock { (notificationResponse) in
            var response = [String:Any?]();
            response["actionIdentifier"] = notificationResponse.actionIdentifier

            var notification = [String:Any?]()
            notification["date"] = notificationResponse.notification.date.description

            var notificationReq = [String:Any?]()
            notificationReq["identifier"] = notificationResponse.notification.request.identifier

            if (notificationResponse.notification.request.trigger?.repeats != nil) {
                var notificationReqTrigger = [String:Any?]()
                notificationReqTrigger["repeats"] = notificationResponse.notification.request.trigger?.repeats ?? nil
                notificationReq["trigger"] = notificationReqTrigger
            }

            var reqContent = [String:Any?]()
            var contentAttachments = [Any]()
            for attachement in notificationResponse.notification.request.content.attachments {
                var contentAttachment = [String:Any?]()
                contentAttachment["identifier"] = attachement.identifier
                contentAttachment["url"] = attachement.url
                contentAttachment["type"] = attachement.type
                contentAttachments.append(contentAttachment)
            }
            reqContent["badge"] = notificationResponse.notification.request.content.badge
            reqContent["body"] = notificationResponse.notification.request.content.body
            reqContent["categoryIdentifier"] = notificationResponse.notification.request.content.categoryIdentifier
            reqContent["launchImageName"] = notificationResponse.notification.request.content.launchImageName
            // @NSCopying open var sound: UNNotificationSound? { get }
            //reqContent["sound"] = notificationResponse.notification.request.content.sound // this yet ignored, will include later.
            reqContent["subtitle"] = notificationResponse.notification.request.content.subtitle
            reqContent["threadIdentifier"] = notificationResponse.notification.request.content.threadIdentifier
            reqContent["title"] = notificationResponse.notification.request.content.title
            reqContent["userInfo"] = notificationResponse.notification.request.content.userInfo // todo: make sure it is RCTCovertible & doesn't break the code
            if #available(iOS 12.0, *) {
                reqContent["summaryArgument"] = notificationResponse.notification.request.content.summaryArgument
                reqContent["summaryArgumentCount"] = notificationResponse.notification.request.content.summaryArgumentCount
            }
            if #available(iOS 13.0, *) {
                reqContent["targetContentIdentifier"] = notificationResponse.notification.request.content.targetContentIdentifier
            }


            reqContent["attachments"] = contentAttachments
            notificationReq["content"] = reqContent
            notification["request"] = notificationReq
            response["notification"] = notification

            self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: response), callbackId: command.callbackId)

        }
    }

    private func sendToken(_ token: String ){
        Dengage_Framework.Dengage.setToken(token: token)
    }
}
