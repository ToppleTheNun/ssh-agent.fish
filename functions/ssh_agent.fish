function _ssh_agent_is_started -d "check if a process for ssh-agent is already started"
    if string match -r "\d" -q (command pgrep ssh-agent | string collect | string trim)
        echo true
    else
        echo false
    end
end

function _ssh_agent_start -d "start a new ssh agent"
    if string match -q "true" (_ssh_agent_is_started)
        return
    end

    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end

    mkdir -p (dirname $SSH_ENV)
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
    if string match -q "*false*" (_ssh_agent_is_started)
        echo "Not started"
    else
        echo "Started"
    end
end

function _ssh_agent_help -d "prints help message for command"
    echo "Usage: ssh_agent start    Starts ssh-agent if not started already."
    echo "       ssh_agent stop     Stops ssh-agent if started already."
    echo "       ssh_agent check    Checks if ssh-agent started already."
    echo "Options:"
    echo "       -h or --help     Print this help message"
end

function ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
    switch "$argv"
        case "" -h --help
            _ssh_agent_help
        case start
            _ssh_agent_start
        case stop
            _ssh_agent_stop
        case check
            _ssh_agent_check
        case \*
            echo "ssh_agent: Unknown command or option: \"$argv\" (see ssh_agent -h)" >&2
            return 1
    end
end
