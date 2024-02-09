//
//  Encodable+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation

extension Encodable {

    var dict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return dict
    }
}
