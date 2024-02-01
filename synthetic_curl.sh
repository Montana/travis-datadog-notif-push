#!/bin/bash

# This will push monitoring events to the "Mendy" account in Datadog. 

DATADOG_EVENT_TITLE="$(echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g')"
DATADOG_EVENT_TEXT="$(echo "$2" | sed 's/[^a-zA-Z0-9._-]/_/g')"
DATADOG_EVENT_PRIORITY="$(echo "$3" | sed 's/[^a-zA-Z0-9._-]/_/g')"
DATADOG_EVENT_TAGS="$(echo "$4" | awk 'BEGIN{RS=","; ORS=","} {gsub(/[^a-zA-Z0-9._-]/, "_"); print}')"
DATADOG_EVENT_ALERT_TYPE="$(echo "$5" | sed 's/[^a-zA-Z0-9._-]/_/g')"

curl -X POST -H "Content-type: application/json" -d "{
  \"title\": \"${DATADOG_EVENT_TITLE} - Success\",
  \"text\": \"${DATADOG_EVENT_TEXT} succeeded.\",
  \"priority\": \"${DATADOG_EVENT_PRIORITY}\",
  \"tags\": \"${DATADOG_EVENT_TAGS}\",
  \"alert_type\": \"${DATADOG_EVENT_ALERT_TYPE}\"  
}" "https://api.datadoghq.com/api/v1/events?api_key=${DATADOG_API_KEY}"
