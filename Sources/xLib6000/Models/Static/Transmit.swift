//
//  Transmit.swift
//  xLib6000
//
//  Created by Douglas Adams on 8/16/17.
//  Copyright © 2017 Douglas Adams. All rights reserved.
//

import Foundation

/// Transmit Class implementation
///
///      creates a Transmit instance to be used by a Client to support the
///      processing of the Transmit-related activities. Transmit objects are added,
///      removed and updated by the incoming TCP messages.
///
public final class Transmit : NSObject, StaticModel {
  
  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  // ***** CW COMMANDS *****
  
  @objc dynamic public var cwBreakInDelay: Int {
    get { _cwBreakInDelay }
    set { if _cwBreakInDelay != newValue { _cwBreakInDelay = newValue ; cwCmd( .cwBreakInDelay, newValue) }}}
  @objc dynamic public var cwBreakInEnabled: Bool {
    get { _cwBreakInEnabled }
    set { if _cwBreakInEnabled != newValue { _cwBreakInEnabled = newValue ; cwCmd( .cwBreakInEnabled, newValue.as1or0) }}}
  @objc dynamic public var cwIambicEnabled: Bool {
    get { _cwIambicEnabled }
    set { if _cwIambicEnabled != newValue { _cwIambicEnabled = newValue ; cwCmd( .cwIambicEnabled, newValue.as1or0) }}}
  @objc dynamic public var cwIambicMode: Int {
    get { _cwIambicMode }
    set { if _cwIambicMode != newValue { _cwIambicMode = newValue ; cwCmd( "mode", newValue) }}}
  @objc dynamic public var cwlEnabled: Bool {
    get { _cwlEnabled }
    set { if _cwlEnabled != newValue { _cwlEnabled = newValue ; cwCmd( .cwlEnabled, newValue.as1or0) }}}
  @objc dynamic public var cwPitch: Int {
    get { _cwPitch }
    set { if _cwPitch != newValue { _cwPitch = newValue ; cwCmd( .cwPitch, newValue) }}}
  @objc dynamic public var cwSidetoneEnabled: Bool {
    get { _cwSidetoneEnabled }
    set { if _cwSidetoneEnabled != newValue { _cwSidetoneEnabled = newValue ; cwCmd( .cwSidetoneEnabled, newValue.as1or0) }}}
  @objc dynamic public var cwSpeed: Int {
    get { _cwSpeed }
    set { if _cwSpeed != newValue { _cwSpeed = newValue ; cwCmd( "wpm", newValue) }}}
  @objc dynamic public var cwSwapPaddles: Bool {
    get { _cwSwapPaddles }
    set { if _cwSwapPaddles != newValue { _cwSwapPaddles = newValue ; cwCmd( "swap", newValue.as1or0) }}}
  @objc dynamic public var cwSyncCwxEnabled: Bool {
    get { _cwSyncCwxEnabled }
    set { if _cwSyncCwxEnabled != newValue { _cwSyncCwxEnabled = newValue ; cwCmd( .cwSyncCwxEnabled, newValue.as1or0) }}}
  // ***** MIC COMMANDS *****
  
  @objc dynamic public var micAccEnabled: Bool {
    get { _micAccEnabled }
    set { if _micAccEnabled != newValue { _micAccEnabled = newValue ; micCmd( "acc", newValue.asOnOff) }}}
  @objc dynamic public var micBiasEnabled: Bool {
    get { _micBiasEnabled }
    set { if _micBiasEnabled != newValue { _micBiasEnabled = newValue ; micCmd( "bias", newValue.asOnOff) }}}
  @objc dynamic public var micBoostEnabled: Bool {
    get { _micBoostEnabled }
    set { if _micBoostEnabled != newValue { _micBoostEnabled = newValue ; micCmd( "boost", newValue.asOnOff) }}}
  @objc dynamic public var micSelection: String {
    get { _micSelection }
    set { if _micSelection != newValue { _micSelection = newValue ; micCmd( "input", newValue) }}}
  // ***** TRANSMIT COMMANDS *****
  
