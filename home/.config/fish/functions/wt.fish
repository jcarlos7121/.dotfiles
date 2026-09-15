function wt --description 'Switch to a worktree of the current repo (or its main worktree) and run hookup post-checkout if available'
    # Must be inside a git repo to know which set of worktrees to consider
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "wt: not inside a git repository — cd into any worktree of the target repo first"
        return 1
    end

    # The main worktree is the first entry in `git worktree list`; secondary worktrees follow
    set -l worktrees (git worktree list | awk '{print $1}')
    set -l main_repo $worktrees[1]
    set -l other_paths
    for p in $worktrees[2..-1]
        set -a other_paths $p
    end

    # Capture the leaving worktree's HEAD so hookup can diff prev → new
    set -l prev_sha (git rev-parse HEAD 2>/dev/null)

    # No args → list available targets and bail
    if test (count $argv) -eq 0
        echo "Usage: wt <name>"
        echo ""
        echo "Worktrees of "(basename $main_repo)":"
        echo "  master  → $main_repo"
        for p in $other_paths
            echo "  "(basename $p)"  → $p"
        end
        return 1
    end

    # Resolve target path
    set -l target
    switch $argv[1]
        case master main
            set target $main_repo
        case '*'
            set -l matches
            for p in $other_paths
                if string match -q "$argv[1]*" (basename $p)
                    set -a matches $p
                end
            end

            if test (count $matches) -eq 0
                echo "wt: no worktree matching '$argv[1]'"
                return 1
            else if test (count $matches) -gt 1
                echo "wt: multiple worktrees match '$argv[1]':"
                for m in $matches
                    echo "  "(basename $m)
                end
                return 1
            end

            set target $matches[1]
    end

    cd $target; or return 1

    # Skip hookup gracefully if not in a Bundler project, or if hookup isn't a gem here
    if not test -f Gemfile.lock
        return 0
    end
    if not grep -qE '^\s+hookup\b' Gemfile.lock 2>/dev/null
        return 0
    end

    # Pick a sensible base SHA for hookup:
    #   - If we came from another worktree, use that worktree's HEAD (so hookup can roll
    #     back the leaving branch's migrations and apply the entering branch's).
    #   - Otherwise, fall back to the fork point with master / main, then to HEAD~ as a last resort.
    set -l base
    if test -n "$prev_sha"
        set base $prev_sha
    else
        for ref in master main
            set base (git merge-base HEAD $ref 2>/dev/null)
            and break
        end
        if test -z "$base"
            set base (git rev-parse HEAD~ 2>/dev/null)
        end
    end

    if test -z "$base"
        return 0
    end

    bundle exec hookup post-checkout $base HEAD 1
end
