# Example: Golang + Fargate + Cognito

Generate Auth Header Content
```
❯ echo -n '53mlbauoeva1lrvo17qfcv5uc:1q7q00astkjspcurout59pjs2upuamfv3vo2rcgva1plt6hgekuv' | openssl base64

NTNtbGJhdW9ldmExbHJ2b******Y2d2YTFwbHQ2aGdla3V2
```

Request Access Token (client_credentials flow)
```
❯ curl -X POST https://dmtest.auth.us-west-2.amazoncognito.com/oauth2/token -H 'authorization: Basic NTNtbGJhdW9ldmExbHJ2b******Y2d2YTFwbHQ2aGdla3V2' -H 'content-type: application/x-www-form-urlencoded' 
-d 'grant_type=client_credentials&scope=clients%2Fget'
{"access_token":"eyJraWQJFdmlDQ1l5SllUek1pelk2cGhzY1wvWXdQQlJLSG45elNSMFVwT1ExMD0iLCJhbGciOiJSUzI1NiJ9.***eyJzdWIiOiI1M21sYmF1b2V2YTFscnZvMTdxZmN2NXVjIiwidG9rZW5fdXNlIjoiYWNjZXNzIiVwvdXMtd2VzdC0yX2Y4MURXbnJ1ZCIsImV4cCI6MTU1NzYwODQ3OCwiaWF0IjoxNTU3NjA0ODc4LCJ2ZXJzaW9uIjoyLCJqdGkiOiJiMTQwMDYzMi01ZGRjLTQyYmMtOWQ5ZS00MGQ5MTAxOGQ0NGIiLCJjbGllbnRfaWQiOiI1M21sYmF1b2V2YTFscnZvMTdxZmN2NXVjIn0***.Nt-2KSkfvvpFH4x9kGQc0_1XTV93Xx7sJb3GHhLgGBHpP-gcx1-qcHyT-kDFcga0MN0XYaFC5YsinQ-UaMf89UR0gYHzV5CAQpW4lqaD9r7SpExTsHiXVLKUE_akZU4i7FMcI8hJCR6mEh6nQ56qsdUUOiOj6pRaR4BN9z00beqtUoWkehcDhlTeK9XAD5hQ_brnNKtT0C7U6hGbVDhduY6HSGMhPjWiPi6BrpdH0O3YhtGr1BihKnuowf7IKClpKUy0rusOfMdJs93w","expires_in":3600,"token_type":"Bearer"}
```
