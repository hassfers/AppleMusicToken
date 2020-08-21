# AppleMusicToken

Docker container for generating Apple Music Tokens for Apple Music API written fully in swift with vapor.

A MusicKey from Apple is needed to use it. Get one from your developer page => keys

## Configuration with Environment Variables

KEY_ID: the key id you get from Apple  
TEAM_ID: your team id  
KEY_PATH: the path of the key file (*.p8)  

optional:  
VALID_FOR_SECONDS: time in seconds the token is valid (if not present the token will be valid for 24 hours)
