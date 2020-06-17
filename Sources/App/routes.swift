import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("token") { req -> String in
        let directory = DirectoryConfiguration.detect()
        let keyName = "AuthKey_546FNHJK58.p8"
        let keyPath = "Sources/App/Asserts"
        
        let fileUrl = URL(fileURLWithPath: directory.workingDirectory)
            .appendingPathComponent(keyPath)
            .appendingPathComponent(keyName)
        

        print(fileUrl)
        
        let gen = AppleMusicTokenGenerator(keyId: "test", teamId: "test", privatKeyPath: fileUrl.path)
        
        print("Token generated")
        return gen.generateToken() ?? app.directory.workingDirectory
    }
}
