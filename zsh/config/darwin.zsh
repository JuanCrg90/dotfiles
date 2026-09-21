# Optional macOS integrations. Keep non-portable paths out of shared config.

postgres_app_bin="/Applications/Postgres.app/Contents/Versions/latest/bin"
[[ -d "$postgres_app_bin" ]] && path=("$postgres_app_bin" $path)

# The Tailscale app bundle does not always expose its CLI on PATH.
tailscale_app_bin="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
if (( ! $+commands[tailscale] )) && [[ -x "$tailscale_app_bin" ]]; then
  alias tailscale="$tailscale_app_bin"
fi

unset postgres_app_bin tailscale_app_bin
