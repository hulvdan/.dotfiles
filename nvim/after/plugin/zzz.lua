-- DOCS: This file gets executed after all the lua files (in the directory of this file) get executed
print("INFO(zzz.lua): Sourcing '*.lua' files from .nvim-personal directory...")

for i, fpath in pairs(vim.fn.split(vim.fn.globpath(".nvim-personal", "*.lua"), "\n")) do
  print("INFO(zzz.lua): Sourcing " .. fpath .. "...")
  vim.fn.execute("luafile " .. fpath)
end

-- -- init.lua
-- local function global_automapping()
--   -- Обычно нужны только эти режимы для перевода
--   -- Несмотря на то, что 'v' содержит в себе 'x' и 's',
--   -- их нужно указать отдельно
--   local allowed_modes = { 'n', 's', 'x', 'v' }
--
--   local mappings = {}
--
--   for _, mode in ipairs(allowed_modes) do
--     local maps = vim.api.nvim_get_keymap(mode)
--     for _, map in ipairs(maps) do
--       local lhs, desc, modes = map.lhs, map.desc, vim.split(map.mode, '')
--       table.insert(mappings, { lhs = lhs, desc = desc, mode = modes })
--     end
--   end
--
--   for _, map in ipairs(mappings) do
--     local lhs = translate_keycode(map.lhs)
--     for _, mode in ipairs(map.mode) do
--       -- Проверка, что переведенный маппинг не поторяет оригинальный маппинг
--       -- и что он еще не был зарегистрирован
--       if not (map.lhs == lhs or has_map(lhs, mode, mappings)) then
--         local opts = {
--           callback = function()
--             local repl = vim.api.nvim_replace_termcodes(map.lhs, true, true, true)
--             -- 'm' здесь означет, что нужно использовать
--             -- remap при вводе символов
--             vim.api.nvim_feedkeys(repl, 'm', true)
--           end,
--           desc = map.desc .. '(translated)',
--         }
--
--         vim.api.nvim_set_keymap(mode, lhs, '', opts)
--       end
--     end
--   end
-- end
--
-- global_automapping()
