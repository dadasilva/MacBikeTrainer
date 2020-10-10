//
//  BluetoothHandler.swift
//  unbearable
//
//  Created by David Da Silva on 9/30/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import Foundation
import Cocoa
import CoreBluetooth

let wahooTrainerFitnessMachineUUID          = CBUUID(string: "0x1826")
let wahooTrainerSensorLocation              = CBUUID(string: "0x2A5D")
let cyclingPowerMeasurement                 = CBUUID(string: "0x2A63")
let cyclingPowerFeature                     = CBUUID(string: "0x2A65")
let cyclingPowerControlPoint                = CBUUID(string: "0x2A66")
let cyclingSpeedandCadence                  = CBUUID(string: "0x1816")
let serialNumberString                      = CBUUID(string: "0x2A25")
let manufactureNameString                   = CBUUID(string: "0x2A29")
let batteryLevel                            = CBUUID(string: "0x2A19")
let equipmentCharacteristic                 = CBUUID(string:"A026E037-0A7D-4AB3-97FA-F1500F9FEB8B")
let heartRateUUID                           = CBUUID(string: "0x2A37")

let deviceArray: [String] = [
                             "KICKR",
                             "WAHOO",
                             "HRM"
                            ]

struct MachineData {
    var pedal_Power_Balance: Int
    var pedal_Power_Balance_References: Int
    var accumulated_Torque_Present: Int
    var accumulated_Torque_Source: Int
    var wheel_Revolution_Data_Present: Int
    var crank_Revolution_Data_Present: Int
    var extreme_Force_Magnitudes_Present: Int
    var extreme_Torque_Magnitudes_Present: Int
    var extreme_Angles_Present: Int
    var top_Dead_Spot_Angle_Present: Int
    var bottom_Dead_Spot_Angle_Present: Int
    var accumulated_Energy_Present: Int
    var offset_Compensation_Indicator: Int
//    func messWithAboveData() {}
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
          print("central state is .unknown")
        case .resetting:
          print("central state is .resetting")
        case .unsupported:
          print("central state is .unsupported")
        case .unauthorized:
          print("central state is .unauthorized")
        case .poweredOff:
          print("central state is .poweredOff")
        case .poweredOn:
          print("central state is .poweredOn")
          centralManager.scanForPeripherals(withServices: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        for machineAdvert in deviceArray {
            if peripheral.name?.contains(machineAdvert) == true {
                bikeTrainerPeripheral = peripheral
                bikeTrainerPeripheral.delegate = self
                centralManager.stopScan()
                centralManager.connect(bikeTrainerPeripheral)
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect: CBPeripheral){
        print("Connected MuthaFucka")
        bikeTrainerPeripheral.discoverServices(nil)
    }
    func onPowerMeasurementReceived(_ power: Int) {
        dataLabel.stringValue = String(power)
    }
}



extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
//            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
              print("\(characteristic.uuid): properties contains .read")
              peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
              print("\(characteristic.uuid): properties contains .notify")
              peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case batteryLevel:
            let battery = getBatteryLevel(from: characteristic)
            print("Battery Level: \(battery)")
        case cyclingPowerMeasurement:
//            print("cyclingPowerMeasurement")
            //GET SPEED FROM POWER MEASUREMENT
            let speed = speedMeasurement(from: characteristic)
            onPowerMeasurementReceived(speed)
            print(characteristic.value ?? "no value")
            
        case cyclingPowerFeature:
            print("cyclingPowerFeature")
            print(characteristic.value ?? "no value")

        case cyclingPowerControlPoint:
            print("cyclingPowerControlPoint")
            print(characteristic.value ?? "no value")
            
        case cyclingSpeedandCadence:
            print("wahooTrainerCyclingCadence_SpeedUUID")
            print(characteristic.value ?? "no value")
            
        case serialNumberString:
            let serial = serialNumber(from: characteristic)
            print("Serial Number: \(serial)")
            
        case manufactureNameString:
            let name = hardwareName(from: characteristic)
            powerLabel.stringValue = name
            powerLabel.drawsBackground = true
            powerLabel.backgroundColor = NSColor.green
            print("Hardware Name: \(name)")
        case equipmentCharacteristic:
            print("Testing Machine Characteristic")
            let temp = machineMeasurement(from: characteristic)
        case heartRateUUID:
            let bpm = getHeartRate(from: characteristic)
            heartRateLabel.stringValue = String(bpm)
            print("HeartRate \(bpm) bpm")
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    private func powerReader(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value, let byte = characteristicData.first else { return "Error" }
        
        switch byte {
            case 0: return "Other"
            case 1: return "First"
            case 2: return "Second"
            default:
                return "reserved for future use"
        }
    }
    private func machineMeasurement(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        let u16 = UnsafePointer(byteArray).withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
        print("machineMeasurement: \(u16)")
        return 0
    }
    
    private func speedMeasurement(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        print(byteArray)
        //GET ACCUMULATED REVOLUTIONS
        var firstRevRead: Int = -1
        var secondRevRead: Int = -1
        let timeDelta = 1
        for _ in 0...1 {
            firstRevRead = Int(byteArray[4]) //Accumulated Revolution @ n seconds
            print("speed(1): \(firstRevRead)")
            sleep(UInt32(timeDelta))
            secondRevRead = Int(byteArray[4])//Accumulated Revolution @ n + 1 seconds
            print("speed(2): \(secondRevRead)")
        }
        return firstRevRead
//            Int((secondRevRead - firstRevRead)/timeDelta)
    }
    
    private func serialNumber(from characteristic: CBCharacteristic) -> String {
        guard let serialNum = characteristic.value else { return "No Serial" }
        let serial = String(decoding: serialNum, as: UTF8.self)
        return serial
    }
    private func hardwareName(from characteristic: CBCharacteristic) -> String {
        guard let serialNum = characteristic.value else { return "Hardware Name Not Found" }
        let serial = String(decoding: serialNum, as: UTF8.self)
        return serial
    }
    private func getBatteryLevel(from characteristic: CBCharacteristic) -> Int {
        guard let batteryData = characteristic.value else { return -1 }
        let byteArray = [UInt8](batteryData)
        return Int(byteArray[0])
    }
    private func getHeartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        print(byteArray)
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            return Int(byteArray[1])
        } else {
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
}
