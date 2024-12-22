{ config, lib, ... }:
let
  home = config.home.homeDirectory;
in
{
  config = {
    home = rec {
      activation = let
        dirsToCreate = with config.home.sessionVariables; [
          ANDROID_HOME
          ANDROID_USER_HOME
          CUDA_CACHE_PATH
          DOTNET_CLI_HOME
          STACK_ROOT
          CARGO_HOME
          NPM_CONFIG_CACHE
          NUGET_PACKAGES
          PLATFORMIO_CORE_DIR
          PLATFORMIO_CACHE_DIR
          PLATFORMIO_BUILD_CACHE_DIR
          TASKDATA
          W3M_HOME
          XDG_BIN_HOME
        ];
      in {
        init = with lib; hm.dag.entryAfter ["writeBoundary"] ''
          ${builtins.concatStringsSep "\n" 
          (map (dir: "mkdir -p ${dir}") dirsToCreate)
          }  
        '';
      };
      sessionVariables = with config.xdg; rec {
        # gtfo my HOME goddamnit
        ANDROID_HOME = "${dataHome}/android";
        ANDROID_USER_HOME = "${configHome}/android";
        CUDA_CACHE_PATH = "${cacheHome}/cuda";
        DOTNET_CLI_HOME = "${dataHome}/dotnet";
        GHCUP_USE_XDG_DIRS = "1";
        STACK_ROOT = "${dataHome}/stack";
        CARGO_HOME = "${dataHome}/cargo";
        NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
        NODE_REPL_HISTORY = "${stateHome}/node_repl_hist";
        NPM_CONFIG_CACHE = "${cacheHome}/npm";
        NUGET_PACKAGES = "${dataHome}/NuGetPackages";
        PLATFORMIO_CORE_DIR = "${dataHome}/platformio";
        PLATFORMIO_CACHE_DIR = "${cacheHome}/platformio";
        PLATFORMIO_BUILD_CACHE_DIR = "${PLATFORMIO_CACHE_DIR}";
        PYTHONHISTORY = "${stateHome}/python_hist";
        TASKDATA = "${configHome}/task";
        W3M_HOME = "${dataHome}/w3m";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";

        # Unofficial XDG dir
        XDG_BIN_HOME = "${home}/.local/bin";
      };
      sessionPath = [ sessionVariables.XDG_BIN_HOME ];
    };
    xdg = {
      enable = true;
      cacheHome = "${home}/.cache";
      configHome = "${home}/.config";
      dataHome = "${home}/.local/share";
      stateHome = "${home}/.local/state";

      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${home}/.local/desktop";
        documents = "${home}/docs";
        download = "${home}/dl";
        music = "${home}/audio";
        pictures = "${home}/pics";
        publicShare = "${home}/.local/public";
        templates = "${home}/.local/templates";
        videos = "${home}/vids";
      };
    };
  };
}
