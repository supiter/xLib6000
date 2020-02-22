//
//  Notifications.swift
//  CommonCode
//
//  Created by Douglas Adams on 1/4/17.
//  Copyright © 2017 Douglas Adams & Mario Illgen. All rights reserved.
//

import Foundation

/// Notification types generated by xLib6000
///
public enum NotificationType : String {
  
  case amplifierHasBeenAdded
  case amplifierWillBeRemoved
  case amplifierHasBeenRemoved

  case audioStreamHasBeenAdded
  case audioStreamWillBeRemoved
  case audioStreamHasBeenRemoved

  case clientDidConnect
  case clientDidDisconnect
  
  case bandSettingHasBeenAdded
  case bandSettingWillBeRemoved
  case bandSettingHasBeenRemoved

  case daxIqStreamHasBeenAdded
  case daxIqStreamWillBeRemoved
  case daxIqStreamHasBeenRemoved

  case daxMicAudioStreamHasBeenAdded
  case daxMicAudioStreamWillBeRemoved
  case daxMicAudioStreamHasBeenRemoved

  case daxRxAudioStreamHasBeenAdded
  case daxRxAudioStreamWillBeRemoved
  case daxRxAudioStreamHasBeenRemoved

  case daxTxAudioStreamHasBeenAdded
  case daxTxAudioStreamWillBeRemoved
  case daxTxAudioStreamHasBeenRemoved

  case discoveredRadios
  
  case equalizerHasBeenAdded
  
  case globalProfileChanged
  case globalProfileCreated
  case globalProfileRemoved
  case globalProfileUpdated
  
  case guiClientHasBeenAdded
  case guiClientHasBeenRemoved
  case guiClientHasBeenUpdated

  case iqStreamHasBeenAdded
  case iqStreamWillBeRemoved
  case iqStreamHasBeenRemoved

  case memoryHasBeenAdded
  case memoryWillBeRemoved
  case memoryHasBeenRemoved

  case meterHasBeenAdded
  case meterWillBeRemoved
  case meterHasBeenRemoved
  case meterUpdated
  
  case micAudioStreamHasBeenAdded
  case micAudioStreamWillBeRemoved
  case micAudioStreamHasBeenRemoved

  case opusHasBeenAdded
  case opusWillBeRemoved

  case opusRxHasBeenAdded
  case opusRxWillBeRemoved

  case opusTxHasBeenAdded
  case opusTxWillBeRemoved

  case panadapterHasBeenAdded
  case panadapterWillBeRemoved
  case panadapterHasBeenRemoved

  case profileHasBeenAdded
  case profileWillBeRemoved
  
  case radioHasBeenAdded
  case radioWillBeRemoved
  case radioHasBeenRemoved
  
  case radioDowngrade
  case radioUpgrade

  case remoteRxAudioStreamHasBeenAdded
  case remoteRxAudioStreamWillBeRemoved
  case remoteRxAudioStreamHasBeenRemoved

  case remoteTxAudioStreamHasBeenAdded
  case remoteTxAudioStreamWillBeRemoved
  case remoteTxAudioStreamHasBeenRemoved

  case sliceBecameActive
  case sliceHasBeenAdded
  case sliceWillBeRemoved
  case sliceHasBeenRemoved

  case sliceMeterHasBeenAdded
  case sliceMeterWillBeRemoved

  case tcpDidConnect
  case tcpDidDisconnect
  case tcpPingStarted
  case tcpPingFirstResponse
  case tcpPingTimeout
  case tcpWillDisconnect
  
  case tnfHasBeenAdded
  case tnfWillBeRemoved
  case tnfHasBeenRemoved

  case transmitHasBeenAdded

  case txAudioStreamHasBeenAdded
  case txAudioStreamWillBeRemoved
  case txAudioStreamHasBeenRemoved

  case udpDidBind
  
  case usbCableHasBeenAdded
  case usbCableWillBeRemoved
  case usbCableHasBeenRemoved

  case waterfallHasBeenAdded
  case waterfallWillBeRemoved
  case waterfallHasBeenRemoved

  case xvtrHasBeenAdded
  case xvtrWillBeRemoved
  case xvtrHasBeenRemoved
}

