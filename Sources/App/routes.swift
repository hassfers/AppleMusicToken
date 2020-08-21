//
//  AppleMusicTokenGenerator.swift
//  App
//
//  Created by Stefan Haßferter on 05.06.20.
//
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "AppleMusicTokenGenerator by sth"
    }
    
    app.get("token") { req -> String in
        let keyPath = Environment.process.KEY_PATH ?? ""
        let keyId = Environment.process.KEY_ID ?? ""
        let teamId = Environment.process.TEAM_ID ?? ""
        let seconds = Int(Environment.process.VALID_FOR_SECONDS ?? "")


        guard !keyPath.isEmpty,
            !keyId.isEmpty,
            !teamId.isEmpty
            else { return
                """
                some variable aren't set properly
                keyPath: \(keyPath)
                keyId: \(keyId)
                teamId: \(teamId)
                """ }

        let fileUrl = URL(fileURLWithPath: keyPath)


        let generator = AppleMusicTokenGenerator(keyId: keyId,
                                                 teamId: teamId,
                                                 privatKeyPath: fileUrl.path)

        guard generator.loadPrivateKey() != nil else { return "can't load key. Wrong path? path: \(fileUrl)" }

        if let seconds = seconds {
            print("Token generated: \(Date())")
            print("valid until \(Date().add(seconds: seconds))")
            return generator.generateToken(expirationDate: Date().add(seconds: seconds)) ?? .standardErrorMessage
        } else {
            // 24 hours
            print("Token generated: \(Date())")
            print("valid until: \(Date.validFor24Hours)")
            return generator.generateToken() ?? .standardErrorMessage
        }
    }
}


extension String {
    static var standardErrorMessage = "SOMETHING WENT WRONG"
}
