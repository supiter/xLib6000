//
//  Xvtr.swift
//  xLib6000
//
//  Created by Douglas Adams on 6/24/17.
//  Copyright © 2017 Douglas Adams. All rights reserved.
//

public typealias XvtrId = ObjectId

import Foundation

/// Xvtr Class implementation
///
///      creates an Xvtr instance to be used by a Client to support the
///      processing of an Xvtr. Xvtr objects are added, removed and updated by
///      the incoming TCP messages. They are collected in the xvtrs
///      collection on the Radio object.
///
public final class Xvtr : NSObject, DynamicModel {
  
  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  public let id : XvtrId
  
  @objc dynamic public var ifFrequency: Hz {
    get { _ifFrequency }
    set { if _ifFrequency != newValue { _ifFrequency = newValue ; xvtrCmd( .ifFrequency, newValue) }}}

  @objc dynamic public var isValid: Bool { _isValid }

  @objc dynamic public var loError: Int {
    get { _loError }
    set { if _loError != newValue { _loError = newValue ; xvtrCmd( .loError, newValue) }}}

  @objc dynamic public var name: String {
    get { _name }
    set { if _name != newValue { _name = newValue ; xvtrCmd( .name, _name) }}}

  @objc dynamic public var maxPower: Int {
    get { _maxPower }
    set { if _maxPower != newValue { _maxPower = newValue ; xvtrCmd( .maxPower, newValue) }}}

  @objc dynamic public var order: Int {
    get { _order }
    set { if _order != newValue { _order = newValue ; xvtrCmd( .order, newValue) }}}

  @objc dynamic public var preferred: Bool { _preferred }

  @objc dynamic public var rfFrequency: Hz {
    get { _rfFrequency }
    set { if _rfFrequency != newValue { _rfFrequency = newValue ; xvtrCmd( .rfFrequency, newValue) }}}

  @objc dynamic public var rxGain: Int {
    get { _rxGain }
    set { if _rxGain != newValue { _rxGain = newValue ; xvtrCmd( .rxGain, newValue) }}}

  @objc dynamic public var rxOnly: Bool {
    get { _rxOnly }
    set { if _rxOnly != newValue { _rxOnly = newValue ; xvtrCmd( .rxOnly, newValue) }}}

  @objc dynamic public var twoMeterInt: Int { _twoMeterInt }
  
  // ----------------------------------------------------------------------------
  // MARK: - Internal properties
  
  var _ifFrequency : Hz {
    get { Api.objectQ.sync { __ifFrequency } }
    set { Api.objectQ.sync(flags: .barrier) {__ifFrequency = newValue }}}
  var _isValid : Bool {
    get { Api.objectQ.sync { __isValid } }
    set { Api.objectQ.sync(flags: .barrier) {__isValid = newValue }}}
  var _loError : Int {
    get { Api.objectQ.sync { __loError } }
    set { Api.objectQ.sync(flags: .barrier) {__loError = newValue }}}
  var _name : String {
    get { Api.objectQ.sync { __name } }
    set { Api.objectQ.sync(flags: .barrier) {__name = String(newValue.prefix(4)) }}}
  var _maxPower : Int {
    get { Api.objectQ.sync { __maxPower } }
    set { Api.objectQ.sync(flags: .barrier) {__maxPower = newValue }}}
  var _order : Int {
    get { Api.objectQ.sync { __order } }
    set { Api.objectQ.sync(flags: .barrier) {__order = newValue }}}
  var _preferred : Bool {
    get { Api.objectQ.sync { __preferred } }
    set { Api.objectQ.sync(flags: .barrier) {__preferred = newValue }}}
  var _rfFrequency : Hz {
    get { Api.objectQ.sync { __rfFrequency } }
    set { Api.objectQ.sync(flags: .barrier) {__rfFrequency = newValue }}}
  var _rxGain : Int {
    get { Api.objectQ.sync { __rxGain } }
    set { Api.objectQ.sync(flags: .barrier) {__rxGain = newValue }}}
  var _rxOnly : Bool {
    get { Api.objectQ.sync { __rxOnly } }
    set { Api.objectQ.sync(flags: .barrier) {__rxOnly = newValue }}}
  var _twoMeterInt : Int {
    get { Api.objectQ.sync { __twoMeterInt } }
    set { Api.objectQ.sync(flags: .barrier) {__twoMeterInt = newValue }}}

  enum Token : String {
    case name
    case ifFrequency        = "if_freq"
    case isValid            = "is_valid"
    case loError            = "lo_error"
    case maxPower           = "max_power"
    case order
    case preferred
    case rfFrequency        = "rf_freq"
    case rxGain             = "rx_gain"
    case rxOnly             = "rx_only"
    case twoMeterInt        = "two_meter_int"
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private properties

  private var _initialized = false
  private let _log         = Log.sharedInstance.logMessage
  private let _radio       : Radio

  // ----------------------------------------------------------------------------
  // MARK: - Initialization
  
