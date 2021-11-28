@echo === ssh_agent ===

@test "can stop a running ssh-agent" (
    ssh_agent stop
) $status -eq 0

@test "can start a ssh-agent" (
    ssh_agent start
) $status -eq 0

@test "can check if ssh-agent is not started" (
    ssh_agent stop && ssh_agent check
) = "Not started"

@test "can check if ssh-agent is started" (
    ssh_agent start && ssh_agent check
) = "Started"
