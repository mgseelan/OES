
import requests
checkUrl = ["http://localhost:9000" + "         minio" , "http://localhost:7002/health" + "     clouddriver" , "http://localhost:9000/health" + "       deck" , "http://localhost:8089/health" + "      echo", "http://localhost:7003/health" + "       fiat" , "http://localhost:8080/health" + "      front50" , "http://localhost:8084/health" + "   gate" , "http://localhost:8064/health" + "      Halyard" ,"http://localhost:8088/health" + "    igor" , "http://localhost:8090/health" + "      Kayenta" , "http://localhost:8083/health" + "   orca" , "http://localhost:8087/health" + "      Rosco "]

flag = 0
for x in checkUrl:

        try:
                resp = requests.post(url=x)
                if resp.status_code == 200:
                        print("Healthy")
        except Exception as e:
                print( x + " service not available  ")

                flag = 1

if flag == 0:
        print("Healthy")
else:
        print("Unhealthy")

	
