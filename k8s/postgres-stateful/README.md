# test
kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image bitnami/postgresql --env="PGPASSWORD=password" --command -- psql --host <ip> -U user

# redeploy
kubectl rollout restart statefulset/postgres -n postgres