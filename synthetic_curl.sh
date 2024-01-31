METRIC_NAME="example.ping"

CURRENT_TIME=$(date +%s)

METRIC_VALUE=1

curl -X POST "https://api.datadog.com/api/v1/series" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: $DD_API_KEY" \
-d "{
      'series' : 
        [{
          'metric': '$METRIC_NAME',
          'points': [
              [$CURRENT_TIME, $METRIC_VALUE]
          ],
          'type': 'gauge',
          'host': 'example.com',
          'tags': [
              'environment:ci'
          ]
        }]
    }"

echo "Ping sent to Datadog."
