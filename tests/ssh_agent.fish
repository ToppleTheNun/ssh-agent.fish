@echo === ssh_agent ===

@test "can stop a running ssh-agent" (
    ssh_agent_fish stop
) $status -eq 0

@test "can start a ssh-agent" (
    ssh_agent_fish start
) $status -eq 0

@test "can check if ssh-agent is not started" (
    ssh_agent_fish stop && ssh_agent_fish check
) = "Not started"

@test "can check if ssh-agent is started" (
    ssh_agent_fish start && ssh_agent_fish check
) = "Started"

# @test "can detect if ssh-agent is not running" (
#     @echo === can detect if ssh-agent is not running ===
#     # _ssh_agent_stop
#     # _ssh_agent_is_started
# ) $status -eq 1

# @test "can start ssh-agent" (
#     @echo === can start ssh-agent ===
#     # _ssh_agent_start
#     # _ssh_agent_get_pids
# ) != ""

# @test "can detect if ssh-agent is running" (
#     @echo === can detect if ssh-agent is running ===
#     # _ssh_agent_start
#     # _ssh_agent_is_started
# ) $status -eq 1
