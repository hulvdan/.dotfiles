local cmd = 'cmd.exe /C tasklist /FI "IMAGENAME eq game.exe"'
local output = reaper.ExecProcess(cmd, 1000) -- 1-second timeout

-- Check if the process name appears in the result
if output:match("game.exe") then
  local cwd = os.getenv("REAPER_LAUNCH_CWD"):gsub("%s+$", "")
  reaper.ExecProcess(string.format([[cmd /c "%s/cli/win_codegen_debug.bat"]], cwd), -1)
end
