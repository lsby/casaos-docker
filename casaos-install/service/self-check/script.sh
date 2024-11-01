#!/bin/bash
echo "Running self-check..."

CASA_SERVICES=(
    "casaos-gateway.service"
    "casaos-message-bus.service"
    "casaos-user-service.service"
    "casaos-local-storage.service"
    "casaos-app-management.service"
    "rclone.service"
    "casaos.service"
)

Check_Service_status() {
    local all_services_running=true

    for SERVICE in "${CASA_SERVICES[@]}"; do
        echo "Checking ${SERVICE}..."
        if [[ $(systemctl is-active "${SERVICE}") == "active" ]]; then
            echo "${SERVICE} is running."
        else
            echo "${SERVICE} is not running."
            all_services_running=false
        fi
    done

    if $all_services_running; then
        echo "All services are running smoothly!"
    else
        echo "Some services are not running."
    fi
}

Check_Service_status
