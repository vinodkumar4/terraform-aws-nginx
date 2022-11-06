# terraform-aws-nginx

## Suggested Improvements to architecture
1. All Traffic should be encrypted so integrating ACM will help.
2. If ACM is integrated, then required port e.g. 443 should be enabled.
3. Access of web content in S3 bucket must be via S3 gateway endpoints.
4. VPC should be custom than a default (which I have used already).
5. Finally some logging on different components e.g. ALB, VPC flow logs and Cloud watch metrics/logs is helpful depending upon requirements.

## Screenshot before uppercase 
![image](https://user-images.githubusercontent.com/28803383/200167143-b62c0b56-0d0f-4b32-a28c-c4bfe5452d82.png)


## Screenshot after uppercase only for COUNTER

![image](https://user-images.githubusercontent.com/28803383/200167165-0c98ca8a-551f-4505-8adb-e93c37aa9990.png)