  /// Initialize an Xvtr
  ///
  /// - Parameters:
  ///   - radio:              the Radio instance
  ///   - id:                 an Xvtr Id
  ///
  public init(radio: Radio, id: XvtrId) {
    _radio = radio
    self.id = id
    super.init()
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Class methods

  /// Parse an Xvtr status message
  ///
  ///   StatusParser protocol method, executes on the parseQ
  ///
  /// - Parameters:
  ///   - keyValues:      a KeyValuesArray
  ///   - radio:          the current Radio class
  ///   - queue:          a parse Queue for the object
  ///   - inUse:          false = "to be deleted"
  ///
  class func parseStatus(_ radio: Radio, _ properties: KeyValuesArray, _ inUse: Bool = true ) {
    // Format:  <id, > <name, > <"rf_freq", value> <"if_freq", value> <"lo_error", value> <"max_power", value>
    //              <"rx_gain",value> <"order", value> <"rx_only", 1|0> <"is_valid", 1|0> <"preferred", 1|0>
    //              <"two_meter_int", value>
    //      OR
    // Format: <id, > <"in_use", 0>
    
    // get the id
    if let id = properties[0].key.objectId {
      
      // isthe Xvtr in use?
      if inUse {
        
        // YES, does the object exist?
        if radio.xvtrs[id] == nil {
          
          // NO, create a new Xvtr & add it to the Xvtrs collection
          radio.xvtrs[id] = Xvtr(radio: radio, id: id)
        }
        // pass the remaining key values to the Xvtr for parsing
        radio.xvtrs[id]!.parseProperties(radio, Array(properties.dropFirst(1)) )
        
      } else {
        
        // does it exist?
        if radio.xvtrs[id] != nil {
          
          // YES, remove it, notify all observers
          NC.post(.xvtrWillBeRemoved, object: radio.xvtrs[id] as Any?)

          radio.xvtrs[id] = nil
          
          Log.sharedInstance.logMessage(Self.className() + " removed: id = \(id)", .debug, #function, #file, #line)
          
          NC.post(.xvtrHasBeenRemoved, object: id as Any?)
        }
      }
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Instance methods
  
  /// Parse Xvtr key/value pairs
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameter properties:       a KeyValuesArray
  ///
  func parseProperties(_ radio: Radio, _ properties: KeyValuesArray) {
    
    // process each key/value pair, <key=value>
    for property in properties {
      
      // check for unknown Keys
      guard let token = Token(rawValue: property.key) else {
        // log it and ignore the Key
        _log(Self.className() + " unknown token: \(property.key) = \(property.value)", .warning, #function, #file, #line)
        continue
      }
      // Known keys, in alphabetical order
      switch token {

        case .name:         willChangeValue(for: \.name)        ; _name = property.value                ; didChangeValue(for: \.name)
        case .ifFrequency:  willChangeValue(for: \.ifFrequency) ; _ifFrequency = property.value.mhzToHz ; didChangeValue(for: \.ifFrequency)
        case .isValid:      willChangeValue(for: \.isValid)     ; _isValid = property.value.bValue      ; didChangeValue(for: \.isValid)
        case .loError:      willChangeValue(for: \.loError)     ; _loError = property.value.iValue      ; didChangeValue(for: \.loError)
        case .maxPower:     willChangeValue(for: \.maxPower)    ; _maxPower = property.value.iValue     ; didChangeValue(for: \.maxPower)
        case .order:        willChangeValue(for: \.order)       ; _order = property.value.iValue        ; didChangeValue(for: \.order)
        case .preferred:    willChangeValue(for: \.preferred)   ; _preferred = property.value.bValue    ; didChangeValue(for: \.preferred)
        case .rfFrequency:  willChangeValue(for: \.rfFrequency) ; _rfFrequency = property.value.mhzToHz ; didChangeValue(for: \.rfFrequency)
        case .rxGain:       willChangeValue(for: \.rxGain)      ; _rxGain = property.value.iValue       ; didChangeValue(for: \.rxGain)
        case .rxOnly:       willChangeValue(for: \.rxOnly)      ; _rxOnly = property.value.bValue       ; didChangeValue(for: \.rxOnly)
        case .twoMeterInt:  willChangeValue(for: \.twoMeterInt) ; _twoMeterInt = property.value.iValue  ; didChangeValue(for: \.twoMeterInt)
      }
    }
    // is the waterfall initialized?
    if !_initialized {
      
      // YES, the Radio (hardware) has acknowledged this Waterfall
      _initialized = true
      
      _log(Self.className() + " added: id = \(id)", .debug, #function, #file, #line)

      // notify all observers
      NC.post(.xvtrHasBeenAdded, object: self as Any?)
    }
  }
  /// Remove this Xvtr
  ///
  /// - Parameters:
  ///   - callback:           ReplyHandler (optional)
  ///
  public func remove(callback: ReplyHandler? = nil) {
    _radio.sendCommand("xvtr remove " + "\(id)", replyTo: callback)
    
    // notify all observers
//    NC.post(.xvtrWillBeRemoved, object: self as Any?)
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  /// Set an Xvtr property on the Radio
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func xvtrCmd(_ token: Token, _ value: Any) {
    _radio.sendCommand("xvtr set " + "\(id) " + token.rawValue + "=\(value)")
  }
  
  // ----------------------------------------------------------------------------
  // *** Hidden properties (Do NOT use) ***
  
  private var __ifFrequency : Hz = 0
  private var __isValid     = false
  private var __loError     = 0
  private var __name        = ""
  private var __maxPower    = 0
  private var __order       = 0
  private var __preferred   = false
  private var __rfFrequency : Hz = 0
  private var __rxGain      = 0
  private var __rxOnly      = false
  private var __twoMeterInt = 0
}
