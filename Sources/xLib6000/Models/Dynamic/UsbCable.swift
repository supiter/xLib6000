//
//  UsbCable.swift
//  xLib6000
//
//  Created by Douglas Adams on 6/25/17.
//  Copyright © 2017 Douglas Adams. All rights reserved.
//

import Foundation

public typealias UsbCableId = String

/// USB Cable Class implementation
///
///      creates a USB Cable instance to be used by a Client to support the
///      processing of USB connections to the Radio (hardware). USB Cable objects
///      are added, removed and updated by the incoming TCP messages. They are
///      collected in the usbCables collection on the Radio object.
///
public final class UsbCable : NSObject, DynamicModel {
    
  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  public let id                             : UsbCableId

  @objc dynamic public var autoReport: Bool {
    get { _autoReport }
    set { if _autoReport != newValue { _autoReport = newValue ; usbCableCmd( .autoReport, newValue.as1or0) }}}
  @objc dynamic public var band: String {
    get { _band }
    set { if _band != newValue { _band = newValue ; usbCableCmd( .band, newValue) }}}
  @objc dynamic public var dataBits: Int {
    get { _dataBits }
    set { if _dataBits != newValue { _dataBits = newValue ; usbCableCmd( .dataBits, newValue) }}}
  @objc dynamic public var enable: Bool {
    get { _enable }
    set { if _enable != newValue { _enable = newValue ; usbCableCmd( .enable, newValue.as1or0) }}}
  @objc dynamic public var flowControl: String {
    get { _flowControl }
    set { if _flowControl != newValue { _flowControl = newValue ; usbCableCmd( .flowControl, newValue) }}}
  @objc dynamic public var name: String {
    get { _name }
    set { if _name != newValue { _name = newValue ; usbCableCmd( .name, newValue) }}}
  @objc dynamic public var parity: String {
    get { _parity }
    set { if _parity != newValue { _parity = newValue ; usbCableCmd( .parity, newValue) }}}
  @objc dynamic public var pluggedIn: Bool {
    get { _pluggedIn }
    set { if _pluggedIn != newValue { _pluggedIn = newValue ; usbCableCmd( .pluggedIn, newValue.as1or0) }}}
  @objc dynamic public var polarity: String {
    get { _polarity }
    set { if _polarity != newValue { _polarity = newValue ; usbCableCmd( .polarity, newValue) }}}
  @objc dynamic public var preamp: String {
    get { _preamp }
    set { if _preamp != newValue { _preamp = newValue ; usbCableCmd( .preamp, newValue) }}}
  @objc dynamic public var source: String {
    get { _source }
    set { if _source != newValue { _source = newValue ; usbCableCmd( .source, newValue) }}}
  @objc dynamic public var sourceRxAnt: String {
    get { _sourceRxAnt }
    set { if _sourceRxAnt != newValue { _sourceRxAnt = newValue ; usbCableCmd( .sourceRxAnt, newValue) }}}
  @objc dynamic public var sourceSlice: Int {
    get { _sourceSlice }
    set { if _sourceSlice != newValue { _sourceSlice = newValue ; usbCableCmd( .sourceSlice, newValue) }}}
  @objc dynamic public var sourceTxAnt: String {
    get { _sourceTxAnt }
    set { if _sourceTxAnt != newValue { _sourceTxAnt = newValue ; usbCableCmd( .sourceTxAnt, newValue) }}}
  @objc dynamic public var speed: Int {
    get { _speed }
    set { if _speed != newValue { _speed = newValue ; usbCableCmd( .speed, newValue) }}}
  @objc dynamic public var stopBits: Int {
    get { _stopBits }
    set { if _stopBits != newValue { _stopBits = newValue ; usbCableCmd( .stopBits, newValue) }}}
  @objc dynamic public var usbLog: Bool {
    get { _usbLog }
    set { if _usbLog != newValue { _usbLog = newValue ; usbCableCmd( .usbLog, newValue.as1or0) } } }

