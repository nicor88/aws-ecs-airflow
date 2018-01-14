# truncate staging table: eg. staging.braze_campaigns_analytics;
# get max_populated_at from destination table: dwh.braze_campaigns_analytics_fact_dev;
# insert to staging.braze_campaigns_analytics the records from braze.braze_campaigns_analytics with a populated_at > max_populated_at
# delete from dwh.braze_campaigns_analytics_fact_dev the records that join staging.braze_campaigns_analytics with date_sk,campaign_id,variation_name, message_type
# Insert in dwh.braze_campaigns_analytics_fact_dev all the rows from staging
