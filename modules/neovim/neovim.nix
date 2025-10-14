{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;

    # configure = {
    #    customLuaRC = lib.fileContents ./init.lua;
    # };
  };
}
