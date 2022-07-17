for plugin_name in "${plugins[@]}"; do
	local plugin_path="$REPO_ZSH_DIR/plugins/$plugin_name/$plugin_name.zsh"
	local completion_files_path="$REPO_ZSH_DIR/plugins/$plugin_name/_*"

	source $plugin_path
	completion_files=$(find $REPO_ZSH_DIR/plugins/$plugin_name -maxdepth 1 -name "_*")
	for completions_file_path in "${completion_files[@]}"; do
		fpath+="$(dirname "${completion_files_path}")"
		completion_file="$(basename "${completion_file_path}")"
		compinit "${completion_file:1}"
	done
done
