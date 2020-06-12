//
//  AppleMusicTokenGenerator.swift
//  App
//
//  Created by Stefan Haßferter on 05.06.20.
//

import Vapor
//import JWT
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

    func generateToken() -> String? {

        let payload = AppleMusicTokenPayload(issuer: teamId,
                                             issuedAt: Date(),
                                             expirationAt: Date().add(hours: 24 * 7))

        let header = Header(kid: keyId)
        let claims = AppleMusicTokenPayload(issuer: teamId, issuedAt: Date(), expirationAt: Date() +  24 * 3600 )

        var token = SwiftJWT.JWT(header: header, claims: claims)

        guard let key = loadPrivateKey() else { return nil }

        return try? token.sign(using: .es256(privateKey:key))

    }

    func loadPrivateKey() -> Data? {
        
        let url = URL(fileURLWithPath: privatKeyPath)
        return try? Data(contentsOf: url)
    }

}

struct AppleMusicTokenPayload: Claims {

    var issuer: String
    var issuedAt: Date
    var expirationAt: Date

    init(issuer: String ,
         issuedAt: Date = Date(),
         expirationAt: Date) {
        self.issuer = issuer
        self.issuedAt = issuedAt
        self.expirationAt = expirationAt
    }

//    func verify(using signer: JWTSigner) throws {
//        try self.expirationAt.verifyNotExpired()
//    }
}



extension Date {
    func add(hours:Int) -> Date {
        return self + TimeInterval((60 * hours))
    }
}
