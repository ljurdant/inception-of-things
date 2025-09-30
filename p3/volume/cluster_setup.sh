k3d cluster create ljurdant-cluster --port 8080:443@loadbalancer -p 8888:8888@loadbalancer

kubectl create namespace argocd
kubectl create namespace dev


kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s

kubectl apply -f ./app.yaml -n dev

sudo argocd login localhost:8080 --insecure --username admin --password $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
sudo argocd account update-password --account admin --current-password $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --new-password ljurdantjeepark

sudo kubectl config set-context --current --namespace=argocd
sudo argocd app create app --repo https://github.com/ljurdant/iot-ljurdant-jeepark --path . --dest-server https://kubernetes.default.svc --dest-namespace dev
sudo argocd app set app --sync-policy automated
sudo argocd app sync app