function _ssh_agent_uninstall --on-event ssh_agent_uninstall
    functions --erase (functions --all | string match --entire --regex -- "^_ssh_agent_")
end

if status is-interactive
    ssh_agent start
end
