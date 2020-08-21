//
//  AppleMusicTokenGenerator.swift
//  App
//
//  Created by Stefan Haßferter on 05.06.20.
//

import Vapor
import SwiftJWT

class AppleMusicTokenGenerator {
    let keyId: String
    let teamId: String
    let privatKeyPath: String

    internal init(keyId: String, teamId: String, privatKeyPath: String) {
        self.keyId = keyId
        self.teamId = teamId
        self.privatKeyPath = privatKeyPath
    }

    func generateToken(expirationDate: Date = Date.validFor24Hours ) -> String? {
        let header = Header(kid: keyId)
        let claims = ClaimsStandardJWT(iss: teamId,
                                       sub: nil,
                                       aud: nil,
                                       exp: expirationDate,
                                       nbf: nil,
                                       iat: Date(),
                                       jti: nil)

        var token = SwiftJWT.JWT(header: header, claims: claims)

        guard let key = loadPrivateKey() else { return nil }

        return try? token.sign(using: .es256(privateKey:key))
    }

    func loadPrivateKey() -> Data? {
        
        let url = URL(fileURLWithPath: privatKeyPath)
        return try? Data(contentsOf: url)
    }

}

extension Date {
    func add(hours: Int) -> Date {
        return self + TimeInterval.hour * Double(hours)
    }


    func add(seconds: Int) -> Date {
        return self + TimeInterval(seconds)
    }

    static var validFor24Hours: Date {
        return Date().add(hours: 24)
    }
}

extension TimeInterval {
    static var hour: TimeInterval {
        return 3600
    }
}