  public private(set) var cableType         : UsbCableType

  public enum UsbCableType: String {
    case bcd
    case bit
    case cat
    case dstar
    case invalid
    case ldpa
  }

  // ----------------------------------------------------------------------------
  // MARK: - Internal properties
  
  var _autoReport : Bool {
    get { Api.objectQ.sync { __autoReport } }
    set { Api.objectQ.sync(flags: .barrier) {__autoReport = newValue }}}
  var _band : String {
    get { Api.objectQ.sync { __band } }
    set { Api.objectQ.sync(flags: .barrier) {__band = newValue }}}
  var _dataBits : Int {
    get { Api.objectQ.sync { __dataBits } }
    set { Api.objectQ.sync(flags: .barrier) {__dataBits = newValue }}}
  var _enable : Bool {
    get { Api.objectQ.sync { __enable } }
    set { Api.objectQ.sync(flags: .barrier) {__enable = newValue }}}
  var _flowControl : String {
    get { Api.objectQ.sync { __flowControl } }
    set { Api.objectQ.sync(flags: .barrier) {__flowControl = newValue }}}
  var _name : String {
    get { Api.objectQ.sync { __name } }
    set { Api.objectQ.sync(flags: .barrier) {__name = newValue }}}
  var _parity : String {
    get { Api.objectQ.sync { __parity } }
    set { Api.objectQ.sync(flags: .barrier) {__parity = newValue }}}
  var _pluggedIn : Bool {
    get { Api.objectQ.sync { __pluggedIn } }
    set { Api.objectQ.sync(flags: .barrier) {__pluggedIn = newValue }}}
  var _polarity : String {
    get { Api.objectQ.sync { __polarity } }
    set { Api.objectQ.sync(flags: .barrier) {__polarity = newValue }}}
  var _preamp : String {
    get { Api.objectQ.sync { __preamp } }
    set { Api.objectQ.sync(flags: .barrier) {__preamp = newValue }}}
  var _source : String {
    get { Api.objectQ.sync { __source } }
    set { Api.objectQ.sync(flags: .barrier) {__source = newValue }}}
  var _sourceRxAnt : String {
    get { Api.objectQ.sync { __sourceRxAnt } }
    set { Api.objectQ.sync(flags: .barrier) {__sourceRxAnt = newValue }}}
  var _sourceSlice : Int {
    get { Api.objectQ.sync { __sourceSlice } }
    set { Api.objectQ.sync(flags: .barrier) {__sourceSlice = newValue }}}
  var _sourceTxAnt : String {
    get { Api.objectQ.sync { __sourceTxAnt } }
    set { Api.objectQ.sync(flags: .barrier) {__sourceTxAnt = newValue }}}
  var _speed : Int {
    get { Api.objectQ.sync { __speed } }
    set { Api.objectQ.sync(flags: .barrier) {__speed = newValue }}}
  var _stopBits : Int {
    get { Api.objectQ.sync { __stopBits } }
    set { Api.objectQ.sync(flags: .barrier) {__stopBits = newValue }}}
  var _usbLog : Bool {
    get { Api.objectQ.sync { __usbLog } }
    set { Api.objectQ.sync(flags: .barrier) {__usbLog = newValue }}}
  var _usbLogLine : String {
    get { Api.objectQ.sync { __usbLogLine } }
    set { Api.objectQ.sync(flags: .barrier) {__usbLogLine = newValue }}}

  enum Token : String {
    case autoReport       = "auto_report"
    case band
    case cableType        = "type"
    case dataBits         = "data_bits"
    case enable
    case flowControl      = "flow_control"
    case name
    case parity
    case pluggedIn        = "plugged_in"
    case polarity
    case preamp
    case source
    case sourceRxAnt      = "source_rx_ant"
    case sourceSlice      = "source_slice"
    case sourceTxAnt      = "source_tx_ant"
    case speed
    case stopBits         = "stop_bits"
    case usbLog           = "log"
    //        case usbLogLine = "log_line"
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Private properties
  
