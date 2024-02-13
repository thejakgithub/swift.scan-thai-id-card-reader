//
//  EventObj.swift
//  Swift.NiOSDemo
//
//  Created by Apirak on 9/4/2565 BE.
//  Copyright © 2565 BE mac. All rights reserved.
//

//  Converted to Swift 5.6 by Swiftify v5.6.25394 - https://swiftify.com/
//import Foundation

class EventObj: NSObject {
    public var nEventMsg = 0

    public var idMsg: Any?
}

protocol senderDelegate: AnyObject {
    func doMessageEvent(_ evtObj: EventObj)
}

