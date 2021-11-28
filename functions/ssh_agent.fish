function _ssh_agent_is_started -d "check if a process for ssh-agent is already started"
    if test -n (command pgrep ssh-agent | string collect | string trim)
        echo true
    else
        echo false
    end
end

function _ssh_agent_start -d "start a new ssh agent"
    if string match -q "false" (_ssh_agent_is_started)
        echo "started previously"
        return
    end
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    true # suppress errors from setenv, i.e. set -gx
end

function _ssh_agent_stop -d "stop the running ssh agents"
    command pgrep ssh-agent | string collect | command xargs kill -9

    set -eg SSH_AUTH_SOCK
    set -eg SSH_AGENT_PID
end

function _ssh_agent_check -d "check if the agent is running"
    if string match -q "false" (_ssh_agent_is_started)
        echo "Not started"
    else
        echo "Started"
    end
end

function ssh_agent_fish --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
    switch "$argv"
        case "" -h --help
            echo "Usage: ssh_agent_fish start    Starts ssh-agent if not started already."
            echo "       ssh_agent_fish stop     Stops ssh-agent if started already."
            echo "       ssh_agent_fish check    Checks if ssh-agent started already."
            echo "Options:"
            echo "       -h or --help     Print this help message"
        case start
            if string match -q "false" (_ssh_agent_is_started)
                _ssh_agent_start
            end
        case stop
            _ssh_agent_stop
        case check
            _ssh_agent_check
        case \*
            echo "ssh_agent_fish: Unknown command or option: \"$argv\" (see ssh_agent -h)" >&2
            return 1
    end
end
