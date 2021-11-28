function _ssh_agent_uninstall --on-event ssh_agent_uninstall
    functions --erase (functions --all | string match --entire --regex -- "^_ssh_agent_")
end

set --local sshAgentFunctions (functions --all | string match --entire --regex -- "ssh_agent")
echo "ssh_agent.fish functions: $sshAgentFunctions"
if status is-interactive
    # ssh_agent_fish start
end
