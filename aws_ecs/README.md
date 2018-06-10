# AWS ECS

## Configure ecs cli
<pre>
ecs-cli configure profile --profile-name nicor88 --access-key your_access_key --secret-key your_secret_key
ecs-cli configure --cluster airflow --default-launch-type EC2 --region eu-west-1 --config-name airflow
ecs-cli compose --file airflow.yml
</pre>