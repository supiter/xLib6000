//
//  Radio.swift
//  xLib6000
//
//  Created by Douglas Adams on 8/15/15.
//  Copyright © 2015 Douglas Adams & Mario Illgen. All rights reserved.
//

import Foundation

//// Radio Class implementation
///
///      as the object analog to the Radio (hardware), manages the use of all of
///      the other model objects
///
public final class Radio                    : NSObject, StaticModel, ApiDelegate {

  // ----------------------------------------------------------------------------
  // MARK: - Static properties
  
  static let kApfCmd                        = "eq apf "                     // Text of command messages
  static let kClientCmd                     = "client "                     // (V3 only)
  static let kClientSetCmd                  = "client set "                 // (V3 only)
  static let kCmd                           = "radio "
  static let kSetCmd                        = "radio set "
  static let kMixerCmd                      = "mixer "
  static let kUptimeCmd                     = "radio uptime"
  static let kLicenseCmd                    = "license "
  static let kXmitCmd                       = "xmit "

  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  public private(set) var uptime            = 0
  @objc dynamic public var version          : String { return _api.activeRadio?.firmwareVersion ?? "" }
  @objc dynamic public var serialNumber     : String { return _api.activeRadio?.serialNumber ?? "" }

  // Static models
  @objc dynamic public private(set) var atu         : Atu!                  // Atu model
  @objc dynamic public private(set) var cwx         : Cwx!                  // Cwx model
  @objc dynamic public private(set) var gps         : Gps!                  // Gps model
  @objc dynamic public private(set) var interlock   : Interlock!            // Interlock model
  @objc dynamic public private(set) var profile     : Profile!              // Profile model
  @objc dynamic public private(set) var transmit    : Transmit!             // Transmit model
  @objc dynamic public private(set) var wan         : Wan!                  // Wan model
  @objc dynamic public private(set) var waveform    : Waveform!             // Waveform model
  
  @objc dynamic public private(set) var antennaList = [AntennaPort]()       // Array of available Antenna ports
  @objc dynamic public private(set) var micList     = [MicrophonePort]()    // Array of Microphone ports
  @objc dynamic public private(set) var rfGainList  = [RfGainValue]()       // Array of RfGain parameters
  @objc dynamic public private(set) var sliceList   = [SliceId]()           // Array of available Slice id's
  
  public private(set) var sliceErrors       = [String]()                    // frequency error of a Slice (milliHz)
  
  // object collections
  @Barrier([AmplifierId: Amplifier](), Api.objectQ)                 public var amplifiers
  @Barrier([DaxStreamId: AudioStream](), Api.objectQ)               public var audioStreams
  @Barrier([StreamId: DaxIqStream](), Api.objectQ)                  public var daxIqStreams
  @Barrier([StreamId: DaxMicAudioStream](), Api.objectQ)            public var daxMicAudioStreams
  @Barrier([StreamId: DaxRxAudioStream](), Api.objectQ)             public var daxRxAudioStreams
  @Barrier([StreamId: DaxTxAudioStream](), Api.objectQ)             public var daxTxAudioStreams
  @Barrier([Equalizer.EqType: Equalizer](), Api.objectQ)            public var equalizers
  @Barrier([DaxStreamId: IqStream](), Api.objectQ)                  public var iqStreams
  @Barrier([MemoryId: Memory](), Api.objectQ)                       public var memories
  @Barrier([MeterNumber: Meter](), Api.objectQ)                     public var meters
  @Barrier([DaxStreamId: MicAudioStream](), Api.objectQ)            public var micAudioStreams
  @Barrier([OpusId: Opus](), Api.objectQ)                           public var opusStreams
  @Barrier([PanadapterId: Panadapter](), Api.objectQ)               public var panadapters
  @Barrier([ProfileId: Profile](), Api.objectQ)                     public var profiles
  @Barrier([RemoteRxStreamId: RemoteRxAudioStream](), Api.objectQ)  public var remoteRxAudioStreams
  @Barrier([RemoteTxStreamId: RemoteTxAudioStream](), Api.objectQ)  public var remoteTxAudioStreams
  @Barrier([SequenceId: ReplyTuple](), Api.objectQ)                 public var replyHandlers
  @Barrier([SliceId: xLib6000.Slice](), Api.objectQ)                         public var slices
  @Barrier([TnfId: Tnf](), Api.objectQ)                             public var tnfs
  @Barrier([DaxStreamId: TxAudioStream](), Api.objectQ)             public var txAudioStreams
  @Barrier([UsbCableId: UsbCable](), Api.objectQ)                   public var usbCables
  @Barrier([WaterfallId: Waterfall](), Api.objectQ)                 public var waterfalls
  @Barrier([XvtrId: Xvtr](), Api.objectQ)                           public var xvtrs

  // ----------------------------------------------------------------------------
  // MARK: - Internal properties
  
  @BarrierClamped(0, Api.objectQ, range: 0...100) var _apfGain
  @BarrierClamped(0, Api.objectQ, range: 0...33)  var _apfQFactor
  @BarrierClamped(0, Api.objectQ, range: 0...100) var _headphoneGain
  @BarrierClamped(0, Api.objectQ, range: 0...100) var _lineoutGain

