curl -X POST "https://api.datadoghq.com/api/v1/synthetics/tests/api" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-d @- << EOF
{
  "config": {
    "assertions": [
      {
        "operator": "lessThan",
        "target": 1000,
        "type": "responseTime"
      },
      {
        "operator": "is",
        "target": 200,
        "type": "statusCode"
      },
      {
        "operator": "is",
        "property": "content-type",
        "target": "text/html; charset=UTF-8",
        "type": "header"
      }
    ],
    "request": {
      "method": "GET",
      "url": "https://example.com"
    }
  },
  "locations": [
    "azure:eastus",
    "aws:eu-west-3"
  ],
  "message": "MY_NOTIFICATION_MESSAGE",
  "name": "MY_TEST_NAME",
  "options": {
    "min_failure_duration": 0,
    "min_location_failed": 1,
    "monitor_options": {
      "include_tags": true,
      "locked": false,
      "new_host_delay": 300,
      "notify_audit": false,
      "notify_no_data": false,
      "renotify_interval": 0
    },
    "tick_every": 60
  },
  "status": "live",
  "subtype": "http",
  "tags": [
    "env:production"
  ],
  "type": "api"
}
EOF
## Create a Multistep API test
# Example of a multistep API test running on a fake furniture store.
# It creates a card, select a product and then add the product to the card.

# Curl command
curl -X POST "https://api.datadoghq.com/api/v1/synthetics/tests/api" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-d @- << EOF
{
  "config": {
    "steps": [
      {
        "assertions": [
          {
            "operator": "lessThan",
            "target": 30000,
            "type": "responseTime"
          }
        ],
        "extractedValues": [
          {
            "field": "location",
            "name": "CART_ID",
            "parser": {
              "type": "regex",
              "value": "(?:[^\\\\/](?!(\\\\|/)))+$"
            },
            "type": "http_header"
          }
        ],
        "name": "Get a cart",
        "request": {
          "method": "POST",
          "timeout": 30,
          "url": "https://api.shopist.io/carts"
        },
        "subtype": "http"
      },
      {
        "assertions": [
          {
            "operator": "is",
            "target": 200,
            "type": "statusCode"
          }
        ],
        "extractedValues": [
          {
            "name": "PRODUCT_ID",
            "parser": {
              "type": "json_path",
              "value": "$[0].id['$oid']"
            },
            "type": "http_body"
          }
        ],
        "name": "Get a product",
        "request": {
          "method": "GET",
          "timeout": 30,
          "url": "https://api.shopist.io/products.json"
        },
        "subtype": "http"
      },
      {
        "assertions": [
          {
            "operator": "is",
            "target": 201,
            "type": "statusCode"
          }
        ],
        "name": "Add product to cart",
        "request": {
          "body": "{\n  \"cart_item\": {\n    \"product_id\": \"{{ PRODUCT_ID }}\",\n    \"amount_paid\": 500,\n    \"quantity\": 1\n  },\n  \"cart_id\": \"{{ CART_ID }}\"\n}",
          "headers": {
            "content-type": "application/json"
          },
          "method": "POST",
          "timeout": 30,
          "url": "https://api.shopist.io/add_item.json"
        },
        "subtype": "http"
      }
    ]
  },
  "locations": [
    "aws:us-west-2"
  ],
  "message": "MY_NOTIFICATION_MESSAGE",
  "name": "MY_TEST_NAME",
  "options": {
    "ci": {
      "executionRule": "blocking"
    },
    "min_failure_duration": 5400,
    "min_location_failed": 1,
    "monitor_options": {
      "renotify_interval": 0
    },
    "retry": {
      "count": 3,
      "interval": 300
    },
    "tick_every": 900
  },
  "status": "live",
  "subtype": "multi",
  "tags": [
    "env:prod"
  ],
  "type": "api"
}
EOF