  private var _initialized                  = false
  private let _log                          = Log.sharedInstance.logMessage
  private let _radio                        : Radio

  // ------------------------------------------------------------------------------
  // MARK: - Class methods
  
  /// Parse a USB Cable status message
  ///
  ///   StatusParser Protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:      a KeyValuesArray
  ///   - radio:          the current Radio class
  ///   - queue:          a parse Queue for the object
  ///   - inUse:          false = "to be deleted"
  ///
  class func parseStatus(_ radio: Radio, _ keyValues: KeyValuesArray, _ inUse: Bool = true) {
    // TYPE: CAT
    //      <id, > <type, > <enable, > <pluggedIn, > <name, > <source, > <sourceTxAnt, > <sourceRxAnt, > <sourceSLice, >
    //      <autoReport, > <preamp, > <polarity, > <log, > <speed, > <dataBits, > <stopBits, > <parity, > <flowControl, >
    //
    
    // FIXME: Need other formats
    
    // get the UsbCable Id
    let usbCableId = keyValues[0].key
    
    // does the UsbCable exist?
    if radio.usbCables[usbCableId] == nil {
      
      // NO, is it a valid cable type?
      if let cableType = UsbCable.UsbCableType(rawValue: keyValues[1].value) {
        
        // YES, create a new UsbCable & add it to the UsbCables collection
        radio.usbCables[usbCableId] = UsbCable(radio: radio, id: usbCableId, cableType: cableType)
        
      } else {
        
        // NO, log the error and ignore it
        Log.sharedInstance.logMessage("Invalid UsbCable Type: \(keyValues[1].value)", .warning, #function, #file, #line)

        return
      }
    }
    // pass the remaining key values to the Usb Cable for parsing (dropping the Id)
    radio.usbCables[usbCableId]!.parseProperties(radio, Array(keyValues.dropFirst(1)) )
  }

  // ------------------------------------------------------------------------------
  // MARK: - Initialization
  
  /// Initialize a UsbCable
  ///
  /// - Parameters:
  ///   - radio:              the Radio instance
  ///   - id:                 a Cable Id
  ///   - cableType:          the type of UsbCable
  ///
  public init(radio: Radio, id: UsbCableId, cableType: UsbCableType) {
    
    _radio = radio
    self.id = id
    self.cableType = cableType
    super.init()
  }
  
  // ------------------------------------------------------------------------------
  // MARK: - Instance methods

