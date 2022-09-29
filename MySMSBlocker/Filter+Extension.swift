//
//  Filter+Extension.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 9/30/22.
//

import Foundation

extension Filter {
    public var wrappedMatch: String {
        get{match ?? ""}
        set{match = newValue}
    }
}
