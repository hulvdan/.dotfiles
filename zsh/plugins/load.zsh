for plugin_name in "${plugins[@]}"; do
	local plugin_path="$REPO_ZSH_DIR/plugins/$plugin_name/$plugin_name.zsh"
	local completion_file_path="$REPO_ZSH_DIR/plugins/$plugin_name/_$plugin_name.zsh"

	source $plugin_path
	if [ -f $completion_file_path ]; then
		fpath+="$(dirname "${completion_file_path}")"
		completion_file="$(basename "${completion_file_path}")"
		compinit "${completion_file:1}"
	fi
done
