{ pkgs
, inputs
, self
, lib
, platform
, ...
}:
let
  allowedPlatforms = [ "desktop" "macbook" ];
in
lib.mkIf (builtins.elem platform allowedPlatforms) {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greetingv
    '';
    # plugins = [];
  };

  # home.file.".config/fish/themes/Frappe.theme".text = ''
  #   fish_color_normal c6d0f5
  #   fish_color_command 8caaee
  #   fish_color_param eebebe
  #   fish_color_keyword e78284
  #   fish_color_quote a6d189
  #   fish_color_redirection f4b8e4
  #   fish_color_end ef9f76
  #   fish_color_comment 838ba7
  #   fish_color_error e78284
  #   fish_color_gray 737994
  #   fish_color_selection --background=414559
  #   fish_color_search_match --background=414559
  #   fish_color_option a6d189
  #   fish_color_operator f4b8e4
  #   fish_color_escape ea999c
  #   fish_color_autosuggestion 737994
  #   fish_color_cancel e78284
  #   fish_color_cwd e5c890
  #   fish_color_user 81c8be
  #   fish_color_host 8caaee
  #   fish_color_host_remote a6d189
  #   fish_color_status e78284
  #   fish_pager_color_progress 737994
  #   fish_pager_color_prefix f4b8e4
  #   fish_pager_color_completion c6d0f5
  #   fish_pager_color_description 737994
  # '';
}

