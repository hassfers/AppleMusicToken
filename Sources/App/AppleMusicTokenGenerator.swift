//
//  AppleMusicTokenGenerator.swift
//  App
//
//  Created by Stefan Haßferter on 05.06.20.
//

//import JWTKit
import Vapor
//import JWT
import JWTKit

class AppleMusicTokenGenerator {
    let keyId: String
    let teamId: String
    let privatKeyPath: String

    internal init(keyId: String, teamId: String, privatKeyPath: String) {
        self.keyId = keyId
        self.teamId = teamId
        self.privatKeyPath = privatKeyPath
    }

    func generateToken() {

        let header = JWTHeader(kid:keyId)

        let payload = AppleMusicTokenPayload(issuer: teamId,
                                             issuedAt: Date(),
                                             expirationAt: Date().add(hours: 24 * 7))

        let token = JWT(header: header, payload: payload)

        guard let key = loadPrivateKey() else { return }

        let signer = try JWTSigner.

    }

    func loadPrivateKey() -> Data? {
        guard let url = URL(string: privatKeyPath) else { return nil }
        return try? Data(contentsOf: url)
    }

}

struct AppleMusicTokenPayload: JWTPayload {

    var issuer: IssuerClaim
    var issuedAt: IssuedAtClaim
    var expirationAt: ExpirationClaim

    init(issuer: String ,
         issuedAt: Date = Date(),
         expirationAt: Date) {
        self.issuer = IssuerClaim(value: issuer)
        self.issuedAt = IssuedAtClaim(value: issuedAt)
        self.expirationAt = ExpirationClaim(value: expirationAt)
    }

    func verify(using signer: JWTSigner) throws {
        try self.expirationAt.verifyNotExpired()
    }
}



extension Date {
    func add(hours:Int) -> Date {
        return self + TimeInterval((60 * hours))
    }
}
