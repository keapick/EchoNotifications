# EchoNotification

iOS push notification example

![Rich Notification screenshot](Documentation/Images/ImageNotification2.png)

# Apple push certificate

Create a push certificate on the [Apple developer site](https://developer.apple.com).

![Create Push Cert screenshot 1](Documentation/Images/CreatePushCert1.png)
![Create Push Cert screenshot 2](Documentation/Images/CreatePushCert2.png)

# Server certificate

Create a p12 server certificate with keychain.

![Request cert screenshot](Documentation/Images/RequestCertViaKeychain.png)

![Export cert screenshot 1](Documentation/Images/KeychainExport1.png)

![Export cert screenshot 2](Documentation/Images/KeychainExport2.png)

![Export cert screenshot 3](Documentation/Images/KeychainExport3.png)

# AWS Simple Notification Service

Upload credentials to [AWS Simple Notification Service](https://aws.amazon.com/sns/).

![Upload credentials to AWS screenshot](Documentation/Images/UploadCertToAWS.png)

Create an Application and register your device as an endpoint.

![Application AWS screenshot](Documentation/Images/AWSPush1.png)

![Endpoint AWS screenshot](Documentation/Images/AWSPush2.png)

Sample push payload
```
{
  "APNS_SANDBOX": "{\"aps\":{\"alert\":\"Hello World\"}}"
}
```

Sample push payload with image
```
{
    "APNS_SANDBOX": "{\"aps\":{\"alert\":\"Hello World\",\”mutable-content\":1},\"assetURL\":\"https://upload.wikimedia.org/wikipedia/commons/0/06/Pierre_de_Coubertin_Anefo.jpg\"}"
}
```

# Testing

Test media URLs

![Asset test screenshot](Documentation/Images/TestRichAssetURL.png)

Successful rich notification

![Success screenshot](Documentation/Images/ImageNotification1.png)

Failure notification

![Failure screenshot](Documentation/Images/ErrorNotification.png)
