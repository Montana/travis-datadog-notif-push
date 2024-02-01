#!/bin/bash

PROCESSED_DATADOG_EVENT_TITLE=$(echo "$DATADOG_EVENT_TITLE" | sed 's/[^a-zA-Z0-9._-]/_/g')
PROCESSED_DATADOG_EVENT_TEXT=$(echo "$DATADOG_EVENT_TEXT" | awk '{gsub(/[^a-zA-Z0-9._-]/, "_"); print}')
PROCESSED_DATADOG_EVENT_PRIORITY=$(echo "$DATADOG_EVENT_PRIORITY" | sed 's/[^a-zA-Z0-9._-]/_/g')
PROCESSED_DATADOG_EVENT_TAGS=$(echo "$DATADOG_EVENT_TAGS" | awk 'BEGIN{RS=","; ORS=","} {gsub(/[^a-zA-Z0-9._-]/, "_"); print}')
PROCESSED_DATADOG_EVENT_TAGS="${PROCESSED_DATADOG_EVENT_TAGS%,}" 

curl -X POST -H "Content-type: application/json" \
-d "{
  \"title\": \"${PROCESSED_DATADOG_EVENT_TITLE} - Failure\",
  \"text\": \"${PROCESSED_DATADOG_EVENT_TEXT} failed.\",
  \"priority\": \"${PROCESSED_DATADOG_EVENT_PRIORITY}\",
  \"tags\": \"${PROCESSED_DATADOG_EVENT_TAGS}\",
  \"alert_type\": \"error\"
}" "https://api.datadoghq.com/api/v1/events?api_key=${DATADOG_API_KEY}"
