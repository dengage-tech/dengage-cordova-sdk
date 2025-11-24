import Foundation
import Dengage

#if canImport(DengageGeofence)
import DengageGeofence
#endif

@objc(DengageCRCoordinator)
public class DengageCRCoordinator: NSObject {
    @objc public static let staticInstance = DengageCRCoordinator()
    @objc var integrationKey: String?
    @objc var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    @objc(setupDengage:appGroupsKey:launchOptions:application:askNotificationPermission:enableGeoFence:disableOpenURL:badgeCountReset:logVisible:)
    public func setupDengage(
        key: NSString,
        appGroupsKey: NSString,
        launchOptions: NSDictionary?,
        application: UIApplication,
        askNotificationPermission: DarwinBoolean,
        enableGeoFence: DarwinBoolean,
        disableOpenURL: DarwinBoolean,
        badgeCountReset: DarwinBoolean,
        logVisible: DarwinBoolean
    ) {
        let options = DengageOptions(
            disableOpenURL: disableOpenURL.boolValue,
            badgeCountReset: badgeCountReset.boolValue,
            disableRegisterForRemoteNotifications: false,
            appGroupsKey: appGroupsKey as String
        )
        let opts = launchOptions as? [UIApplication.LaunchOptionsKey: Any] ?? [:]
        Dengage.start(apiKey: key as String, application: application, launchOptions: opts, dengageOptions: options)
        Dengage.setIntegrationKey(key: key as String)
        if askNotificationPermission.boolValue {
            Dengage.promptForPushNotifications()
        }
        
#if canImport(DengageGeofence)
        if enableGeoFence.boolValue {
            DengageGeofence.startGeofence()
        }
#endif
        
        Dengage.setLog(isVisible: logVisible.boolValue)
        Dengage.setHybridAppEnvironment()
    }
    
    @objc(registerForPushToken:)
    public func registerForPushToken(_ deviceToken: Data) {
        Dengage.register(deviceToken: deviceToken)
    }
    
    @objc(didReceivePush:response:withCompletionHandler:)
    public func didReceivePush(
        _ center: UNUserNotificationCenter,
        _ response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        Dengage.didReceivePush(center, response, withCompletionHandler: completionHandler)
    }
    
    @objc(didReceive:)
    public func didReceive(with userInfo: [AnyHashable: Any]) {
        Dengage.didReceive(with: userInfo)
    }
}



