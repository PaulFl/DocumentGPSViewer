//
//  SBPProcessing.swift
//  GPSViewer
//
//  Created by Paul Fleury on 25/07/2020.
//

import Foundation
import MapKit

public func decodeSBPDateTime(UTCDateTimeData: Data, UTCNanoSecData: Data) -> Date? {
    var bytesArray = [Int]()
    for i in 0..<4 {
        let byte = Int(Int8(littleEndian: UTCDateTimeData.subdata(in: UTCDateTimeData.index(UTCDateTimeData.startIndex, offsetBy: i)..<UTCDateTimeData.index(UTCDateTimeData.startIndex, offsetBy: i+1)).withUnsafeBytes { $0.load(as: Int8.self) }))
        bytesArray.append(byte)
    }
    
    var decodedDate = DateComponents()
    decodedDate.timeZone = TimeZone(abbreviation: "UTC")
    
    let decodedNanoSec = Int16(littleEndian: UTCNanoSecData.withUnsafeBytes { $0.load(as: Int16.self) })
    decodedDate.nanosecond = Int(decodedNanoSec)

    let decodedSec = bytesArray[0] & 0x3F
    decodedDate.second = decodedSec
    
    let decodedMin = ((bytesArray[0] & 0xC0) >> 6) | ((bytesArray[1] & 0x0F) << 2)
    decodedDate.minute = decodedMin
    
    let decodedHour = ((bytesArray[1] & 0xF0) >> 4) | ((bytesArray[2] & 0x01) << 4)
    decodedDate.hour = decodedHour
    
    let decodedDay = (bytesArray[2] & 0x3E) >> 1
    decodedDate.day = decodedDay
    
    let decodedMonthYear = ((bytesArray[2] & 0xC0) >> 6) | bytesArray[3] << 2
    decodedDate.month = decodedMonthYear % 12
    
    decodedDate.year = 2000 + decodedMonthYear / 12
    
    let calendar = Calendar.current
    return calendar.date(from: decodedDate)
}

public func openFile(fileName: String, fileExtension: String) -> Data? {
    let filePath = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    var fileData: Data? = nil

    if filePath != nil {
        do {
            fileData = try Data(contentsOf: filePath!)
        } catch {
            
        }
    }
    return fileData
}

public func SBPDataToWaypoints(fileData: Data?) -> [Data] {
    var waypoints = [Data]()
    
    if fileData != nil {
//        let headerRange = fileData!.startIndex..<(fileData?.index(fileData!.startIndex, offsetBy: 64))!
//        let header = fileData!.subdata(in: headerRange)
        
        var index = fileData!.index(fileData!.startIndex, offsetBy: 64)
        var endIndex = fileData!.index(index, offsetBy: 32)
        
        while fileData!.index(index, offsetBy: 32) < fileData!.endIndex {
            endIndex = fileData!.index(index, offsetBy: 32)
            waypoints.append((fileData?.subdata(in: index..<endIndex))!)
            index = endIndex
        }
    }
    
    return waypoints
}

public func decodeWaypoints(waypoints: [Data]) -> [CLLocation] {
    var decodedWaypoints = [CLLocation]()
    for wp in waypoints {
//        let HDOPBytes = wp.subdata(in: wp.startIndex..<wp.index(wp.startIndex, offsetBy: 1))
//        let SVsBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 1)..<wp.index(wp.startIndex, offsetBy: 2))
        let UTCSecBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 2)..<wp.index(wp.startIndex, offsetBy: 4))
        let dateTimeUTCBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 4)..<wp.index(wp.startIndex, offsetBy: 8))
//        let SVIDListBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 8)..<wp.index(wp.startIndex, offsetBy: 12))
        let latBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 12)..<wp.index(wp.startIndex, offsetBy: 16))
        let lonBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 16)..<wp.index(wp.startIndex, offsetBy: 20))
        let altBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 20)..<wp.index(wp.startIndex, offsetBy: 24))
        let speedBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 24)..<wp.index(wp.startIndex, offsetBy: 26))
        let headingBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 26)..<wp.index(wp.startIndex, offsetBy: 28))
 //       let varioBytes = wp.subdata(in: wp.index(wp.startIndex, offsetBy: 28)..<wp.index(wp.startIndex, offsetBy: 30))
        
        let latitude = Double(Int32(littleEndian: latBytes.withUnsafeBytes { $0.load(as: Int32.self) })) / 1e7
        let longitude = Double(Int32(littleEndian: lonBytes.withUnsafeBytes { $0.load(as: Int32.self) })) / 1e7
        
        let altitude = CLLocationDistance((Int32(littleEndian: altBytes.withUnsafeBytes { $0.load(as: Int32.self) })) / 100)
        let speed = CLLocationSpeed((Int16(littleEndian: speedBytes.withUnsafeBytes { $0.load(as: Int16.self) })) / 100)
        let heading = CLLocationDirection(Int16(littleEndian: headingBytes.withUnsafeBytes { $0.load(as: Int16.self) }))
 //       let vario = CLLocationSpeed((Int16(littleEndian: varioBytes.withUnsafeBytes { $0.load(as: Int16.self) })) / 100)
        
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let dateTime = decodeSBPDateTime(UTCDateTimeData: dateTimeUTCBytes, UTCNanoSecData: UTCSecBytes)
        
        let location = CLLocation(coordinate: coordinates, altitude: altitude, horizontalAccuracy: CLLocationAccuracy(), verticalAccuracy: CLLocationAccuracy(), course: heading, courseAccuracy: CLLocationDirectionAccuracy(), speed: speed, speedAccuracy: CLLocationSpeedAccuracy(), timestamp: dateTime!)
        
        
        
        decodedWaypoints.append(location)
    }
    
    return decodedWaypoints
}