  /// Parse USB Cable key/value pairs
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameter properties:       a KeyValuesArray
  ///
  func parseProperties(_ radio: Radio, _ properties: KeyValuesArray) {
    // TYPE: CAT
    //      <type, > <enable, > <pluggedIn, > <name, > <source, > <sourceTxAnt, > <sourceRxAnt, > <sourceSLice, > <autoReport, >
    //      <preamp, > <polarity, > <log, > <speed, > <dataBits, > <stopBits, > <parity, > <flowControl, >
    //
    // SA3923BB8|usb_cable A5052JU7 type=cat enable=1 plugged_in=1 name=THPCATCable source=tx_ant source_tx_ant=ANT1 source_rx_ant=ANT1 source_slice=0 auto_report=1 preamp=0 polarity=active_low band=0 log=0 speed=9600 data_bits=8 stop_bits=1 parity=none flow_control=none
    
    
    // FIXME: Need other formats
    
    // is the Status for a cable of this type?
    if cableType.rawValue == properties[0].value {
      
      // YES,
      // process each key/value pair, <key=value>
      for property in properties {
        
        // check for unknown Keys
        guard let token = Token(rawValue: property.key) else {
          // log it and ignore the Key
          _log("Unknown UsbCable token: \(property.key) = \(property.value)", .warning, #function, #file, #line)
          continue
        }
        // Known keys, in alphabetical order
        switch token {
          
        case .autoReport:   update(self, &_autoReport,  to: property.value.bValue,  signal: \.autoReport)
        case .band:         update(self, &_band,        to: property.value,         signal: \.band)
        case .cableType:    break
        case .dataBits:     update(self, &_dataBits,    to: property.value.iValue,  signal: \.dataBits)
        case .enable:       update(self, &_enable,      to: property.value.bValue,  signal: \.enable)
        case .flowControl:  update(self, &_flowControl, to: property.value,         signal: \.flowControl)
        case .name:         update(self, &_name,        to: property.value,         signal: \.name)
        case .parity:       update(self, &_parity,      to: property.value,         signal: \.parity)
        case .pluggedIn:    update(self, &_pluggedIn,   to: property.value.bValue,  signal: \.pluggedIn)
        case .polarity:     update(self, &_polarity,    to: property.value,         signal: \.polarity)
        case .preamp:       update(self, &_preamp,      to: property.value,         signal: \.preamp)
        case .source:       update(self, &_source,      to: property.value,         signal: \.source)
        case .sourceRxAnt:  update(self, &_sourceRxAnt, to: property.value,         signal: \.sourceRxAnt)
        case .sourceSlice:  update(self, &_sourceSlice, to: property.value.iValue,  signal: \.sourceSlice)
        case .sourceTxAnt:  update(self, &_sourceTxAnt, to: property.value,         signal: \.sourceTxAnt)
        case .speed:        update(self, &_speed,       to: property.value.iValue,  signal: \.speed)
        case .stopBits:     update(self, &_stopBits,    to: property.value.iValue,  signal: \.stopBits)
        case .usbLog:       update(self, &_usbLog,      to: property.value.bValue,  signal: \.usbLog)

          //                case .usbLogLine:
          //                    willChangeValue(forKey: "usbLogLine")
          //                    _usbLogLine = property.value
          //                    didChangeValue(forKey: "usbLogLine")
        }
      }
      
    } else {
      
      // NO, log the error
      _log("Status type: \(properties[0].key) != Cable type: \(cableType.rawValue)", .warning, #function, #file, #line)
    }
    
    // is the waterfall initialized?
    if !_initialized {
      
      // YES, the Radio (hardware) has acknowledged this UsbCable
      _initialized = true
      
      // notify all observers
      NC.post(.usbCableHasBeenAdded, object: self as Any?)
    }
  }
  /// Remove this UsbCable
  ///
  /// - Parameters:
  ///   - callback:           ReplyHandler (optional)
  ///
  public func remove(callback: ReplyHandler? = nil){
    
    // tell the Radio to remove a USB Cable
    _radio.sendCommand("usb_cable " + "remove" + " \(id)")
    
    // notify all observers
    NC.post(.usbCableWillBeRemoved, object: self as Any?)
  }
  
  // ----------------------------------------------------------------------------
  // Private methods

  /// Send a command to Set a USB Cable property
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func usbCableCmd(_ token: Token, _ value: Any) {
    _radio.sendCommand("usb_cable set " + "\(id) " + token.rawValue + "=\(value)")
  }
  
  // ----------------------------------------------------------------------------
  // *** Hidden properties (Do NOT use) ***
  
  private var __autoReport  = false
  private var __band        = ""
  private var __dataBits    = 0
  private var __enable      = false
  private var __flowControl = ""
  private var __name        = ""
  private var __parity      = ""
  private var __pluggedIn   = false
  private var __polarity    = ""
  private var __preamp      = ""
  private var __source      = ""
  private var __sourceRxAnt = ""
  private var __sourceSlice = 0
  private var __sourceTxAnt = ""
  private var __speed       = 0
  private var __stopBits    = 0
  private var __usbLog      = false
  private var __usbLogLine  = ""
}

