function _fzf_search_git_branch --description "Search git branches. Replace the current token with the selected branch name."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '_fzf_search_git_branch: Not in a git repository.' >&2
    else
        set -f selected_branch (
            git branch --all --color=always |
            grep -v HEAD |
            _fzf_wrapper --ansi \
                --prompt="Git Branch> " \
                --query=(commandline --current-token) \
                --preview='git log --oneline --graph --color=always {2}' \
                $fzf_git_branch_opts
        )
        if test $status -eq 0
            # Remove leading spaces and * from branch name
            set -f branch_name (string trim $selected_branch | string replace -r '^\* ' '' | string replace -r '^remotes/' '')
            commandline --current-token --replace -- $branch_name
        end
    end

    commandline --function repaint
end