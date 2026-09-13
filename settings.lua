data:extend({
  {
    type = "string-setting",
    name = "plate-group-subgroups",
    setting_type = "startup",
    default_value = "textplates, display-plates",
    allow_blank = true,
    order = "a",
  },
  {
    type = "string-setting",
    name = "plate-group-items",
    setting_type = "startup",
    default_value = "",
    allow_blank = true,
    order = "b",
  },
  {
    type = "string-setting",
    name = "plate-group-order",
    setting_type = "startup",
    default_value = "d-b",
    allow_blank = false,
    order = "c",
  },
})