  @objc dynamic public var carrierLevel: Int {
    get { _carrierLevel }
    set { if _carrierLevel != newValue { _carrierLevel = newValue ; transmitCmd( "am_carrier", newValue) }}}
  @objc dynamic public var companderEnabled: Bool {
    get { _companderEnabled }
    set { if _companderEnabled != newValue { _companderEnabled = newValue ; transmitCmd( .companderEnabled, newValue.as1or0) }}}
  @objc dynamic public var companderLevel: Int {
    get { _companderLevel }
    set { if _companderLevel != newValue { _companderLevel = newValue ; transmitCmd( .companderLevel, newValue) }}}
  @objc dynamic public var daxEnabled: Bool {
    get { _daxEnabled }
    set { if _daxEnabled != newValue { _daxEnabled = newValue ; transmitCmd( .daxEnabled, newValue.as1or0) }}}
  @objc dynamic public var hwAlcEnabled: Bool {
    get { _hwAlcEnabled }
    set { if _hwAlcEnabled != newValue { _hwAlcEnabled = newValue ; transmitCmd( .hwAlcEnabled, newValue.as1or0) }}}
  @objc dynamic public var inhibit: Bool {
    get { _inhibit }
    set { if _inhibit != newValue { _inhibit = newValue ; transmitCmd( .inhibit, newValue.as1or0) }}}
  @objc dynamic public var maxPowerLevel: Int {
    get { _maxPowerLevel }
    set { if _maxPowerLevel != newValue { _maxPowerLevel = newValue ; transmitCmd( .maxPowerLevel, newValue) }}}
  @objc dynamic public var metInRxEnabled: Bool {
    get { _metInRxEnabled }
    set { if _metInRxEnabled != newValue { _metInRxEnabled = newValue ; transmitCmd( .metInRxEnabled, newValue.as1or0) }}}
  @objc dynamic public var micLevel: Int {
    get { _micLevel }
    set { if _micLevel != newValue { _micLevel = newValue ; transmitCmd( "miclevel", newValue) }}}
  @objc dynamic public var rfPower: Int {
    get { _rfPower }
    set { if _rfPower != newValue { _rfPower = newValue ; transmitCmd( .rfPower, newValue) }}}
  @objc dynamic public var speechProcessorEnabled: Bool {
    get { _speechProcessorEnabled }
    set { if _speechProcessorEnabled != newValue { _speechProcessorEnabled = newValue ; transmitCmd( .speechProcessorEnabled, newValue.as1or0) }}}
  @objc dynamic public var speechProcessorLevel: Int {
    get { _speechProcessorLevel }
    set { if _speechProcessorLevel != newValue { _speechProcessorLevel = newValue ; transmitCmd( .speechProcessorLevel, newValue) }}}
  @objc dynamic public var tunePower: Int {
    get {  _tunePower }
    set { if _tunePower != newValue { _tunePower = newValue ; transmitCmd( .tunePower, newValue) }}}
  @objc dynamic public var txAntenna: String {
    get { _txAntenna }
    set { if _txAntenna != newValue { _txAntenna = newValue ; transmitCmd( .txAntenna, newValue) }}}
  @objc dynamic public var txFilterHigh: Int {
    get { _txFilterHigh }
    set { if _txFilterHigh != newValue { let value = txFilterHighLimits(txFilterLow, newValue) ; _txFilterHigh = value ; transmitCmd( "filter_high", value) }}}
  @objc dynamic public var txFilterLow: Int {
    get { _txFilterLow }
    set { if _txFilterLow != newValue { let value = txFilterLowLimits(newValue, txFilterHigh) ; _txFilterLow = value ; transmitCmd( "filter_low", value) }}}
  @objc dynamic public var txInWaterfallEnabled: Bool {
    get { _txInWaterfallEnabled }
    set { if _txInWaterfallEnabled != newValue { _txInWaterfallEnabled = newValue ; transmitCmd( .txInWaterfallEnabled, newValue.as1or0) }}}
  @objc dynamic public var txMonitorEnabled: Bool {
    get { _txMonitorEnabled }
    set { if _txMonitorEnabled != newValue { _txMonitorEnabled = newValue ; transmitCmd( "mon", newValue.as1or0) }}}
  @objc dynamic public var txMonitorGainCw: Int {
    get { _txMonitorGainCw }
    set { if _txMonitorGainCw != newValue { _txMonitorGainCw = newValue ; transmitCmd( .txMonitorGainCw, newValue) }}}
  @objc dynamic public var txMonitorGainSb: Int {
    get { _txMonitorGainSb }
    set { if _txMonitorGainSb != newValue { _txMonitorGainSb = newValue ; transmitCmd( .txMonitorGainSb, newValue) }}}
  @objc dynamic public var txMonitorPanCw: Int {
    get { _txMonitorPanCw }
    set { if _txMonitorPanCw != newValue { _txMonitorPanCw = newValue ; transmitCmd( .txMonitorPanCw, newValue) }}}
  @objc dynamic public var txMonitorPanSb: Int {
    get { _txMonitorPanSb }
    set { if _txMonitorPanSb != newValue { _txMonitorPanSb = newValue ; transmitCmd( .txMonitorPanSb, newValue) }}}
  @objc dynamic public var txSliceMode: String {
    get { _txSliceMode }
    set { if _txSliceMode != newValue { _txSliceMode = newValue ; transmitCmd( .txSliceMode, newValue) }}}
  @objc dynamic public var voxEnabled: Bool {
    get { _voxEnabled }
    set { if _voxEnabled != newValue { _voxEnabled = newValue ; transmitCmd( .voxEnabled, newValue.as1or0) }}}
  @objc dynamic public var voxDelay: Int {
    get { _voxDelay }
    set { if _voxDelay != newValue { _voxDelay = newValue ; transmitCmd( .voxDelay, newValue) }}}
  @objc dynamic public var voxLevel: Int {
    get { _voxLevel }
    set { if _voxLevel != newValue { _voxLevel = newValue ; transmitCmd( .voxLevel, newValue) }}}
  // ***** TUNE COMMANDS *****
  
