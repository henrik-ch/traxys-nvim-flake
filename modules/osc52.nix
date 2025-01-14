{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    plugins.osc52 = {
      copy = mkOption {
        type = types.str;
        description = "Copy into the system clipboard using OSC52";
        default = "<leader>y";
      };

      copy_line = mkOption {
        type = types.str;
        description = "Copy line into the system clipboard using OSC52";
        default = "<leader>yy";
      };

      copy_visual = mkOption {
        type = types.str;
        description = "Copy visual selection into the system clipboard using OSC52";
        default = "<leader>y";
      };
    };
  };
  config = let
    cfg = config.plugins.osc52;
  in
    mkIf cfg.enable {
      lua_keymaps = {
        n = {
          "${cfg.copy}" = {
            rhs = "require('osc52').copy_operator";
            lua = true;
            opts = {
              expr = true;
            };
          };
          "${cfg.copy_line}" = {
            rhs = "${cfg.copy}_";
            opts = {
              remap = true;
            };
          };
        };
        v = {
          "${cfg.copy_visual}" = {
            rhs = "require('osc52').copy_visual";
            lua = true;
          };
        };
      };
    };
}