  // A
  @Barrier(false, Api.objectQ) var _apfEnabled
  @Barrier(0, Api.objectQ)     var _availablePanadapters      // (read only)
  @Barrier(0, Api.objectQ)     var _availableSlices           // (read only)
  // B
  @Barrier(0, Api.objectQ)     var _backlight                 //
  @Barrier(false, Api.objectQ) var _bandPersistenceEnabled    //
  @Barrier(false, Api.objectQ) var _binauralRxEnabled         // Binaural enable
  @Barrier(nil, Api.objectQ)   var _boundClientId : UUID?     // The Client Id of this client's GUI (V3 only)
  // C
  @Barrier(0, Api.objectQ)     var _calFreq                   // Calibration frequency
  @Barrier("", Api.objectQ)    var _callsign                  // Callsign
  @Barrier("", Api.objectQ)    var _chassisSerial             // Radio serial number (read only)
  @Barrier("", Api.objectQ)    var _clientIp                  // Ip address returned by "client ip" command
  // D
  @Barrier(0, Api.objectQ)     var _daxIqAvailable            //
  @Barrier(0, Api.objectQ)     var _daxIqCapacity             //
  // E
  @Barrier(false, Api.objectQ) var _enforcePrivateIpEnabled   //
  @Barrier(false, Api.objectQ) var _extPresent                //
  // F
  @Barrier(false, Api.objectQ) var _filterCwAutoEnabled       //
  @Barrier(0, Api.objectQ)     var _filterCwLevel             //
  @Barrier(false, Api.objectQ) var _filterDigitalAutoEnabled  //
  @Barrier(0, Api.objectQ)     var _filterDigitalLevel        //
  @Barrier(false, Api.objectQ) var _filterVoiceAutoEnabled    //
  @Barrier(0, Api.objectQ)     var _filterVoiceLevel          //
  @Barrier("", Api.objectQ)    var _fpgaMbVersion             // FPGA version (read only)
  @Barrier(0, Api.objectQ)     var _freqErrorPpb              // Calibration error (Hz)
  @Barrier(false, Api.objectQ) var _frontSpeakerMute          //
  @Barrier(false, Api.objectQ) var _fullDuplexEnabled         // Full duplex enable
  // G
  @Barrier("", Api.objectQ)    var _gateway                   // (read only)
  @Barrier(false, Api.objectQ) var _gpsdoPresent              //
  // H
  @Barrier(false, Api.objectQ) var _headphoneMute             // Headset muted
  // I
  @Barrier("", Api.objectQ)    var _ipAddress                 // IP Address (dotted decimal) (read only)
  // L
  @Barrier(false, Api.objectQ) var _lineoutMute               // Speaker muted
  @Barrier(false, Api.objectQ) var _localPtt                  // PTT usage (V3 only)
  @Barrier("", Api.objectQ)    var _location                  // (read only)
  @Barrier(false, Api.objectQ) var _locked                    //
  // M
  @Barrier("", Api.objectQ)    var _macAddress                // Radio Mac Address (read only)
  @Barrier(false, Api.objectQ) var _mox                       // manual Transmit
  @Barrier(false, Api.objectQ) var _muteLocalAudio            // mute local audio when remote
  // N
  @Barrier("", Api.objectQ)    var _netmask                   //
  @Barrier("", Api.objectQ)    var _nickname                  // User assigned name
  @Barrier(0, Api.objectQ)     var _numberOfScus              // NUmber of SCU's (read only)
  @Barrier(0, Api.objectQ)     var _numberOfSlices            // Number of Slices (read only)
  @Barrier(0, Api.objectQ)     var _numberOfTx                // Number of TX (read only)
  // O
  @Barrier("", Api.objectQ)    var _oscillator                //
  // P
  @Barrier("", Api.objectQ)    var _picDecpuVersion           //
  @Barrier("", Api.objectQ)    var _program                   // Client program
  @Barrier("", Api.objectQ)    var _psocMbPa100Version        // Power amplifier software version
  @Barrier("", Api.objectQ)    var _psocMbtrxVersion          // System supervisor software version
  // R
  @Barrier("", Api.objectQ)    var _radioModel                // Radio Model (e.g. FLEX-6500) (read only)
  @Barrier("", Api.objectQ)    var _radioOptions              // (read only
  @Barrier("", Api.objectQ)    var _radioScreenSaver          // (read only)
  @Barrier("", Api.objectQ)    var _region                    // (read only)
  @Barrier(false, Api.objectQ) var _remoteOnEnabled           // Remote Power On enable
  @Barrier(0, Api.objectQ)     var _rttyMark                  // RTTY mark default
  // S
  @Barrier("", Api.objectQ)    var _setting                   //
  @Barrier("", Api.objectQ)    var _smartSdrMB                // Microburst main CPU software version
  @Barrier(false, Api.objectQ) var _snapTuneEnabled           // Snap tune enable
  @Barrier("", Api.objectQ)    var _softwareVersion           // (read only)
  @Barrier(false, Api.objectQ) var _startCalibration          // true if a Calibration is in progress
  @Barrier("", Api.objectQ)    var _state                     //
  @Barrier("", Api.objectQ)    var _staticGateway             // Static Gateway address
  @Barrier("", Api.objectQ)    var _staticIp                  // Static IpAddress
  @Barrier("", Api.objectQ)    var _staticNetmask             // Static Netmask
  @Barrier("", Api.objectQ)    var _station                   // Station name (V3 only)
  // T
  @Barrier(false, Api.objectQ) var _tcxoPresent               //
  @Barrier(false, Api.objectQ) var _tnfsEnabled               // TNF's enable

  // ----------------------------------------------------------------------------
  // MARK: - Private properties
  
  private let _api                          : Api             // reference to the API singleton
  private var _radioInitialized = false
  private var _clientInitialized            = false
  private var _hardwareVersion              : String?
  private var _gpsPresent                   = false
  private var _atuPresent                   = false

  // GCD Queue
  private let _streamQ                      = DispatchQueue(label: Api.kName + ".streamQ", qos: .userInteractive)

  private let _log                          = Log.sharedInstance

  // ----------------------------------------------------------------------------
  // MARK: - Initialization
  
