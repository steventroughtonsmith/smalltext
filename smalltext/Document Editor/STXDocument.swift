//
//  Document.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 28/01/2021.
//

import UIKit

class STXDocument: UIDocument {
    
    var body = ""
    
    override func contents(forType typeName: String) throws -> Any {
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            body = String(data: data, encoding: .utf8) ?? ""
        } else if let wrapper = contents as? FileWrapper {
            body = String(data: wrapper.regularFileContents!, encoding: .utf8) ?? ""
        }
    }
    
    func text() -> String {
        return body
    }
}

