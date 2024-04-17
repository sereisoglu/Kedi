//
//  AnalyticsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/17/24.
//

import Foundation
import TelemetryClient

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
    
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func start() {
        let configuration = TelemetryManagerConfiguration(appID: EnvVars.telemetryDeck)
        TelemetryManager.initialize(with: configuration)
    }
    
    func signIn(id: String?) {
        TelemetryManager.updateDefaultUser(to: id)
    }
    
    func signOut() {
        TelemetryManager.updateDefaultUser(to: nil)
    }
    
    func send(event: Event) {
        let additionalPayload = [
            "region": Locale.current.region?.identifier.countryName ?? "",
            "regionCode": Locale.current.region?.identifier ?? "",
            "languageCode": Locale.current.language.languageCode?.identifier ?? "",
            "timeZone": TimeZone.current.identifier
        ]
        TelemetryManager.send(event.value, with: additionalPayload)
    }
}