  @objc dynamic public var tune: Bool {
    get {  return _tune }
    set { if _tune != newValue { _tune = newValue ; tuneCmd( .tune, newValue.as1or0) }}}
  @objc dynamic public var frequency: Hz {
    get {  return _frequency }
    set { if _frequency != newValue { _frequency = newValue }}}
  @objc dynamic public var rawIqEnabled: Bool       { _rawIqEnabled }
  @objc dynamic public var txFilterChanges: Bool    { _txFilterChanges }
  @objc dynamic public var txMonitorAvailable: Bool { _txMonitorAvailable }
  @objc dynamic public var txRfPowerChanges: Bool   { _txRfPowerChanges }
  
  // ----------------------------------------------------------------------------
  // MARK: - Internal properties

  var _carrierLevel: Int {
    get { Api.objectQ.sync { __carrierLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __carrierLevel = newValue.bound(kControlMin, kControlMax) }}}
  var _companderEnabled: Bool {
    get { Api.objectQ.sync { __companderEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __companderEnabled = newValue }}}
  var _companderLevel: Int {
    get { Api.objectQ.sync { __companderLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __companderLevel = newValue.bound(0, 100) }}}
  var _cwBreakInEnabled: Bool {
    get { Api.objectQ.sync { __cwBreakInEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __cwBreakInEnabled = newValue }}}
  var _cwBreakInDelay: Int {
    get { Api.objectQ.sync { __cwBreakInDelay } }
    set { Api.objectQ.sync(flags: .barrier) { __cwBreakInDelay = newValue.bound(kMinBreakInDelay, kMaxBreakInDelay) }}}
  var _cwIambicEnabled: Bool {
    get { Api.objectQ.sync { __cwIambicEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __cwIambicEnabled = newValue }}}
  var _cwIambicMode: Int {
    get { Api.objectQ.sync { __cwIambicMode } }
    set { Api.objectQ.sync(flags: .barrier) { __cwIambicMode = newValue }}}
  var _cwlEnabled: Bool {
    get { Api.objectQ.sync { __cwlEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __cwlEnabled = newValue }}}
  var _cwPitch: Int {
    get { Api.objectQ.sync { __cwPitch } }
    set { Api.objectQ.sync(flags: .barrier) { __cwPitch = newValue.bound(kMinPitch, kMaxPitch) }}}
  var _cwSidetoneEnabled: Bool {
    get { Api.objectQ.sync { __cwSidetoneEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __cwSidetoneEnabled = newValue }}}
  var _cwSwapPaddles: Bool {
    get { Api.objectQ.sync { __cwSwapPaddles } }
    set { Api.objectQ.sync(flags: .barrier) { __cwSwapPaddles = newValue }}}
  var _cwSyncCwxEnabled: Bool {
    get { Api.objectQ.sync { __cwSyncCwxEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __cwSyncCwxEnabled = newValue }}}
  var _cwSpeed: Int {
    get { Api.objectQ.sync { __cwSpeed } }
    set { Api.objectQ.sync(flags: .barrier) { __cwSpeed = newValue.bound(kMinWpm, kMaxWpm) }}}
  var _daxEnabled: Bool {
    get { Api.objectQ.sync { __daxEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __daxEnabled = newValue }}}
  var _frequency: Int {
    get { Api.objectQ.sync { __frequency } }
    set { Api.objectQ.sync(flags: .barrier) { __frequency = newValue }}}
  var _hwAlcEnabled: Bool {
    get { Api.objectQ.sync { __hwAlcEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __hwAlcEnabled = newValue }}}
  var _inhibit: Bool {
    get { Api.objectQ.sync { __inhibit } }
    set { Api.objectQ.sync(flags: .barrier) { __inhibit = newValue }}}
  var _maxPowerLevel: Int {
    get { Api.objectQ.sync { __maxPowerLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __maxPowerLevel = newValue.bound(kControlMin, kControlMax) }}}
  var _metInRxEnabled: Bool {
    get { Api.objectQ.sync { __metInRxEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __metInRxEnabled = newValue }}}
  var _micAccEnabled: Bool {
    get { Api.objectQ.sync { __micAccEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __micAccEnabled = newValue }}}
  var _micBoostEnabled: Bool {
    get { Api.objectQ.sync { __micBoostEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __micBoostEnabled = newValue }}}
  var _micBiasEnabled: Bool {
    get { Api.objectQ.sync { __micBiasEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __micBiasEnabled = newValue }}}
  var _micLevel: Int {
    get { Api.objectQ.sync { __micLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __micLevel = newValue.bound(kControlMin, kControlMax) }}}
  var _micSelection: String {
    get { Api.objectQ.sync { __micSelection } }
    set { Api.objectQ.sync(flags: .barrier) { __micSelection = newValue }}}
  var _rawIqEnabled: Bool {
    get { Api.objectQ.sync { __rawIqEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __rawIqEnabled = newValue }}}
  var _rfPower: Int {
    get { Api.objectQ.sync { __rfPower } }
    set { Api.objectQ.sync(flags: .barrier) { __rfPower = newValue.bound(kControlMin, kControlMax) }}}
  var _speechProcessorEnabled: Bool {
    get { Api.objectQ.sync { __speechProcessorEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __speechProcessorEnabled = newValue }}}
  var _speechProcessorLevel: Int {
    get { Api.objectQ.sync { __speechProcessorLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __speechProcessorLevel = newValue }}}
  var _txAntenna: String {
    get { Api.objectQ.sync { __txAntenna } }
    set { Api.objectQ.sync(flags: .barrier) { __txAntenna = newValue }}}
  var _txFilterChanges: Bool {
    get { Api.objectQ.sync { __txFilterChanges } }
    set { Api.objectQ.sync(flags: .barrier) { __txFilterChanges = newValue }}}
  var _txFilterHigh: Int {
    get { Api.objectQ.sync { __txFilterHigh } }
    set { Api.objectQ.sync(flags: .barrier) { __txFilterHigh = newValue }}}
  var _txFilterLow: Int {
    get { Api.objectQ.sync { __txFilterLow } }
    set { Api.objectQ.sync(flags: .barrier) { __txFilterLow = newValue }}}
  var _txInWaterfallEnabled: Bool {
    get { Api.objectQ.sync { __txInWaterfallEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __txInWaterfallEnabled = newValue }}}
  var _txMonitorAvailable: Bool {
    get { Api.objectQ.sync { __txMonitorAvailable } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorAvailable = newValue }}}
  var _txMonitorEnabled: Bool {
    get { Api.objectQ.sync { __txMonitorEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorEnabled = newValue }}}
  var _txMonitorGainCw: Int {
    get { Api.objectQ.sync { __txMonitorGainCw } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorGainCw = newValue.bound(kControlMin, kControlMax) }}}
  var _txMonitorGainSb: Int {
    get { Api.objectQ.sync { __txMonitorGainSb } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorGainSb = newValue.bound(kControlMin, kControlMax) }}}
  var _txMonitorPanCw: Int {
    get { Api.objectQ.sync { __txMonitorPanCw } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorPanCw = newValue.bound(0, 100) }}}
  var _txMonitorPanSb: Int {
    get { Api.objectQ.sync { __txMonitorPanSb } }
    set { Api.objectQ.sync(flags: .barrier) { __txMonitorPanSb = newValue.bound(0, 100) }}}
  var _txRfPowerChanges: Bool {
    get { Api.objectQ.sync { __txRfPowerChanges } }
    set { Api.objectQ.sync(flags: .barrier) { __txRfPowerChanges = newValue }}}
  var _txSliceMode: String {
    get { Api.objectQ.sync { __txSliceMode } }
    set { Api.objectQ.sync(flags: .barrier) { __txSliceMode = newValue }}}
  var _tune: Bool {
    get { Api.objectQ.sync { __tune } }
    set { Api.objectQ.sync(flags: .barrier) { __tune = newValue }}}
  var _tunePower: Int {
    get { Api.objectQ.sync { __tunePower } }
    set { Api.objectQ.sync(flags: .barrier) { __tunePower = newValue.bound(kControlMin, kControlMax) }}}
  var _voxEnabled: Bool {
    get { Api.objectQ.sync { __voxEnabled } }
    set { Api.objectQ.sync(flags: .barrier) { __voxEnabled = newValue }}}
  var _voxDelay: Int {
    get { Api.objectQ.sync { __voxDelay } }
    set { Api.objectQ.sync(flags: .barrier) { __voxDelay = newValue.bound(kControlMin, kControlMax) }}}
  var _voxLevel: Int {
    get { Api.objectQ.sync { __voxLevel } }
    set { Api.objectQ.sync(flags: .barrier) { __voxLevel = newValue.bound(kControlMin, kControlMax) }}}

  enum Token: String {
    case amCarrierLevel           = "am_carrier_level"              // "am_carrier"
    case companderEnabled         = "compander"
    case companderLevel           = "compander_level"
    case cwBreakInDelay           = "break_in_delay"
    case cwBreakInEnabled         = "break_in"
    case cwIambicEnabled          = "iambic"
    case cwIambicMode             = "iambic_mode"                   // "mode"
    case cwlEnabled               = "cwl_enabled"
    case cwPitch                  = "pitch"
    case cwSidetoneEnabled        = "sidetone"
    case cwSpeed                  = "speed"                         // "wpm"
    case cwSwapPaddles            = "swap_paddles"                  // "swap"
    case cwSyncCwxEnabled         = "synccwx"
    case daxEnabled               = "dax"
    case frequency                = "freq"
    case hwAlcEnabled             = "hwalc_enabled"
    case inhibit
    case maxPowerLevel            = "max_power_level"
    case metInRxEnabled           = "met_in_rx"
    case micAccEnabled            = "mic_acc"                       // "acc"
    case micBoostEnabled          = "mic_boost"                     // "boost"
    case micBiasEnabled           = "mic_bias"                      // "bias"
    case micLevel                 = "mic_level"                     // "miclevel"
    case micSelection             = "mic_selection"                 // "input"
    case rawIqEnabled             = "raw_iq_enable"
    case rfPower                  = "rfpower"
    case speechProcessorEnabled   = "speech_processor_enable"
    case speechProcessorLevel     = "speech_processor_level"
    case tune
    case tunePower                = "tunepower"
    case txAntenna                = "tx_antenna"
    case txFilterChanges          = "tx_filter_changes_allowed"
    case txFilterHigh             = "hi"                            // "filter_high"
    case txFilterLow              = "lo"                            // "filter_low"
    case txInWaterfallEnabled     = "show_tx_in_waterfall"
    case txMonitorAvailable       = "mon_available"
    case txMonitorEnabled         = "sb_monitor"                    // "mon"
    case txMonitorGainCw          = "mon_gain_cw"
    case txMonitorGainSb          = "mon_gain_sb"
    case txMonitorPanCw           = "mon_pan_cw"
    case txMonitorPanSb           = "mon_pan_sb"
    case txRfPowerChanges         = "tx_rf_power_changes_allowed"
    case txSliceMode              = "tx_slice_mode"
    case voxEnabled               = "vox_enable"
    case voxDelay                 = "vox_delay"
    case voxLevel                 = "vox_level"
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Private properties

  private var _initialized                  = false
  private let _log                          = Log.sharedInstance.logMessage
  private var _radio                        : Radio
  
  // ------------------------------------------------------------------------------
  // MARK: - Initialization
  
  /// Initialize Transmit
  ///
  /// - Parameters:
  ///   - radio:        the Radio instance
  ///
  public init(radio: Radio) {

    _radio = radio
    super.init()
  }
  
  // ------------------------------------------------------------------------------
  // MARK: - Class methods

  // format:
  // tx_rf_power_changes_allowed=1 tune=0 show_tx_in_waterfall=0 mon_available=1 max_power_level=100transmit tx_rf_power_changes_allowed=1 tune=0 show_tx_in_waterfall=0 mon_available=1 max_power_level=100
  //      OR
  // freq=14.100000 rfpower=100 tunepower=10 tx_slice_mode=USB hwalc_enabled=0 inhibit=0 dax=0 sb_monitor=0 mon_gain_sb=75 mon_pan_sb=50 met_in_rx=0 am_carrier_level=100 mic_selection=MIC mic_level=40 mic_boost=1 mic_bias=0 mic_acc=0 compander=1 compander_level=70 vox_enable=0 vox_level=50 vox_delay=2075607040 speech_processor_enable=1 speech_processor_level=0 lo=100 hi=2900 tx_filter_changes_allowed=1 tx_antenna=ANT1 pitch=600 speed=30 iambic=1 iambic_mode=1 swap_paddles=0 break_in=1 break_in_delay=41 cwl_enabled=0 sidetone=1 mon_gain_cw=80 mon_pan_cw=50 synccwx=1transmit freq=14.100000 rfpower=100 tunepower=10 tx_slice_mode=USB hwalc_enabled=0 inhibit=0 dax=0 sb_monitor=0 mon_gain_sb=75 mon_pan_sb=50 met_in_rx=0 am_carrier_level=100 mic_selection=MIC mic_level=40 mic_boost=1 mic_bias=0 mic_acc=0 compander=1 compander_level=70 vox_enable=0 vox_level=50 vox_delay=2075607040 speech_processor_enable=1 speech_processor_level=0 lo=100 hi=2900 tx_filter_changes_allowed=1 tx_antenna=ANT1 pitch=600 speed=30 iambic=1 iambic_mode=1 swap_paddles=0 break_in=1 break_in_delay=41 cwl_enabled=0 sidetone=1 mon_gain_cw=80 mon_pan_cw=50 synccwx=1

  
  /// Parse a Transmit status message
  ///   format: <key=value> <key=value> ...<key=value>
  ///
  ///   PropertiesParser protocol method, executes on the parseQ
  ///
  /// - Parameter properties:       a KeyValuesArray
  ///
  func parseProperties(_ radio: Radio, _ properties: KeyValuesArray) {
    
    
    // NO, process each key/value pair, <key=value>
    for property in properties {
      
      // Check for Unknown Keys
      guard let token = Token(rawValue: property.key)  else {
        // log it and ignore the Key
        _log(Self.className() + " unknown token: \(property.key) = \(property.value)", .warning, #function, #file, #line)
        continue
      }
      // Known tokens, in alphabetical order
      switch token {
        
      case .amCarrierLevel:         willChangeValue(for: \.carrierLevel)            ; _carrierLevel = property.value.iValue           ; didChangeValue(for: \.carrierLevel)
      case .companderEnabled:       willChangeValue(for: \.companderEnabled)        ; _companderEnabled = property.value.bValue       ; didChangeValue(for: \.companderEnabled)
      case .companderLevel:         willChangeValue(for: \.companderLevel)          ; _companderLevel = property.value.iValue         ; didChangeValue(for: \.companderLevel)
      case .cwBreakInEnabled:       willChangeValue(for: \.cwBreakInEnabled)        ; _cwBreakInEnabled = property.value.bValue       ; didChangeValue(for: \.cwBreakInEnabled)
      case .cwBreakInDelay:         willChangeValue(for: \.cwBreakInDelay)          ; _cwBreakInDelay = property.value.iValue         ; didChangeValue(for: \.cwBreakInDelay)
      case .cwIambicEnabled:        willChangeValue(for: \.cwIambicEnabled)         ; _cwIambicEnabled = property.value.bValue        ; didChangeValue(for: \.cwIambicEnabled)
      case .cwIambicMode:           willChangeValue(for: \.cwIambicMode)            ; _cwIambicMode = property.value.iValue           ; didChangeValue(for: \.cwIambicMode)
      case .cwlEnabled:             willChangeValue(for: \.cwlEnabled)              ; _cwlEnabled = property.value.bValue             ; didChangeValue(for: \.cwlEnabled)
      case .cwPitch:                willChangeValue(for: \.cwPitch)                 ; _cwPitch = property.value.iValue                ; didChangeValue(for: \.cwPitch)
      case .cwSidetoneEnabled:      willChangeValue(for: \.cwSidetoneEnabled)       ; _cwSidetoneEnabled = property.value.bValue      ; didChangeValue(for: \.cwSidetoneEnabled)
      case .cwSpeed:                willChangeValue(for: \.cwSpeed)                 ; _cwSpeed = property.value.iValue                ; didChangeValue(for: \.cwSpeed)
      case .cwSwapPaddles:          willChangeValue(for: \.cwSwapPaddles)           ; _cwSwapPaddles = property.value.bValue          ; didChangeValue(for: \.cwSwapPaddles)
      case .cwSyncCwxEnabled:       willChangeValue(for: \.cwSyncCwxEnabled)        ; _cwSyncCwxEnabled = property.value.bValue       ; didChangeValue(for: \.cwSyncCwxEnabled)
      case .daxEnabled:             willChangeValue(for: \.daxEnabled)              ; _daxEnabled = property.value.bValue             ; didChangeValue(for: \.daxEnabled)
      case .frequency:              willChangeValue(for: \.frequency)               ; _frequency = property.value.mhzToHz             ; didChangeValue(for: \.frequency)
      case .hwAlcEnabled:           willChangeValue(for: \.hwAlcEnabled)            ; _hwAlcEnabled = property.value.bValue           ; didChangeValue(for: \.hwAlcEnabled)
      case .inhibit:                willChangeValue(for: \.inhibit)                 ; _inhibit = property.value.bValue                ; didChangeValue(for: \.inhibit)
      case .maxPowerLevel:          willChangeValue(for: \.maxPowerLevel)           ; _maxPowerLevel = property.value.iValue          ; didChangeValue(for: \.maxPowerLevel)
      case .metInRxEnabled:         willChangeValue(for: \.metInRxEnabled)          ; _metInRxEnabled = property.value.bValue         ; didChangeValue(for: \.metInRxEnabled)
      case .micAccEnabled:          willChangeValue(for: \.micAccEnabled)           ; _micAccEnabled = property.value.bValue          ; didChangeValue(for: \.micAccEnabled)
      case .micBoostEnabled:        willChangeValue(for: \.micBoostEnabled)         ; _micBoostEnabled = property.value.bValue        ; didChangeValue(for: \.micBoostEnabled)
      case .micBiasEnabled:         willChangeValue(for: \.micBiasEnabled)          ; _micBiasEnabled = property.value.bValue         ; didChangeValue(for: \.micBiasEnabled)
      case .micLevel:               willChangeValue(for: \.micLevel)                ; _micLevel = property.value.iValue               ; didChangeValue(for: \.micLevel)
      case .micSelection:           willChangeValue(for: \.micSelection)            ; _micSelection = property.value                  ; didChangeValue(for: \.micSelection)
      case .rawIqEnabled:           willChangeValue(for: \.rawIqEnabled)            ; _rawIqEnabled = property.value.bValue           ; didChangeValue(for: \.rawIqEnabled)
      case .rfPower:                willChangeValue(for: \.rfPower)                 ; _rfPower = property.value.iValue                ; didChangeValue(for: \.rfPower)
      case .speechProcessorEnabled: willChangeValue(for: \.speechProcessorEnabled)  ; _speechProcessorEnabled = property.value.bValue ; didChangeValue(for: \.speechProcessorEnabled)
      case .speechProcessorLevel:   willChangeValue(for: \.speechProcessorLevel)    ; _speechProcessorLevel = property.value.iValue   ; didChangeValue(for: \.speechProcessorLevel)
      case .txAntenna:              willChangeValue(for: \.txAntenna)               ; _txAntenna = property.value                     ; didChangeValue(for: \.txAntenna)
      case .txFilterChanges:        willChangeValue(for: \.txFilterChanges)         ; _txFilterChanges = property.value.bValue        ; didChangeValue(for: \.txFilterChanges)
      case .txFilterHigh:           willChangeValue(for: \.txFilterHigh)            ; _txFilterHigh = property.value.iValue           ; didChangeValue(for: \.txFilterHigh)
      case .txFilterLow:            willChangeValue(for: \.txFilterLow)             ; _txFilterLow = property.value.iValue            ; didChangeValue(for: \.txFilterLow)
      case .txInWaterfallEnabled:   willChangeValue(for: \.txInWaterfallEnabled)    ; _txInWaterfallEnabled = property.value.bValue   ; didChangeValue(for: \.txInWaterfallEnabled)
      case .txMonitorAvailable:     willChangeValue(for: \.txMonitorAvailable)      ; _txMonitorAvailable = property.value.bValue     ; didChangeValue(for: \.txMonitorAvailable)
      case .txMonitorEnabled:       willChangeValue(for: \.txMonitorEnabled)        ; _txMonitorEnabled = property.value.bValue       ; didChangeValue(for: \.txMonitorEnabled)
      case .txMonitorGainCw:        willChangeValue(for: \.txMonitorGainCw)         ; _txMonitorGainCw = property.value.iValue        ; didChangeValue(for: \.txMonitorGainCw)
      case .txMonitorGainSb:        willChangeValue(for: \.txMonitorGainSb)         ; _txMonitorGainSb = property.value.iValue        ; didChangeValue(for: \.txMonitorGainSb)
      case .txMonitorPanCw:         willChangeValue(for: \.txMonitorPanCw)          ; _txMonitorPanCw = property.value.iValue         ; didChangeValue(for: \.txMonitorPanCw)
      case .txMonitorPanSb:         willChangeValue(for: \.txMonitorPanSb)          ; _txMonitorPanSb = property.value.iValue         ; didChangeValue(for: \.txMonitorPanSb)
      case .txRfPowerChanges:       willChangeValue(for: \.txRfPowerChanges)        ; _txRfPowerChanges = property.value.bValue       ; didChangeValue(for: \.txRfPowerChanges)
      case .txSliceMode:            willChangeValue(for: \.txSliceMode)             ; _txSliceMode = property.value                   ; didChangeValue(for: \.txSliceMode)
      case .tune:                   willChangeValue(for: \.tune)                    ; _tune = property.value.bValue                   ; didChangeValue(for: \.tune)
      case .tunePower:              willChangeValue(for: \.tunePower)               ; _tunePower = property.value.iValue              ; didChangeValue(for: \.tunePower)
      case .voxEnabled:             willChangeValue(for: \.voxEnabled)              ; _voxEnabled = property.value.bValue             ; didChangeValue(for: \.voxEnabled)
      case .voxDelay:               willChangeValue(for: \.voxDelay)                ; _voxDelay = property.value.iValue               ; didChangeValue(for: \.voxDelay)
      case .voxLevel:               willChangeValue(for: \.voxLevel)                ; _voxLevel = property.value.iValue               ; didChangeValue(for: \.voxLevel)
      }
    }
    // is Transmit initialized?
    if !_initialized {
      // NO, the Radio (hardware) has acknowledged this Transmit
      _initialized = true
      
      // notify all observers
      NC.post(.transmitHasBeenAdded, object: self as Any?)
    }
  }
  
  func txFilterHighLimits(_ low: Int, _ high: Int) -> Int {
    
    let newValue = ( high < low + 50 ? low + 50 : high )
    return newValue > 10_000 ? 10_000 : newValue
  }
  func txFilterLowLimits(_ low: Int, _ high: Int) -> Int {
    
    let newValue = ( low > high - 50 ? high - 50 : low )
    return newValue < 0 ? 0 : newValue
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  /// Set the Tune property on the Radio
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func tuneCmd(_ token: Token, _ value: Any) {
    
    Api.sharedInstance.send("transmit " + token.rawValue + " \(value)")
  }
  /// Set a Transmit property on the Radio
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func transmitCmd(_ token: Token, _ value: Any) {
    
    Api.sharedInstance.send("transmit set " + token.rawValue + "=\(value)")
  }
  /// Set a Transmit property on the Radio
  ///
  /// - Parameters:
  ///   - token:      a String
  ///   - value:      the new value
  ///
  private func transmitCmd(_ token: String, _ value: Any) {
    // NOTE: commands use this format when the Token received does not match the Token sent
    //      e.g. see EqualizerCommands.swift where "63hz" is received vs "63Hz" must be sent
    Api.sharedInstance.send("transmit set " + token + "=\(value)")
  }
  /// Set a CW property on the Radio
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func cwCmd(_ token: Token, _ value: Any) {
    
    Api.sharedInstance.send("cw " + token.rawValue + " \(value)")
  }
  // alternate form for commands that do not use the Token raw value in outgoing messages
  private func cwCmd(_ token: String, _ value: Any) {
    
    Api.sharedInstance.send("cw " + token + " \(value)")
  }
  /// Set a MIC property on the Radio
  ///
  /// - Parameters:
  ///   - token:      the parse token
  ///   - value:      the new value
  ///
  private func micCmd(_ token: Token, _ value: Any) {
    
    Api.sharedInstance.send("mic " + token.rawValue + " \(value)")
  }
  // alternate form for commands that do not use the Token raw value in outgoing messages
  private func micCmd(_ token: String, _ value: Any) {
    
    Api.sharedInstance.send("mic " + token + " \(value)")
  }
  
  // ----------------------------------------------------------------------------
  // *** Hidden properties (Do NOT use) ***
  
  private var __carrierLevel                = 0
  private var __companderEnabled            = false
  private var __companderLevel              = 0
  private var __cwBreakInDelay              = 0
  private var __cwBreakInEnabled            = false
  private var __cwIambicEnabled             = false
  private var __cwIambicMode                = 0
  private var __cwlEnabled                  = false
  private var __cwPitch                     = 0
  private var __cwSidetoneEnabled           = false
  private var __cwSwapPaddles               = false
  private var __cwSyncCwxEnabled            = false
  private var __cwSpeed                     = 5
  private var __daxEnabled                  = false
  private var __frequency                   = 0
  private var __hwAlcEnabled                = false
  private var __inhibit                     = false
  private var __maxPowerLevel               = 0
  private var __metInRxEnabled              = false
  private var __micAccEnabled               = false
  private var __micBiasEnabled              = false
  private var __micBoostEnabled             = false
  private var __micLevel                    = 0
  private var __micSelection                = ""
  private var __rawIqEnabled                = false
  private var __rfPower                     = 0
  private var __speechProcessorEnabled      = false
  private var __speechProcessorLevel        = 0
  private var __txAntenna                   = ""
  private var __txFilterChanges             = false
  private var __txFilterHigh                = 0
  private var __txFilterLow                 = 0
  private var __txInWaterfallEnabled        = false
  private var __txMonitorAvailable          = false
  private var __txMonitorEnabled            = false
  private var __txMonitorGainCw             = 0
  private var __txMonitorGainSb             = 0
  private var __txMonitorPanCw              = 0
  private var __txMonitorPanSb              = 0
  private var __txRfPowerChanges            = false
  private var __txSliceMode                 = ""
  private var __tune                        = false
  private var __tunePower                   = 0
  private var __voxDelay                    = 0
  private var __voxEnabled                  = false
  private var __voxLevel                    = 0                            
}
