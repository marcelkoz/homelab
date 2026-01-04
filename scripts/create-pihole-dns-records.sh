#!/usr/bin/env bash

BASE_URL="$PIHOLE_API_BASE_URL" # export PIHOLE_API_BASE_URL='https://FQDN/api'
PASS="$PIHOLE_PASS" # export PIHOLE_PASS='password'
IP_ADDRESS="$PIHOLE_IP" # export PIHOLE_IP='127.0.0.1'
HOSTNAME="$PIHOLE_HOSTNAME" # export PIHOLE_HOSTNAME='pihole.example.com'
DOMAIN="$HOMELAB_DOMAIN" # export HOMELAB_DOMAIN='example.com'

request() {
    curl -k -X $1 "$BASE_URL$2" --data "$3"
}

# session token
echo "VAR PASSWORD=$PASS"

SESSION_RESPONSE=$(request POST /auth "{\"password\":\"$PASS\"}")
echo "VAR SESSION JSON=$SESSION_RESPONSE"

SESSION_TOKEN=$(echo $SESSION_RESPONSE | jq -r .session.sid)
echo "VAR SESSION TOKEN=$SESSION_TOKEN"

# create DNS A record
request PUT https://pihole.mkoz.net/api/config/dns/hosts/$IP_ADDRESS%20$HOSTNAME "{\"sid\":\"$SESSION_TOKEN\"}"

# create DNS CNAME records
SUBDOMAINS=(authentik daisy git grafana home pihole portainer prometheus proxy)
for SUB in "${SUBDOMAINS[@]}"; do 
    request PUT "/config/dns/cnameRecords/$SUB.$DOMAIN%2C$HOSTNAME" "{\"sid\":\"$SESSION_TOKEN\"}"
    sleep 3
done

# delete session token
request DELETE /auth "{\"sid\":\"$SESSION_TOKEN\"}"
