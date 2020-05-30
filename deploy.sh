# building images
docker build -t anmoldesai4/multi-client:latest -t anmoldesai4/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t anmoldesai4/multi-server:latest -t anmoldesai4/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t anmoldesai4/multi-worker:latest -t anmoldesai4/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push images to dockerhub
docker push anmoldesai4/multi-client:latest
docker push anmoldesai4/multi-server:latest
docker push anmoldesai4/multi-worker:latest

# push images with sha tag
docker push anmoldesai4/multi-client:$SHA
docker push anmoldesai4/multi-server:$SHA
docker push anmoldesai4/multi-worker:$SHA

# take all configs in k8s and apply them to google cloud
kubectl apply -f k8s

# set latest image on each deployment
kubectl set image deployments/server-deployment server=anmoldesai4/multi-server:$SHA
kubectl set image deployments/client-deployment client=anmoldesai4/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=anmoldesai4/multi-worker:$SHA