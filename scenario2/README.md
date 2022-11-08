# Scenario 2 for K8s

###

virajvinodkumar@DESKTOP-NUD4SOC:~/terraform-aws-nginx/scenario2$ ls -ltr
total 8
-rw-r--r-- 1 virajvinodkumar virajvinodkumar 1013 Nov  8 13:46 app.yaml
-rw-r--r-- 1 virajvinodkumar virajvinodkumar  898 Nov  8 13:46 mysql.yaml
-rw-r--r-- 1 virajvinodkumar virajvinodkumar  453 Nov  8 13:46 pv-mysql.yaml
drwxr-xr-x 1 virajvinodkumar virajvinodkumar  512 Nov  8 13:46 sourcecode
-rw-r--r-- 1 virajvinodkumar virajvinodkumar   21 Nov  8 14:08 README.md
virajvinodkumar@DESKTOP-NUD4SOC:~/terraform-aws-nginx/scenario2$ kubectl.exe get po,deploy,cm,secret,svc
NAME                          READY   STATUS    RESTARTS   AGE
pod/mysql-8497d575bd-2pzq9    1/1     Running   0          30m
pod/webapp-77b4bbc45c-sm24j   1/1     Running   0          30m

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysql    1/1     1            1           30m
deployment.apps/webapp   1/1     1            1           30m

NAME                         DATA   AGE
configmap/kube-root-ca.crt   1      169m
configmap/source-code        3      35m

NAME                TYPE     DATA   AGE
secret/mysql-pass   Opaque   1      112m

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        170m
service/mysql        ClusterIP   None             <none>        3306/TCP       30m
service/webpp        NodePort    10.107.254.149   <none>        80:30236/TCP   30m
virajvinodkumar@DESKTOP-NUD4SOC:~/terraform-aws-nginx/scenario2$

![image](https://user-images.githubusercontent.com/28803383/200516443-2d1ecfdb-1d96-4b96-8ef7-cfc65e544646.png)
