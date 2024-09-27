//
//  AnalyticsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/17/24.
//

import Foundation
import TelemetryDeck

final class AnalyticsManager {
    
    enum Event {
        
        case `init`
        case purchase(productId: String)
        
        var value: String {
            switch self {
            case .`init`: 
                return "init"
            case .purchase(let productId):
                return "purchase-\(productId)"
            }
        }
    }
    
    var userId: String?
    
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func start() {
        TelemetryDeck.initialize(config: .init(appID: EnvVars.telemetryDeck))
    }
    
    func signIn(id: String?) {
        userId = id
        TelemetryDeck.updateDefaultUserID(to: id)
    }
    
    func signOut() {
        userId = nil
        TelemetryDeck.updateDefaultUserID(to: nil)
    }
    
    func send(event: Event) {
        TelemetryDeck.signal(
            event.value,
            parameters: [
                "region": Locale.current.region?.identifier.countryName ?? "",
                "regionCode": Locale.current.region?.identifier ?? "",
                "languageCode": Locale.current.language.languageCode?.identifier ?? "",
                "timeZone": TimeZone.current.identifier
            ],
            customUserID: userId
        )
    }
}
