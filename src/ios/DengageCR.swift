import Foundation
import Dengage

@objc(DengageCR)
public class DengageCR : CDVPlugin {

    @objc(setupDengage:launchOptions:application:askNotificaionPermission:enableGeoFence:)
    public func setupDengage(key:NSString, launchOptions:NSDictionary?, application : UIApplication,askNotificaionPermission:DarwinBoolean,enableGeoFence:DarwinBoolean) {
        Dengage.setIntegrationKey(key: key as String)
        if (launchOptions != nil) {
            Dengage.initWithLaunchOptions(application: application, withLaunchOptions: launchOptions as! [UIApplication.LaunchOptionsKey : Any])
        } else {
            Dengage.initWithLaunchOptions(application: application, withLaunchOptions: [:])
        }
          
        if askNotificaionPermission.boolValue
        {
            Dengage.promptForPushNotifications()

        }
        
        if enableGeoFence.boolValue
        {
            Dengage.requestLocationPermissions()

        }
        
        
    }

    
    
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
        //sendToken(token)
        
        Dengage.register(deviceToken: deviceToken)
    }
    
    
    @objc(didReceivePush:response:withCompletionHandler:)
    public func didReceivePush(_ center: UNUserNotificationCenter,
                                            _ response: UNNotificationResponse,
                                            withCompletionHandler completionHandler: @escaping () -> Void) {

        Dengage.didReceivePush(center, response, withCompletionHandler: completionHandler)

    }
    
    @objc(didReceive:)
    public func didReceive(with userInfo: [AnyHashable: Any]) {
        
        Dengage.didReceive(with: userInfo)
        
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
    func promptForPushNotificationsWithCallback(_ command: CDVInvokedUrlCommand) {
        Dengage.promptForPushNotifications() {
            hasPermission in self.commandDelegate.send(CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: hasPermission), callbackId: command.callbackId)
        }
    }

    @objc
    func setPermission(permission: Bool) {
        Dengage.setUserPermission(permission: permission)
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

        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: "This method is yet not available in iOS")

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

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
        func setPartnerDeviceId(_ command: CDVInvokedUrlCommand) {
            let adid: String = command.argument(at: 0) as! String
          
            Dengage.setPartnerDeviceId(adid: adid as String)
            
            let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        }
    
    @objc
     func stopGeofence(_ command: CDVInvokedUrlCommand){
         Dengage.stopGeofence()
         let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

         self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
     }
     
     @objc
     func requestLocationPermissions(_ command: CDVInvokedUrlCommand){
         Dengage.requestLocationPermissions()
         let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)

         self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
     }
     
     @objc
     func startGeofence(_ command: CDVInvokedUrlCommand){
         Dengage.requestLocationPermissions()
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
}
