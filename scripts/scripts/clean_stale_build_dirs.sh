#!/usr/bin/env bash
#
# clean_stale_build_dirs.sh
#
# Finds node_modules and .next directories anywhere under
# ~/Documents/projects (no matter how deeply nested) whose contents
# haven't been modified in the last N days, and deletes them.
#
# Default mode is FULL AUTO: everything stale gets deleted, no prompts.
# Everything is echoed to the terminal in real time, and a summary of
# what was deleted (and anything that failed) is printed at the end.
#
# Usage:
#   ./clean_stale_build_dirs.sh            # auto-delete everything stale
#   ./clean_stale_build_dirs.sh --ask      # ask Y/N for each stale dir
#   ./clean_stale_build_dirs.sh --dry-run  # just list stale dirs, delete nothing
#   DAYS=45 ./clean_stale_build_dirs.sh    # change the "stale" threshold

set -uo pipefail   # NOTE: no -e, so one failed rm can't kill the whole run

SEARCH_GLOB="$HOME/Documents/projects"
DAYS="${DAYS:-20}"
MODE="force"   # force | ask | dry-run

case "${1:-}" in
    --ask)     MODE="ask" ;;
    --dry-run) MODE="dry-run" ;;
    --force)   MODE="force" ;;
esac

deleted_list=()
failed_list=()
skipped_list=()

echo "Scanning: $SEARCH_GLOB"
echo "Stale threshold: $DAYS days"
echo "Mode: $MODE"
echo "---"

shopt -s nullglob
found_any=false

for base in $SEARCH_GLOB; do
    [[ -d "$base" ]] || continue

    while IFS= read -r -d '' target; do
        found_any=true

        newest_recent=$(find "$target" -type f -mtime "-$DAYS" -print -quit 2>/dev/null || true)

        if [[ -z "$newest_recent" ]]; then
            echo "STALE (>$DAYS days): $target"

            do_delete=false
            case "$MODE" in
                dry-run)
                    do_delete=false
                    ;;
                force)
                    do_delete=true
                    ;;
                ask)
                    while true; do
                        read -r -p "  Delete this? [y/N] " answer </dev/tty
                        answer="${answer:-N}"
                        case "$answer" in
                            [Yy]|[Yy][Ee][Ss]) do_delete=true; break ;;
                            [Nn]|[Nn][Oo])     do_delete=false; break ;;
                            *) echo "  Please answer y or n." ;;
                        esac
                    done
                    ;;
            esac

            if [[ "$do_delete" == true ]]; then
                if rm -rf -- "$target"; then
                    echo "  -> deleted"
                    deleted_list+=("$target")
                else
                    echo "  -> FAILED TO DELETE"
                    failed_list+=("$target")
                fi
            else
                echo "  -> skipped (dry run)"
                skipped_list+=("$target")
            fi
        else
            echo "active, skipping:    $target"
        fi
    done < <(find "$base" -type d \( -name "node_modules" -o -name ".next" \) -prune -print0)
done

if [[ "$found_any" == false ]]; then
    echo "No node_modules or .next directories found under $SEARCH_GLOB"
fi

echo "---"
echo "SUMMARY"
echo "Deleted (${#deleted_list[@]}):"
for p in "${deleted_list[@]}"; do echo "  $p"; done

if [[ ${#failed_list[@]} -gt 0 ]]; then
    echo "FAILED (${#failed_list[@]}) — these were NOT deleted, check permissions/locks:"
    for p in "${failed_list[@]}"; do echo "  $p"; done
fi

if [[ "$MODE" == "dry-run" && ${#skipped_list[@]} -gt 0 ]]; then
    echo "Would have deleted (${#skipped_list[@]}) — dry run, nothing actually removed:"
    for p in "${skipped_list[@]}"; do echo "  $p"; done
fi