  /// Initialize a Radio Class
  ///
  /// - Parameters:
  ///   - api:        an Api instance
  ///
  public init(api: Api) {
    
    _api = api
    super.init()

    _api.delegate = self
    
    // initialize the static models (only one of each is ever created)
    atu = Atu(radio: self)
    cwx = Cwx(radio: self)
    gps = Gps(radio: self)
    interlock = Interlock(radio: self)
    transmit = Transmit(radio: self)
    wan = Wan(radio: self)
    waveform = Waveform(radio: self)
    
    // initialize Equalizers (use the newer "sc" type)
    equalizers[.rxsc] = Equalizer(id: Equalizer.EqType.rxsc.rawValue)
    equalizers[.txsc] = Equalizer(id: Equalizer.EqType.txsc.rawValue)
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Public methods
  
  /// Create a Tnf
  ///
  /// - Parameters:
  ///   - frequency:          frequency (Hz)
  ///   - callback:           ReplyHandler (optional)
  ///
  public func createTnf(frequency: String, callback: ReplyHandler? = nil) {
    
    // tell the Radio to create a Tnf
    sendCommand("tnf create " + "freq" + "=\(frequency)", replyTo: callback)
  }

  public func sendCommand(_ command: String, diagnostic flag: Bool = false, replyTo callback: ReplyHandler? = nil) {

    _api.send(command, diagnostic: flag, replyTo: callback)
  }
  
  public func sendVita(_ data: Data?) {
    
    _api.send(data)
  }
  
  /// Remove all Radio objects
  ///
  public func removeAll() {
    
    // ----- remove all objects -----
    //      NOTE: order is important
    
    // notify all observers, then remove
    audioStreams.forEach( { NC.post(.audioStreamWillBeRemoved, object: $0.value as Any?) } )
    audioStreams.removeAll()
    
    iqStreams.forEach( { NC.post(.iqStreamWillBeRemoved, object: $0.value as Any?) } )
    iqStreams.removeAll()
    
    micAudioStreams.forEach( {NC.post(.micAudioStreamWillBeRemoved, object: $0.value as Any?)} )
    micAudioStreams.removeAll()
    
    txAudioStreams.forEach( { NC.post(.txAudioStreamWillBeRemoved, object: $0.value as Any?) } )
    txAudioStreams.removeAll()
    
    opusStreams.forEach( { NC.post(.opusRxWillBeRemoved, object: $0.value as Any?) } )
    opusStreams.removeAll()
    
    tnfs.forEach( { NC.post(.tnfWillBeRemoved, object: $0.value as Any?) } )
    tnfs.removeAll()
    
    slices.forEach( { NC.post(.sliceWillBeRemoved, object: $0.value as Any?) } )
    slices.removeAll()
    
    panadapters.forEach( {
      
      let waterfallId = $0.value.waterfallId
      let waterfall = waterfalls[waterfallId]
      
      // notify all observers
      NC.post(.panadapterWillBeRemoved, object: $0.value as Any?)
      
      NC.post(.waterfallWillBeRemoved, object: waterfall as Any?)
    })
    panadapters.removeAll()
    waterfalls.removeAll()
    
    profiles.forEach( {
      NC.post(.profileWillBeRemoved, object: $0.value.list as Any?)
      $0.value._list.removeAll()
    } )

    equalizers.removeAll()
    
    memories.removeAll()
    
    meters.removeAll()
    
    replyHandlers.removeAll()
    
    usbCables.removeAll()
    
    xvtrs.removeAll()
    
    nickname = ""
    _smartSdrMB = ""
    _psocMbtrxVersion = ""
    _psocMbPa100Version = ""
    _fpgaMbVersion = ""
    
    // clear lists
    antennaList.removeAll()
    micList.removeAll()
    rfGainList.removeAll()
    sliceList.removeAll()
    
    _clientInitialized = false
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Internal methods
  
  /// Change the MOX property when an Interlock state change occurs
  ///
  /// - Parameter state:            a new Interloack state
  ///
  internal func stateChange(_ state: String) {
    
    let currentMox = _mox
    
    // if PTT_REQUESTED or TRANSMITTING
    if state == Interlock.State.pttRequested.rawValue || state == Interlock.State.transmitting.rawValue {
      
      // if mox not on, turn it on
      if currentMox == false {
        willChangeValue(for: \.mox)
        _mox = true
        didChangeValue(for: \.mox)
      }
      
      // if READY or UNKEY_REQUESTED
    } else if state == Interlock.State.ready.rawValue || state == Interlock.State.unKeyRequested.rawValue {
      
      // if mox is on, turn it off
      if currentMox == true {
        willChangeValue(for: \.mox)
        _mox = false
        didChangeValue(for: \.mox)
      }
    }
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  // function to change value and signal KVO
  private func update<T>(_ property: UnsafeMutablePointer<T>, to value: T, signal keyPath: KeyPath<Radio, T>) {
    willChangeValue(for: keyPath)
    property.pointee = value
    didChangeValue(for: keyPath)
  }
  /// Parse a Message. format: <messageNumber>|<messageText>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - commandSuffix:      a Command Suffix
  ///
  private func parseMessage(_ commandSuffix: String) {
    
    // separate it into its components
    let components = commandSuffix.components(separatedBy: "|")
    
    // ignore incorrectly formatted messages
    if components.count < 2 {
      _log.msg("Incomplete message: c\(commandSuffix)", level: .warning, function: #function, file: #file, line: #line)
      return
    }
    let msgText = components[1]
    
    // log it
    _log.msg("\(msgText)", level: flexErrorLevel(errorCode: components[0]), function: #function, file: #file, line: #line)

    // FIXME: Take action on some/all errors?
  }
  /// Parse a Reply. format: <sequenceNumber>|<hexResponse>|<message>[|<debugOutput>]
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - commandSuffix:      a Reply Suffix
  ///
  private func parseReply(_ replySuffix: String) {
    
    // separate it into its components
    let components = replySuffix.components(separatedBy: "|")
    
    // ignore incorrectly formatted replies
    if components.count < 2 {
      _log.msg("Incomplete reply: r\(replySuffix)", level: .warning, function: #function, file: #file, line: #line)
      return
    }
    // is there an Object expecting to be notified?
    if let replyTuple = replyHandlers[ components[0] ] {
      
      // YES, an Object is waiting for this reply, send the Command to the Handler on that Object
      
      let command = replyTuple.command
      // was a Handler specified?
      if let handler = replyTuple.replyTo {
        
        // YES, call the Handler
        handler(command, components[0], components[1], (components.count == 3) ? components[2] : "")
        
      } else {
        
        // send it to the default reply handler
        defaultReplyHandler(replyTuple.command, seqNum: components[0], responseValue: components[1], reply: replySuffix)
      }
      // Remove the object from the notification list
      replyHandlers[components[0]] = nil
      
    } else {
      
      // no Object is waiting for this reply, log it if it is a non-zero Reply (i.e a possible error)
      if components[1] != Api.kNoError {
        _log.msg("Unhandled non-zero reply: c\(components[0]), r\(replySuffix), \(flexErrorString(errorCode: components[1]))", level: .warning, function: #function, file: #file, line: #line)
      }
    }
  }
  /// Parse a Status. format: <apiHandle>|<message>, where <message> is of the form: <msgType> <otherMessageComponents>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - commandSuffix:      a Command Suffix
  ///
  private func parseStatus(_ commandSuffix: String) {
    
    // separate it into its components ( [0] = <apiHandle>, [1] = <remainder> )
    let components = commandSuffix.components(separatedBy: "|")
    
    // ignore incorrectly formatted status
    guard components.count > 1 else {
      _log.msg("Incomplete status: c\(commandSuffix)", level: .warning, function: #function, file: #file, line: #line)
      return
    }
    // find the space & get the msgType
    let spaceIndex = components[1].firstIndex(of: " ")!
    let msgType = String(components[1][..<spaceIndex])
    
    // everything past the msgType is in the remainder
    let remainderIndex = components[1].index(after: spaceIndex)
    let remainder = String(components[1][remainderIndex...])
    
    // Check for unknown Message Types
    guard let token = StatusToken(rawValue: msgType)  else {
      // log it and ignore the message
      _log.msg("Unknown Status token: \(msgType)", level: .warning, function: #function, file: #file, line: #line)
      return
    }
    
    
    // FIXME: ***** file, mixer & turf Not currently implemented *****
    
    
    // Known Message Types, in alphabetical order
    switch token {
      
    case .amplifier:
      // FIXME: Need format(s)
      Amplifier.parseStatus(remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kRemoved))
      
    case .audioStream where Api.kVersion.isV3:
      _log.msg("Invalid Status token: \(msgType) for Version \(Api.kVersion.shortString)", level: .warning, function: #function, file: #file, line: #line)

    case .audioStream:
      //      format: <AudioStreamId> <key=value> <key=value> ...<key=value>
      AudioStream.parseStatus(remainder.keyValuesArray(), radio: self)
      
    case .atu:
      //      format: <key=value> <key=value> ...<key=value>
      atu.parseProperties( remainder.keyValuesArray() )
      
    case .client:
      // formats are different in V3 API
      let keyValues = remainder.keyValuesArray()
      if Api.kVersion.isV3 {
        //      kv                0         1            2
        //      format: client <handle> connected <client_id=ID> <program=Program> <station=Station> <local_ptt=0/1>
        //      format: client <handle> disconnected <forced=0/1>
//        GuiClient.parseStatus(keyValues, radio: self, queue: _q, log: Log.sharedInstance)

      } else {
        //      kv                0         1            2
        //      format: client <handle> connected
        //      format: client <handle> disconnected <forced=1/0>
        parseClient(keyValues, radio: self)
      }

    case .cwx:
      // replace some characters to avoid parsing conflicts
      cwx.parseProperties( remainder.fix().keyValuesArray() )
      
    case .daxiq:
      //      format: <daxChannel> <key=value> <key=value> ...<key=value>
      //            parseDaxiq( remainder.keyValuesArray())
      
      break // obsolete token, included to prevent log messages
      
    case .display:
      //     format: <displayType> <streamId> <key=value> <key=value> ...<key=value>
      let keyValues = remainder.keyValuesArray()
      
      // what Display Type is it?
      switch keyValues[0].key {
      case DisplayToken.panadapter.rawValue:
        Panadapter.parseStatus(keyValues, radio: self, inUse: !remainder.contains(Api.kRemoved))
        
      case DisplayToken.waterfall.rawValue:
        Waterfall.parseStatus(keyValues, radio: self, inUse: !remainder.contains(Api.kRemoved))
        
      default:
        // unknown Display Type, log it and ignore the message
        _log.msg("Unknown Display type: \(keyValues[0].key)", level: .warning, function: #function, file: #file, line: #line)
      }
      
    case .eq:
      //      format: txsc <key=value> <key=value> ...<key=value>
      //      format: rxsc <key=value> <key=value> ...<key=value>
      Equalizer.parseStatus( remainder.keyValuesArray(), radio: self)
      
    case .file:
      _log.msg("Unprocessed \(msgType): \(remainder)", level: .warning, function: #function, file: #file, line: #line)

    case .gps:
      //     format: <key=value>#<key=value>#...<key=value>
      gps.parseProperties( remainder.keyValuesArray(delimiter: "#") )
      
    case .interlock:
      //      format: <key=value> <key=value> ...<key=value>
      interlock.parseProperties( remainder.keyValuesArray())
      
    case .memory:
      //      format: <memoryId> <key=value>,<key=value>,...<key=value>
      Memory.parseStatus( remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kRemoved))
      
    case .meter:
      //     format: <meterNumber.key=value>#<meterNumber.key=value>#...<meterNumber.key=value>
      Meter.parseStatus( remainder.keyValuesArray(delimiter: "#"), radio: self, inUse: !remainder.contains(Api.kRemoved))

    case .micAudioStream where Api.kVersion.isV3:
      _log.msg("Invalid Status token: \(msgType) for Version \(Api.kVersion.shortString)", level: .warning, function: #function, file: #file, line: #line)

    case .micAudioStream:
      //      format: <MicAudioStreamId> <key=value> <key=value> ...<key=value>
      MicAudioStream.parseStatus( remainder.keyValuesArray(), radio: self)
      
    case .mixer:
      _log.msg("Unprocessed \(msgType): \(remainder)", level: .warning, function: #function, file: #file, line: #line)

    case .opusStream:
      //     format: <opusId> <key=value> <key=value> ...<key=value>
      Opus.parseStatus( remainder.keyValuesArray(), radio: self)
      
    case .profile:
      //     format: global list=<value>^<value>^...<value>^
      //     format: global current=<value>
      //     format: tx list=<value>^<value>^...<value>^
      //     format: tx current=<value>
      //     format: mic list=<value>^<value>^...<value>^
      //     format: mic current=<value>
      Profile.parseStatus( remainder.keyValuesArray(delimiter: "="), radio: self)
      
    case .radio:
      //     format: <key=value> <key=value> ...<key=value>
      parseProperties( remainder.keyValuesArray())
      
    case .slice:
      //     format: <sliceId> <key=value> <key=value> ...<key=value>
      xLib6000.Slice.parseStatus( remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kNotInUse))
      
    case .stream:
      //     format: <streamId> <key=value> <key=value> ...<key=value>
      IqStream.parseStatus( remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kNotInUse))
      
    case .tnf:
      //     format: <tnfId> <key=value> <key=value> ...<key=value>
      Tnf.parseStatus( remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kRemoved))
      
    case .transmit:
      //      format: <key=value> <key=value> ...<key=value>
      transmit.parseProperties( remainder.keyValuesArray())
      
    case .turf:
      _log.msg("Unprocessed \(msgType): \(remainder)", level: .warning, function: #function, file: #file, line: #line)
      
    case .txAudioStream where Api.kVersion.isV3:
      _log.msg("Invalid Status token: \(msgType) for Version \(Api.kVersion.shortString)", level: .warning, function: #function, file: #file, line: #line)

    case .txAudioStream:
      //      format: <TxAudioStreamId> <key=value> <key=value> ...<key=value>
      TxAudioStream.parseStatus( remainder.keyValuesArray(), radio: self)
      
    case .usbCable:
      //      format:
      UsbCable.parseStatus( remainder.keyValuesArray(), radio: self)
      
    case .wan:
      wan.parseProperties( remainder.keyValuesArray() )
      
    case .waveform:
      //      format: <key=value> <key=value> ...<key=value>
      waveform.parseProperties( remainder.keyValuesArray())
      
    case .xvtr:
      //      format: <name> <key=value> <key=value> ...<key=value>
      Xvtr.parseStatus( remainder.keyValuesArray(), radio: self, inUse: !remainder.contains(Api.kNotInUse))
    }
    if Api.kVersion.isV3 {
      // check if we received a status message for our handle to see if our client is connected now
      if !_clientInitialized && components[0].handle == _api.connectionHandle {
        
        // YES
        _clientInitialized = true
        
        // Finish the UDP initialization & set the API state
        _api.clientConnected()
      }
    }
  }
  /// Parse a Client status message (pre V3 only)
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:      a KeyValuesArray
  ///   - radio:          the current Radio class
  ///   - queue:          a parse Queue for the object
  ///   - inUse:          false = "to be deleted"
  ///
  private func parseClient(_ keyValues: KeyValuesArray, radio: Radio, inUse: Bool = true) {
    
    guard keyValues.count >= 2 else {
      _log.msg("Invalid client status", level: .warning, function: #function, file: #file, line: #line)
      return
    }
    // guard that the message has my API Handle
    guard _api.connectionHandle! == keyValues[0].key.handle else { return }
    
    // what is the message?
    if keyValues[1].key == "connected" {
      // Connected
      _api.clientConnected()
      
    } else if (keyValues[1].key == "disconnected" && keyValues[2].key == "forced") {
      // FIXME: Handle the disconnect?
      // Disconnected
      _log.msg("Disconnect, forced = \(keyValues[2].value)", level: .info, function: #function, file: #file, line: #line)

    } else {
      // Unrecognized
      _log.msg("Unprocessed Client message: \(keyValues[0].key)", level: .warning, function: #function, file: #file, line: #line)
    }
  }
  /// Parse the Reply to an Info command, reply format: <key=value> <key=value> ...<key=value>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - properties:          a KeyValuesArray
  ///
  private func parseInfoReply(_ properties: KeyValuesArray) {
    
    // process each key/value pair, <key=value>
    for property in properties {
      
      // check for unknown Keys
      guard let token = InfoToken(rawValue: property.key) else {
        // log it and ignore the Key
        _log.msg("Unknown Info token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
        continue
      }
      // Known keys, in alphabetical order
      switch token {
        
      case .atuPresent:
        update(&_atuPresent, to: property.value.bValue, signal: \.atuPresent)

      case .callsign:
        update(&_callsign, to: property.value, signal: \.callsign)

      case .chassisSerial:
        update(&_chassisSerial, to: property.value, signal: \.chassisSerial)

      case .gateway:
        update(&_gateway, to: property.value, signal: \.gateway)

      case .gps:
        update(&_gpsPresent, to: (property.value != "Not Present"), signal: \.gpsPresent)

      case .ipAddress:
        update(&_ipAddress, to: property.value, signal: \.ipAddress)

      case .location:
        update(&_location, to: property.value, signal: \.location)

      case .macAddress:
        update(&_macAddress, to: property.value, signal: \.macAddress)

      case .model:
        update(&_radioModel, to: property.value, signal: \.radioModel)

      case .netmask:
        update(&_netmask, to: property.value, signal: \.netmask)

      case .name:
        update(&_nickname, to: property.value, signal: \.nickname)

      case .numberOfScus:
        update(&_numberOfScus, to: property.value.iValue, signal: \.numberOfScus)

      case .numberOfSlices:
        update(&_numberOfSlices, to: property.value.iValue, signal: \.numberOfSlices)

      case .numberOfTx:
        update(&_numberOfTx, to: property.value.iValue, signal: \.numberOfTx)

      case .options:
        update(&_radioOptions, to: property.value, signal: \.radioOptions)

      case .region:
        update(&_region, to: property.value, signal: \.region)

      case .screensaver:
        update(&_radioScreenSaver, to: property.value, signal: \.radioScreenSaver)

      case .softwareVersion:
        update(&_softwareVersion, to: property.value, signal: \.softwareVersion)
      }
    }
  }
  /// Parse the Reply to a Client Gui command, reply format: <key=value> <key=value> ...<key=value>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:          a KeyValuesArray
  ///
  private func parseGuiReply(_ properties: KeyValuesArray) {
    
    // only v3 returns a Client Id
    for property in properties {
      // save the returned ID
      _boundClientId = UUID(uuidString: property.key)
      break
    }
  }
  /// Parse the Reply to a Client Ip command, reply format: <key=value> <key=value> ...<key=value>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:          a KeyValuesArray
  ///
  private func parseIpReply(_ keyValues: KeyValuesArray) {
    
    // save the returned ip address
    _clientIp = keyValues[0].key
    
  }
  /// Parse the Reply to a Meter list command, reply format: <value>,<value>,...<value>
  ///
  /// - Parameters:
  ///   - reply:          the reply
  ///
//  private func parseMeterListReply(_ reply: String) {
//
//    // nested function to add meter subscriptions
//    func addMeter(id: String, keyValues: KeyValuesArray) {
//
//      // is the meter Short Name valid?
//      if let shortName = Api.MeterShortName(rawValue: keyValues[2].value.lowercased()) {
//        
//        // YES, is it in the list needing subscription?
//        if _metersToSubscribe.contains(shortName) {
//          
//          // YES, send a subscription command
//          Meter.subscribe(id: id)
//        }
//      }
//    }
//    // drop the "meter " string
//    let meters = String(reply.dropFirst(6))
//    let keyValues = meters.keyValuesArray(delimiter: "#")
//
//    var meterKeyValues = KeyValuesArray()
//
//    // extract the first Meter Number
//    var id = keyValues[0].key.components(separatedBy: ".")[0]
//
//    // loop through the kv pairs separating them into individual meters
//    for (i, kv) in keyValues.enumerated() {
//
//      // is this the start of a different meter?
//      if id != kv.key.components(separatedBy: ".")[0] {
//
//        // YES, add the current meter
//        addMeter(id: id, keyValues: meterKeyValues)
//
//        // recycle the keyValues
//        meterKeyValues.removeAll(keepingCapacity: true)
//
//        // get the new meter id
//        id = keyValues[i].key.components(separatedBy: ".")[0]
//
//      }
//      // add the current kv pair to the current set of meter kv pairs
//      meterKeyValues.append(keyValues[i])
//    }
//    // add the final meter
//    addMeter(id: id, keyValues: meterKeyValues)
//  }
  /// Parse the Reply to a Version command, reply format: <key=value>#<key=value>#...<key=value>
  ///
  ///   executed on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:          a KeyValuesArray
  ///
  private func parseVersionReply(_ properties: KeyValuesArray) {
    
    // process each key/value pair, <key=value>
    for property in properties {
      
      // check for unknown Keys
      guard let token = VersionToken(rawValue: property.key) else {
        // log it and ignore the Key
        _log.msg("Unknown Version token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
        continue
      }
      // Known tokens, in alphabetical order
      switch token {
        
      case .smartSdrMB:
        update(&_smartSdrMB, to: property.value, signal: \.smartSdrMB)

      case .picDecpu:
        update(&_picDecpuVersion, to: property.value, signal: \.picDecpuVersion)

      case .psocMbTrx:
        update(&_psocMbtrxVersion, to: property.value, signal: \.psocMbtrxVersion)

      case .psocMbPa100:
        update(&_psocMbPa100Version, to: property.value, signal: \.psocMbPa100Version)

      case .fpgaMb:
        update(&_fpgaMbVersion, to: property.value, signal: \.fpgaMbVersion)
      }
    }
  }
  
  // --------------------------------------------------------------------------------
  // MARK: - Protocol instance methods
  
  /// Parse a Radio status message
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - properties:      a KeyValuesArray
  ///
  func parseProperties(_ properties: KeyValuesArray) {
    
    // FIXME: What about a 6700 with two scu's?
    
    // separate by category
    if let category = RadioTokenCategory(rawValue: properties[0].key) {
      
      // drop the first property
      let adjustedProperties = Array(properties[1...])
      
      switch category {
        
      case .filterSharpness:
        parseFilterProperties( adjustedProperties )
        
      case .staticNetParams:
        parseStaticNetProperties( adjustedProperties )
        
      case .oscillator:
        parseOscillatorProperties( adjustedProperties )
      }
      
    } else {
    
      // process each key/value pair, <key=value>
      for property in properties {
        
        // Check for Unknown Keys
        guard let token = RadioToken(rawValue: property.key)  else {
          // log it and ignore the Key
          _log.msg("Unknown Radio token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
          continue
        }
        // Known tokens, in alphabetical order
        switch token {
          
        case .backlight:
          update(&_backlight, to: property.value.iValue, signal: \.backlight)

        case .bandPersistenceEnabled:
          update(&_bandPersistenceEnabled, to: property.value.bValue, signal: \.bandPersistenceEnabled)

        case .binauralRxEnabled:
          update(&_binauralRxEnabled, to: property.value.bValue, signal: \.binauralRxEnabled)

        case .calFreq:
          update(&_calFreq, to: property.value.mhzToHz, signal: \.calFreq)

        case .callsign:
          update(&_callsign, to: property.value, signal: \.callsign)

        case .daxIqAvailable:                     // (V3 only)
          update(&_daxIqAvailable, to: property.value.iValue, signal: \.daxIqAvailable)

        case .daxIqCapacity:                     // (V3 only)
          update(&_daxIqCapacity, to: property.value.iValue, signal: \.daxIqCapacity)

        case .enforcePrivateIpEnabled:
          update(&_enforcePrivateIpEnabled, to: property.value.bValue, signal: \.enforcePrivateIpEnabled)

        case .freqErrorPpb:
          update(&_freqErrorPpb, to: property.value.iValue, signal: \.freqErrorPpb)

        case .fullDuplexEnabled:
          update(&_fullDuplexEnabled, to: property.value.bValue, signal: \.fullDuplexEnabled)

        case .frontSpeakerMute:
          update(&_frontSpeakerMute, to: property.value.bValue, signal: \.frontSpeakerMute)

        case .headphoneGain:
          update(&_headphoneGain, to: property.value.iValue, signal: \.headphoneGain)

        case .headphoneMute:
          update(&_headphoneMute, to: property.value.bValue, signal: \.headphoneMute)

        case .lineoutGain:
          update(&_lineoutGain, to: property.value.iValue, signal: \.lineoutGain)

        case .lineoutMute:
          update(&_lineoutMute, to: property.value.bValue, signal: \.lineoutMute)

        case .muteLocalAudio:
          update(&_muteLocalAudio, to: property.value.bValue, signal: \.muteLocalAudio)

        case .nickname:
          update(&_nickname, to: property.value, signal: \.nickname)

        case .panadapters:
          update(&_availablePanadapters, to: property.value.iValue, signal: \.availablePanadapters)

        case .pllDone:
          update(&_startCalibration, to: property.value.bValue, signal: \.startCalibration)

        case .remoteOnEnabled:
          update(&_remoteOnEnabled, to: property.value.bValue, signal: \.remoteOnEnabled)

        case .rttyMark:
          update(&_rttyMark, to: property.value.iValue, signal: \.rttyMark)

        case .slices:
          update(&_availableSlices, to: property.value.iValue, signal: \.availableSlices)

        case .snapTuneEnabled:

          update(&_snapTuneEnabled, to: property.value.bValue, signal: \.snapTuneEnabled)

        case .tnfsEnabled:
          update(&_tnfsEnabled, to: property.value.bValue, signal: \.tnfsEnabled)
        }
      }
    }
    // is the Radio initialized?
    if !_radioInitialized {
      
      // YES, the Radio (hardware) has acknowledged this Radio
      _radioInitialized = true
      
      // notify all observers
      NC.post(.radioHasBeenAdded, object: self as Any?)
    }
  }
  /// Parse a Filter Properties status message
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - properties:      a KeyValuesArray
  ///
  private func parseFilterProperties(_ properties: KeyValuesArray) {
    var cw = false
    var digital = false
    var voice = false

    // process each key/value pair, <key=value>
    for property in properties {
      
      // Check for Unknown Keys
      guard let token = RadioFilterSharpness(rawValue: property.key)  else {
        // log it and ignore the Key
        _log.msg("Unknown Filter token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
        continue
      }
      // Known tokens, in alphabetical order
      switch token {
        
      case .autoLevel:
        if cw {
          update(&_filterCwAutoEnabled, to: property.value.bValue, signal: \.filterCwAutoEnabled)
          cw = false
        }
        if digital {
          update(&_filterDigitalAutoEnabled, to: property.value.bValue, signal: \.filterDigitalAutoEnabled)
          digital = false
        }
        if voice {
          update(&_filterVoiceAutoEnabled, to: property.value.bValue, signal: \.filterVoiceAutoEnabled)
          voice = false
        }
        
      case .cw, .CW:
        cw = true
        
      case .digital, .DIGITAL:
        digital = true
        
      case .level:
        if cw {
          update(&_filterCwLevel, to: property.value.iValue, signal: \.filterCwLevel)
        }
        if digital {
          update(&_filterDigitalLevel, to: property.value.iValue, signal: \.filterDigitalLevel)
        }
        if voice {
          update(&_filterVoiceLevel, to: property.value.iValue, signal: \.filterVoiceLevel)
        }
        
      case .voice, .VOICE:
        voice = true
      }
    }
  }
  /// Parse a Static Net Properties status message
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - properties:      a KeyValuesArray
  ///
  private func parseStaticNetProperties(_ properties: KeyValuesArray) {
    
    // process each key/value pair, <key=value>
    for property in properties {
      
      // Check for Unknown Keys
      guard let token = RadioStaticNet(rawValue: property.key)  else {
        // log it and ignore the Key
        _log.msg("Unknown Static token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
        continue
      }
      // Known tokens, in alphabetical order
      switch token {
        
      case .gateway:
        update(&_staticGateway, to: property.value, signal: \.staticGateway)

      case .ip:
        update(&_staticIp, to: property.value, signal: \.staticIp)

      case .netmask:
        update(&_staticNetmask, to: property.value, signal: \.staticNetmask)
      }
    }
  }
  /// Parse an Oscillator Properties status message
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - properties:      a KeyValuesArray
  ///
  private func parseOscillatorProperties(_ properties: KeyValuesArray) {
      
      // process each key/value pair, <key=value>
      for property in properties {
        
        // Check for Unknown Keys
        guard let token = RadioOscillator(rawValue: property.key)  else {
          // log it and ignore the Key
          _log.msg("Unknown Oscillator token: \(property.key) = \(property.value)", level: .warning, function: #function, file: #file, line: #line)
          continue
        }
        // Known tokens, in alphabetical order
        switch token {
          
        case .extPresent:
          update(&_extPresent, to: property.value.bValue, signal: \.extPresent)

        case .gpsdoPresent:
          update(&_gpsdoPresent, to: property.value.bValue, signal: \.gpsdoPresent)

       case .locked:
          update(&_locked, to: property.value.bValue, signal: \.locked)

        case .setting:
          update(&_setting, to: property.value, signal: \.setting)

        case .state:
          update(&_state, to: property.value, signal: \.state)

        case .tcxoPresent:
          update(&_tcxoPresent, to: property.value.bValue, signal: \.tcxoPresent)
        }
      }
    }
  
  // ----------------------------------------------------------------------------
  // MARK: - Api delegate methods
  
  /// Parse inbound Tcp messages
  ///
  ///   executes on the parseQ
  ///
  /// - Parameter msg:        the Message String
  ///
  public func receivedMessage(_ msg: String) {
    
    // get all except the first character
    let suffix = String(msg.dropFirst())
    
    // switch on the first character
    switch msg[msg.startIndex] {
      
    case "H", "h":   // Handle type
      _api.connectionHandle = suffix.handle
      
    case "M", "m":   // Message Type
      parseMessage(suffix)
      
    case "R", "r":   // Reply Type
      parseReply(suffix)
      
    case "S", "s":   // Status type
      parseStatus(suffix)
      
    case "V", "v":   // Version Type
      _hardwareVersion = suffix
      
    default:    // Unknown Type
      _log.msg("Unexpected message: \(msg)", level: .warning, function: #function, file: #file, line: #line)
    }
  }
  /// Process outbound Tcp messages
  ///
  /// - Parameter msg:    the Message text
  ///
  public func sentMessage(_ text: String) {
    // unused in xLib6000
  }
  /// Add a Reply Handler for a specific Sequence/Command
  ///
  ///   executes on the parseQ
  ///
  /// - Parameters:
  ///   - sequenceId:     sequence number of the Command
  ///   - replyTuple:     a Reply Tuple
  ///
  public func addReplyHandler(_ seqNumber: SequenceId, replyTuple: ReplyTuple) {
    
    // add the handler
    replyHandlers[seqNumber] = replyTuple
  }
  /// Process the Reply to a command, reply format: <value>,<value>,...<value>
  ///
  ///   executes on the parseQ
  ///
  /// - Parameters:
  ///   - command:        the original command
  ///   - seqNum:         the Sequence Number of the original command
  ///   - responseValue:  the response value
  ///   - reply:          the reply
  ///
  public func defaultReplyHandler(_ command: String, seqNum: String, responseValue: String, reply: String) {
    
    guard responseValue == Api.kNoError else {
      
      // ignore non-zero reply from "client program" command
      if !command.hasPrefix(Api.Command.clientProgram.rawValue) {
        
        // Anything other than 0 is an error, log it and ignore the Reply
        let errorLevel = flexErrorLevel(errorCode: responseValue)
        _log.msg("c\(seqNum), \(command), non-zero reply \(responseValue), \(flexErrorString(errorCode: responseValue))", level: errorLevel, function: #function, file: #file, line: #line)

        // FIXME: ***** Temporarily commented out until bugs in v2.4.9 are fixed *****
        
//        switch errorLevel {
//
//        case "Error", "Fatal error", "Unknown error":
//          DispatchQueue.main.sync {
//            let alert = NSAlert()
//            alert.messageText = "\(errorLevel) on command\nc\(seqNum)|\(command)"
//            alert.informativeText = "\(responseValue) \n\(flexErrorString(errorCode: responseValue)) \n\nAPPLICATION WILL BE TERMINATED"
//            alert.alertStyle = .critical
//            alert.addButton(withTitle: "Ok")
//
//            let _ = alert.runModal()
//
//            // terminate App
//            NSApp.terminate(self)
//          }
//
//        default:
//          break
//        }
      }
      return
    }

    // which command?
    switch command {
      
    case Api.Command.clientGui.rawValue:          // (V3 only)
      // process the reply
      parseGuiReply( reply.keyValuesArray() )
      
    case Api.Command.clientIp.rawValue:
      // process the reply
      parseIpReply( reply.keyValuesArray() )
      
    case Api.Command.info.rawValue:
      // process the reply
      parseInfoReply( (reply.replacingOccurrences(of: "\"", with: "")).keyValuesArray(delimiter: ",") )
      
    case Api.Command.antList.rawValue:
      // save the list
      antennaList = reply.valuesArray( delimiter: "," )
      
//    case Api.Command.meterList.rawValue:                  // no longer in use
//      // process the reply
//      parseMeterListReply( reply )
      
    case Api.Command.micList.rawValue:
      // save the list
      micList = reply.valuesArray(  delimiter: "," )
      
    case xLib6000.Slice.kListCmd:
      // save the list
      sliceList = reply.valuesArray()
      
    case Radio.kUptimeCmd:
      // save the returned Uptime (seconds)
      uptime = Int(reply) ?? 0
      
    case Api.Command.version.rawValue:
      // process the reply
      parseVersionReply( reply.keyValuesArray(delimiter: "#") )

//    case Api.Command.profileMic.rawValue:
//      // save the list
//      profile.profiles[.mic] = reply.valuesArray(  delimiter: "^" )
//
//    case Api.Command.profileGlobal.rawValue:
//      // save the list
//      profile.profiles[.global] = reply.valuesArray(  delimiter: "^" )
//
//    case Api.Command.profileTx.rawValue:
//      // save the list
//      profile.profiles[.tx] = reply.valuesArray(  delimiter: "^" )
      
    default:
      
      if command.hasPrefix(Panadapter.kCmd + "create") {
        // ignore, Panadapter & Waterfall will be created when Status reply is seen
        break
        
      } else if command.hasPrefix("tnf " + "r") {
        // parse the reply
        let components = command.components(separatedBy: " ")
        
        // if it's valid and the Tnf has not been removed
        if components.count == 3 && tnfs[components[2].uValue] != nil{
          // notify all observers
          NC.post(.tnfWillBeRemoved, object: tnfs[components[2].uValue] as Any?)

          // remove the Tnf
          tnfs[components[2].uValue] = nil
        }
        
      } else if command.hasPrefix("stream create " + "dax=") {
        // TODO: add code
        break
        
      } else if command.hasPrefix("stream create " + "daxmic") {
        // TODO: add code
        break
        
      } else if command.hasPrefix("stream create " + "daxtx") {
        // TODO: add code
        break
        
      } else if command.hasPrefix("stream create " + "daxiq") {
        // TODO: add code
        break
        
      } else if command.hasPrefix("slice " + "get_error"){
        // save the errors, format: <rx_error_value>,<tx_error_value>
        sliceErrors = reply.valuesArray( delimiter: "," )
      }
    }
  }
  /// Process received UDP Vita packets
  ///
  ///   arrives on the udpReceiveQ, calls targets on the streamQ
  ///
  /// - Parameter vitaPacket:       a Vita packet
  ///
  public func vitaParser(_ vitaPacket: Vita) {
    
    // Pass the stream to the appropriate object (checking for existence of the object first)
    switch (vitaPacket.classCode) {
      
    case .daxAudio:
      // Dax Microphone Audio
      if let daxAudio = audioStreams[vitaPacket.streamId] {
        daxAudio.vitaProcessor(vitaPacket)
      }
      // Dax Slice Audio
      if let daxMicAudio = micAudioStreams[vitaPacket.streamId] {
        daxMicAudio.vitaProcessor(vitaPacket)
      }
      
    case .daxIq24, .daxIq48, .daxIq96, .daxIq192:
      // Dax IQ
      if let daxIq = iqStreams[vitaPacket.streamId] {
        
        daxIq.vitaProcessor(vitaPacket)
      }
      
    case .meter:
      // Meter - unlike other streams, the Meter stream contains multiple Meters
      //         and must be processed by a class method on the Meter object
      Meter.vitaProcessor(vitaPacket, radio: self)
      
    case .opus:
      // Opus
      if let opus = opusStreams[vitaPacket.streamId] {
        
        if opus.isStreaming == false {
          opus.isStreaming = true
          // log the start of the stream
          _log.msg("Opus Stream started: Stream Id = \(vitaPacket.streamId.hex)", level: .info, function: #function, file: #file, line: #line)
        }
        opus.vitaProcessor( vitaPacket )
      }
      
    case .panadapter:
      // Panadapter
      if let panadapter = panadapters[vitaPacket.streamId] {
        
        if panadapter.isStreaming == false {
          panadapter.isStreaming = true
          // log the start of the stream
          _log.msg("Panadapter Stream started: Stream Id = \(vitaPacket.streamId.hex)", level: .info, function: #function, file: #file, line: #line)
        }
        panadapter.vitaProcessor(vitaPacket)
      }
      
    case .waterfall:
      // Waterfall
      if let waterfall = waterfalls[vitaPacket.streamId] {
        
        if waterfall.isStreaming == false {
          waterfall.isStreaming = true
          // log the start of the stream
          _log.msg("Waterfall Stream started: Stream Id = \(vitaPacket.streamId.hex)", level: .info, function: #function, file: #file, line: #line)
        }
        waterfall.vitaProcessor(vitaPacket)
      }
      
    default:
      // log the error
      _log.msg("UDP Stream error, no object: \(vitaPacket.classCode.description()) Stream Id = \(vitaPacket.streamId.hex)", level: .error, function: #function, file: #file, line: #line)
    }
  }
}

extension Radio {
 
  // ----------------------------------------------------------------------------
  // MARK: - Public properties (KVO compliant)
  
  @objc dynamic public var atuPresent: Bool {
    return _atuPresent }
  
  @objc dynamic public var availablePanadapters: Int {
    return _availablePanadapters }
  
  @objc dynamic public var availableSlices: Int {
    return _availableSlices }
  
  @objc dynamic public var chassisSerial: String {
    return _chassisSerial }
  
  @objc dynamic public var clientIp: String {
    return _clientIp }
  
  @objc dynamic public var daxIqAvailable: Int {
    return _daxIqAvailable }
  
  @objc dynamic public var daxIqCapacity: Int {
    return _daxIqCapacity }
  
  @objc dynamic public var extPresent: Bool {
    return _extPresent }
  
  @objc dynamic public var fpgaMbVersion: String {
    return _fpgaMbVersion }
  
  @objc dynamic public var gateway: String {
    return _gateway }
  
  @objc dynamic public var gpsPresent: Bool {
    return _gpsPresent }
  
  @objc dynamic public var gpsdoPresent: Bool {
    return _gpsdoPresent }
  
  @objc dynamic public var ipAddress: String {
    return _ipAddress }
  
  @objc dynamic public var location: String {
    return _location }
  
  @objc dynamic public var locked: Bool {
    return _locked }
  
  @objc dynamic public var macAddress: String {
    return _macAddress }
  
  @objc dynamic public var netmask: String {
    return _netmask }
  
  @objc dynamic public var numberOfScus: Int {
    return _numberOfScus }
  
  @objc dynamic public var numberOfSlices: Int {
    return _numberOfSlices }
  
  @objc dynamic public var numberOfTx: Int {
    return _numberOfTx }
  
  @objc dynamic public var picDecpuVersion: String {
    return _picDecpuVersion }
  
  @objc dynamic public var psocMbPa100Version: String {
    return _psocMbPa100Version }
  
  @objc dynamic public var psocMbtrxVersion: String {
    return _psocMbtrxVersion }
  
  @objc dynamic public var radioModel: String {
    return _radioModel }
  
  @objc dynamic public var radioOptions: String {
    return _radioOptions }
  
  @objc dynamic public var region: String {
    return _region }
  
  @objc dynamic public var setting: String {
    return _setting }
  
  @objc dynamic public var smartSdrMB: String {
    return _smartSdrMB }
  
  @objc dynamic public var state: String {
    return _state }
  
  @objc dynamic public var softwareVersion: String {
    return _softwareVersion }

  @objc dynamic public var tcxoPresent: Bool {
    return _tcxoPresent }
  
  // ----------------------------------------------------------------------------
  // MARK: - Tokens
  
  /// Clients (V3 only)
  ///
  internal enum ClientToken : String {
    case host
    case id                             = "client_id"
    case ip
    case localPttEnabled                = "local_ptt"
    case program
    case station
  }
  /// Types
  ///
  internal enum DisplayToken: String {
    case panadapter                         = "pan"
    case waterfall
  }
  /// EqApf
  ///
  internal enum EqApfToken: String {
    case gain
    case mode
    case qFactor
  }
  /// Info properties
  ///
  internal enum InfoToken: String {
    case atuPresent                         = "atu_present"
    case callsign
    case chassisSerial                      = "chassis_serial"
    case gateway
    case gps
    case ipAddress                          = "ip"
    case location
    case macAddress                         = "mac"
    case model
    case netmask
    case name
    case numberOfScus                       = "num_scu"
    case numberOfSlices                     = "num_slice"
    case numberOfTx                         = "num_tx"
    case options
    case region
    case screensaver
    case softwareVersion                    = "software_ver"
  }
  /// Radio properties
  ///
  internal enum RadioToken: String {
    case backlight
    case bandPersistenceEnabled             = "band_persistence_enabled"
    case binauralRxEnabled                  = "binaural_rx"
    case calFreq                            = "cal_freq"
    case callsign
    case daxIqAvailable                     = "daxiq_available"                 // (V3 only)
    case daxIqCapacity                      = "daxiq_capacity"                  // (V3 only)
    case enforcePrivateIpEnabled            = "enforce_private_ip_connections"
    case freqErrorPpb                       = "freq_error_ppb"
    case frontSpeakerMute                   = "front_speaker_mute"
    case fullDuplexEnabled                  = "full_duplex_enabled"
    case headphoneGain                      = "headphone_gain"                  // "headphone gain"
    case headphoneMute                      = "headphone_mute"                  // "headphone mute"
    case lineoutGain                        = "lineout_gain"                    // "lineout gain"
    case lineoutMute                        = "lineout_mute"                    // "lineout mute"
    case muteLocalAudio                     = "mute_local_audio_when_remote"
    case nickname                                                               // "name"
    case panadapters
    case pllDone                            = "pll_done"
    case remoteOnEnabled                    = "remote_on_enabled"
    case rttyMark                           = "rtty_mark_default"
    case slices
    case snapTuneEnabled                    = "snap_tune_enabled"
    case tnfsEnabled                        = "tnf_enabled"
  }
  /// Radio categories
  ///
  internal enum RadioTokenCategory: String {
    case filterSharpness                    = "filter_sharpness"
    case staticNetParams                    = "static_net_params"
    case oscillator
  }
  /// Sharpness properties
  ///
  internal enum RadioFilterSharpness: String {
    case cw
    case CW
    case digital
    case DIGITAL
    case voice
    case VOICE
    case autoLevel                          = "auto_level"
    case level
  }
  /// Static Net properties
  ///
  internal enum RadioStaticNet: String {
    case gateway
    case ip
    case netmask
  }
  /// Oscillator properties
  ///
  internal enum RadioOscillator: String {
    case extPresent                         = "ext_present"
    case gpsdoPresent                       = "gpsdo_present"
    case locked
    case setting
    case state
    case tcxoPresent                        = "tcxo_present"
  }
  /// Status properties
  ///
  internal enum StatusToken : String {
    case amplifier
    case audioStream                        = "audio_stream"  // (pre V3 only)
    case atu
    case client
    case cwx
    case daxiq      // obsolete token, included to prevent log messages
    case display
    case eq
    case file
    case gps
    case interlock
    case memory
    case meter
    case micAudioStream                     = "mic_audio_stream"  // (pre V3 only)
    case mixer
    case opusStream                         = "opus_stream"
    case profile
    case radio
    case slice
    case stream
    case tnf
    case transmit
    case turf
    case txAudioStream                      = "tx_audio_stream"  // (pre V3 only)
    case usbCable                           = "usb_cable"
    case wan
    case waveform
    case xvtr
  }
  /// Version properties
  ///
  internal enum VersionToken: String {
    case fpgaMb                             = "fpga-mb"
    case psocMbPa100                        = "psoc-mbpa100"
    case psocMbTrx                          = "psoc-mbtrx"
    case smartSdrMB                         = "smartsdr-mb"
    case picDecpu                           = "pic-decpu"
  }
  /// Filter properties
  ///
  public struct FilterSpec {
    var filterHigh                          : Int
    var filterLow                           : Int
    var label                               : String
    var mode                                : String
    var txFilterHigh                        : Int
    var txFilterLow                         : Int
  }
  /// Tx Filter properties
  ///
  public struct TxFilter {
    var high                                = 0
    var low                                 = 0
  }
  
  // --------------------------------------------------------------------------------
  // MARK: - Aliases
  
  public typealias AntennaPort              = String
  public typealias FilterMode               = String
  public typealias MicrophonePort           = String
  public typealias RfGainValue              = String
}
