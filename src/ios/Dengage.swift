import Foundation
import Dengage_Framework

@objc(CordovaDengage)
public class CordovaDengage : CDVPlugin {
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
}
