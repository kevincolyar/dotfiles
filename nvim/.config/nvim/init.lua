local conf_files = {
	"globals.lua",
	"options.vim",
	"autocommands.vim",
	"mappings.lua",
	"plugins.vim",
	"colorschemes.lua"
}

for _, name in ipairs(conf_files) do
	local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
	local cmd = "source " .. path
	vim.cmd(cmd)
end
