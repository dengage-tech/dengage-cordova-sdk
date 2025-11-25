import UIKit
import Foundation
import Dengage

@objc(DengageCR)
public class DengageCR : CDVPlugin {

    private var inlineOverlayView: DengageInlineOverlayView?

    @objc
    func promptForPushNotifications(_ command: CDVInvokedUrlCommand) {
        Dengage.promptForPushNotifications()

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func promptForPushNotificationsWithCallback(_ command: CDVInvokedUrlCommand) {
        Dengage.promptForPushNotifications() {
            hasPermission in self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: hasPermission), callbackId: command.callbackId)
        }
    }

    @objc
    func setPermission(_ command: CDVInvokedUrlCommand) {
        let permission: Bool = command.argument(at: 0) as? Bool ?? false
        
        Dengage.setUserPermission(permission: permission)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func setContactKey(_ command: CDVInvokedUrlCommand) {
        let contactKey: String = command.argument(at: 0) as! String? ?? ""

        Dengage.setContactKey(contactKey: contactKey)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: contactKey)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setLogStatus(_ command: CDVInvokedUrlCommand) {
        let isVisible = command.argument(at: 0) as! Bool ?? false

        Dengage.setLogStatus(isVisible: isVisible)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setMobilePushToken(_ command: CDVInvokedUrlCommand) {
        let token: String = command.argument(at: 0) as! String ?? ""

        Dengage.setToken(token: token)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: token)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func getContactKey(_ command: CDVInvokedUrlCommand) {
        let contactKey = Dengage.getContactKey()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: contactKey)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }


    @objc
    func getMobilePushToken(_ command: CDVInvokedUrlCommand) {
        let token = Dengage.getDeviceToken()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: token)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func pageView (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let data: NSDictionary = command.argument(at: 0) as! NSDictionary

            try Dengage.pageView(parameters: data as! [String:Any])

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

            try Dengage.addToCart(parameters: data as! [String:Any])

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

            try Dengage.removeFromCart(parameters: data as! [String:Any])

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

            try Dengage.viewCart(parameters: data as! [String:Any])

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

            try Dengage.beginCheckout(parameters: data as! [String:Any])

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

            try Dengage.order(parameters: data as! [String:Any])

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

            try Dengage.cancelOrder(parameters: data as! [String:Any])

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

            try Dengage.addToWithList(parameters: data as! [String:Any])

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

            try Dengage.removeFromWithList(parameters: data as! [String:Any])

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

            try Dengage.search(parameters: data as! [String:Any])

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

            try Dengage.sendCustomEvent(eventTable: tableName as String, parameters: withData as! [String:Any])
     
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func getSubscription (_ command: CDVInvokedUrlCommand) -> Void {
        // Build subscription object similar to React Native implementation
        var subscription: [String: Any] = [:]
        
        subscription["integrationKey"] = Dengage.getIntegrationKey()
        subscription["token"] = Dengage.getDeviceToken() ?? ""
        subscription["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        subscription["sdkVersion"] = Dengage.getSdkVersion() ?? ""
        subscription["deviceId"] = Dengage.getDeviceId()
        subscription["advertisingId"] = "" // Not available in iOS without additional setup
        subscription["carrierId"] = "" // Not directly available
        subscription["contactKey"] = Dengage.getContactKey()
        subscription["permission"] = Dengage.getPermission()
        subscription["trackingPermission"] = false
        subscription["tokenType"] = "I" // iOS
        subscription["webSubscription"] = ""
        subscription["testGroup"] = ""
        subscription["country"] = "" // Can be added if needed
        subscription["language"] = Locale.current.languageCode ?? ""
        subscription["timezone"] = TimeZone.current.identifier
        subscription["partnerDeviceId"] = "" // Can be retrieved if set
        subscription["locationPermission"] = "" // Can be added if needed
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscription, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
            
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: jsonString)
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func getInboxMessages (_ command: CDVInvokedUrlCommand) -> Void {
        let offset: Int = command.argument(at: 0) as? Int ?? 10
        let limit: Int = command.argument(at: 1) as? Int ?? 20


        Dengage.getInboxMessages(offset: offset, limit: limit) { (result) in
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


        Dengage.deleteInboxMessage(with: id as String) { (result) in
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


        Dengage.setInboxMessageAsClicked(with: id as String) { (result) in
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
        Dengage.handleNotificationActionBlock { (notificationResponse) in
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

    @objc
    func setNavigation (_ command: CDVInvokedUrlCommand) -> Void {
        Dengage.setNavigation()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

    }

    @objc
    func setNavigationWithName (_ command: CDVInvokedUrlCommand) -> Void {
        let screenName: String = command.argument(at: 0) as! String? ?? ""

        if (screenName == "") {
            Dengage.setNavigation()
        } else {
            Dengage.setNavigation(screenName: screenName as String)
        }

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

    }


    @objc
    func registerNotification (_ command: CDVInvokedUrlCommand)-> Void {
      Dengage.handleNotificationActionBlock { (notificationResponse) in
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

          response["eventType"] = "PUSH_OPEN"
              //JSONSerialization.jsonObject(with: response)
          var convertedString = ""
          do {
                  let data =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
              convertedString = String(data: data, encoding: String.Encoding.utf8) ?? ""
                } catch let myJSONError {
                    print(myJSONError)
                }
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: convertedString)

          pluginResult.setKeepCallbackAs(true)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
       }
    }
    @objc
    func setTags(_ command: CDVInvokedUrlCommand) -> Void {
        let data = command.argument(at: 0) as! [NSDictionary]


        var tags: [TagItem] = []
        for tag in data {
            let tagItem:TagItem = TagItem.init(
                tagName: tag["tagName"] as! String,
                tagValue: tag["tagValue"] as! String,
                changeTime: tag["changeTime"] as! Date?,
                removeTime: tag["removeTime"] as! Date?,
                changeValue: tag["changeValue"] as! String?
            )
            tags.append(tagItem)
        }
        Dengage.setTags(tags)

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    private func sendToken(_ token: String ){
        Dengage.setToken(token: token)
    }
    
    @objc
      func setCategoryPath(_ command: CDVInvokedUrlCommand) {
          let path: String = command.argument(at: 0) as! String? ?? ""

          Dengage.setCategory(path: path as String)
          
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

      }
      
    @objc
      func setCartItemCount(_ command: CDVInvokedUrlCommand) {
          let count: String = command.argument(at: 0) as! String? ?? ""

          Dengage.setCart(itemCount: count as String)
          
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

      }
      
    @objc
      func setCartAmount(_ command: CDVInvokedUrlCommand) {
          let amount: String = command.argument(at: 0) as! String? ?? ""

          Dengage.setCart(amount: amount as String)
          
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

      }
      
    @objc
      func setState(_ command: CDVInvokedUrlCommand) {
          let state: String = command.argument(at: 0) as! String? ?? ""

          Dengage.setState(name: state as String)
          
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

      }
      
    @objc
      func setCity(_ command: CDVInvokedUrlCommand) {
          let city: String = command.argument(at: 0) as! String? ?? ""

          Dengage.setCity(name: city as String)
          
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

      }
      
    @objc
      func showRealTimeInApp (_ command: CDVInvokedUrlCommand) -> Void {
          do {
              let screenName: String = command.argument(at: 0) as! String
              let withData: NSDictionary = command.argument(at: 1) as! NSDictionary

              Dengage.showRealTimeInApp(screenName: screenName as String , params: withData as? Dictionary<String, String> )
              
              let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

              self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

          } catch {
              print("Unexpected search error: \(error)")
          }
      }

    @objc
    func showInAppInline(_ command: CDVInvokedUrlCommand) {
        guard let payload = command.argument(at: 0) as? [String: Any] else {
            let result = CDVPluginResult(status: .error, messageAs: "payload is required")
            self.commandDelegate.send(result, callbackId: command.callbackId)
            return
        }

        let propertyId = (payload["propertyId"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let screenName = (payload["screenName"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let boundsDict = payload["bounds"] as? [String: Any]
        let customParams = stringDictionary(from: payload["customParams"])

        guard !propertyId.isEmpty, !screenName.isEmpty else {
            let result = CDVPluginResult(status: .error, messageAs: "propertyId and screenName are required")
            self.commandDelegate.send(result, callbackId: command.callbackId)
            return
        }

        let inlineBounds = rectangle(from: boundsDict)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let container = self.webView?.superview ?? self.viewController?.view else {
                let result = CDVPluginResult(status: .error, messageAs: "Unable to attach inline view")
                self.commandDelegate.send(result, callbackId: command.callbackId)
                return
            }

            self.inlineOverlayView?.removeFromSuperview()
            let overlay = DengageInlineOverlayView()
            overlay.configure(bounds: inlineBounds, propertyId: propertyId, screenName: screenName, customParams: customParams)
            container.addSubview(overlay)
            self.inlineOverlayView = overlay

            let successResult = CDVPluginResult(status: .ok)
            self.commandDelegate.send(successResult, callbackId: command.callbackId)
        }
    }

    @objc
    func hideInAppInline(_ command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inlineOverlayView?.removeFromSuperview()
            self.inlineOverlayView = nil
            let result = CDVPluginResult(status: .ok)
            self.commandDelegate.send(result, callbackId: command.callbackId)
        }
    }

    private func rectangle(from dict: [String: Any]?) -> CGRect {
        if let dict = dict {
            let left = CGFloat((dict["left"] as? NSNumber)?.doubleValue ?? 0)
            let top = CGFloat((dict["top"] as? NSNumber)?.doubleValue ?? 0)
            let width = CGFloat((dict["width"] as? NSNumber)?.doubleValue ?? 0)
            let height = CGFloat((dict["height"] as? NSNumber)?.doubleValue ?? 0)
            let resolvedWidth = width > 0 ? width : (self.webView?.bounds.width ?? 0)
            let resolvedHeight = height > 0 ? height : (self.webView?.bounds.height ?? 0)
            return CGRect(x: left, y: top, width: resolvedWidth, height: resolvedHeight)
        }

        if let bounds = self.webView?.bounds {
            return bounds
        }

        return self.viewController?.view.bounds ?? .zero
    }

    private func stringDictionary(from value: Any?) -> [String: String]? {
        guard let dict = value as? [String: Any] else {
            return nil
        }

        var result: [String: String] = [:]
        for (key, rawValue) in dict {
            result[key] = "\(rawValue)"
        }

        return result.isEmpty ? nil : result
    }
    
    @objc
        func setPartnerDeviceId(_ command: CDVInvokedUrlCommand) {
            let adid: String = command.argument(at: 0) as! String
          
            Dengage.setPartnerDeviceId(adid: adid as String)
            
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        }

          @objc
        func setInAppLinkConfiguration(_ command: CDVInvokedUrlCommand) {
            let deeplink: String = command.argument(at: 0) as! String? ?? ""


            Dengage.inAppLinkConfiguration(deeplink: deeplink as String)

            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        }

    @objc
    func getLastPushPayload(_ command: CDVInvokedUrlCommand) {
        let payload = Dengage.getLastPushPayload()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: payload)

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func registerInAppLinkReceiver (_ command: CDVInvokedUrlCommand)-> Void {
        Dengage.handleInAppDeeplink{ (inapplink) in
          var response = [String:Any?]();
         response["eventType"] = "INAPP_CLICK_LINK"
            response["targetUrl"] = inapplink
              //JSONSerialization.jsonObject(with: response)
          var convertedString = ""
          do {
                  let data =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
              convertedString = String(data: data, encoding: String.Encoding.utf8) ?? ""
                } catch let myJSONError {
                    print(myJSONError)
                }
          let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: convertedString)

          pluginResult.setKeepCallbackAs(true)

          self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
       }
    }

    @objc
    func sendCustomEvent (_ command: CDVInvokedUrlCommand) -> Void {
        do {
            let eventTable: String = command.argument(at: 0) as! String
            let key: String = command.argument(at: 1) as! String
            let withParameters: NSDictionary = command.argument(at: 2) as! NSDictionary

            try Dengage.sendCustomEvent(eventTable: eventTable as String, parameters: withParameters as! [String:Any])
     
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        } catch {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func setCart (_ command: CDVInvokedUrlCommand) -> Void {
        guard let cart = command.argument(at: 0) as? NSDictionary,
              let items = cart["items"] as? [[String: Any]] else {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: "Cart items not found")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            return
        }
        
        var cartItems: [CartItem] = []
        for itemDict in items {
            guard let productId = (itemDict["productId"] as? String) ?? (itemDict["product_id"] as? String),
                  let productVariantId = (itemDict["productVariantId"] as? String) ?? (itemDict["product_variant_id"] as? String),
                  let categoryPath = (itemDict["categoryPath"] as? String) ?? (itemDict["category_path"] as? String) else {
                continue
            }
            
            let price = (itemDict["price"] as? Int) ?? ((itemDict["price"] as? NSNumber)?.intValue ?? 0)
            let discountedPrice = (itemDict["discountedPrice"] as? Int) ?? ((itemDict["discounted_price"] as? Int) ?? ((itemDict["discounted_price"] as? NSNumber)?.intValue ?? 0))
            let hasDiscount = (itemDict["hasDiscount"] as? Bool) ?? ((itemDict["has_discount"] as? Bool) ?? false)
            let hasPromotion = (itemDict["hasPromotion"] as? Bool) ?? ((itemDict["has_promotion"] as? Bool) ?? false)
            let quantity = (itemDict["quantity"] as? Int) ?? ((itemDict["quantity"] as? NSNumber)?.intValue ?? 0)
            let attributes = (itemDict["attributes"] as? [String: String]) ?? [:]
            
            let cartItem = CartItem(
                productId: productId,
                productVariantId: productVariantId,
                categoryPath: categoryPath,
                price: price,
                discountedPrice: discountedPrice,
                hasDiscount: hasDiscount,
                hasPromotion: hasPromotion,
                quantity: quantity,
                attributes: attributes
            )
            cartItems.append(cartItem)
        }
        
        let cartObj = Cart(items: cartItems)
        Dengage.setCart(cart: cartObj)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: true)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getCart (_ command: CDVInvokedUrlCommand) -> Void {
        let cart = Dengage.getCart()
        var cartDict: [String: Any] = [:]
        
        // Convert items
        var itemsArray: [[String: Any]] = []
        for item in cart.items {
            var itemDict: [String: Any] = [:]
            itemDict["productId"] = item.productId
            itemDict["productVariantId"] = item.productVariantId
            itemDict["categoryPath"] = item.categoryPath
            itemDict["price"] = item.price
            itemDict["discountedPrice"] = item.discountedPrice
            itemDict["hasDiscount"] = item.hasDiscount
            itemDict["hasPromotion"] = item.hasPromotion
            itemDict["quantity"] = item.quantity
            itemDict["attributes"] = item.attributes
            itemDict["effectivePrice"] = item.effectivePrice
            itemDict["lineTotal"] = item.lineTotal
            itemDict["discountedLineTotal"] = item.discountedLineTotal
            itemDict["effectiveLineTotal"] = item.effectiveLineTotal
            itemDict["categorySegments"] = item.categorySegments
            itemDict["categoryRoot"] = item.categoryRoot
            itemsArray.append(itemDict)
        }
        cartDict["items"] = itemsArray
        
        // Convert summary using JSON encoding
        do {
            let summaryData = try JSONEncoder().encode(cart.summary)
            if let summaryDict = try JSONSerialization.jsonObject(with: summaryData) as? [String: Any] {
                cartDict["summary"] = summaryDict
            }
        } catch {
            print("Error encoding CartSummary: \(error)")
        }
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: cartDict)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getSdkParameters (_ command: CDVInvokedUrlCommand) -> Void {
        if let sdkParams = Dengage.getSdkParameters() {
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(sdkParams)
                if var paramsDict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    if let expiredInterval = paramsDict["expiredMessagesFetchIntervalInMin"] as? Int {
                        paramsDict["expiredMessagesFetchIntervalInMin"] = expiredInterval
                    }
                    if let minSecBetween = paramsDict["inAppMinSecBetweenMessages"] as? Int {
                        paramsDict["inAppMinSecBetweenMessages"] = minSecBetween
                    }
                    let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: paramsDict)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                } else {
                    let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: [:])
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                }
            } catch {
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        } else {
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: [:])
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc
    func setInAppDeviceInfo (_ command: CDVInvokedUrlCommand) -> Void {
        let key: String = command.argument(at: 0) as! String
        let value: String = command.argument(at: 1) as! String
        
        Dengage.setInAppDeviceInfo(key: key, value: value)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func clearInAppDeviceInfo (_ command: CDVInvokedUrlCommand) -> Void {
        Dengage.clearInAppDeviceInfo()
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getInAppDeviceInfo (_ command: CDVInvokedUrlCommand) -> Void {
        let inAppDeviceInfo = Dengage.getInAppDeviceInfo()
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: inAppDeviceInfo)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func deleteAllInboxMessages (_ command: CDVInvokedUrlCommand) -> Void {
        Dengage.deleteAllInboxMessages { (result) in
            switch result {
            case .success:
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: true)
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
    func setAllInboxMessageAsClicked (_ command: CDVInvokedUrlCommand) -> Void {
        Dengage.setAllInboxMessageAsClicked { (result) in
            switch result {
            case .success:
                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: true)
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
    func getDeviceId (_ command: CDVInvokedUrlCommand) -> Void {
        let deviceId = Dengage.getDeviceId()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: deviceId)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setDeviceId (_ command: CDVInvokedUrlCommand) -> Void {
        let deviceId: String = command.argument(at: 0) as! String
        Dengage.setDeviceId(applicationIdentifier: deviceId)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setLanguage (_ command: CDVInvokedUrlCommand) -> Void {
        let language: String = command.argument(at: 0) as! String
        Dengage.setLanguage(language: language)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setDevelopmentStatus (_ command: CDVInvokedUrlCommand) -> Void {
        let isDebug: Bool = command.argument(at: 0) as! Bool
        Dengage.setDevelopmentStatus(isDebug: isDebug)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getSdkVersion (_ command: CDVInvokedUrlCommand) -> Void {
        let version = Dengage.getSdkVersion() ?? ""
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: version)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func requestLocationPermissions (_ command: CDVInvokedUrlCommand) -> Void {
#if canImport(DengageGeofence)
        DengageGeofence.requestLocationPermissions()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
#else
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: "DengageGeofence library not available")
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
#endif
    }

    @objc
    func getIntegrationKey (_ command: CDVInvokedUrlCommand) -> Void {
        let integrationKey = Dengage.getIntegrationKey()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: integrationKey)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func getPermission (_ command: CDVInvokedUrlCommand) -> Void {
        let permission = Dengage.getPermission()
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: permission)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func resetAppBadge (_ command: CDVInvokedUrlCommand) -> Void {
        // iOS doesn't have resetAppBadge, this is Android only
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: "resetAppBadge is Android only")
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc
    func setNavigationWithNameAndData (_ command: CDVInvokedUrlCommand) -> Void {
        let screenName: String = command.argument(at: 0) as! String
        let screenData: NSDictionary = command.argument(at: 1) as! NSDictionary
        
        Dengage.showRealTimeInApp(screenName: screenName, params: screenData as? Dictionary<String, String>)
        
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}

