require("full-border"):setup()
require("git"):setup()

-- git plugin
th.git = th.git or {}
th.git.added = ui.Style():fg("green")
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red")

th.git.added_sign = "A"
th.git.modified_sign = "M"
th.git.deleted_sign = "D"

-- add user:group to the status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	})
end, 500, Status.RIGHT)
