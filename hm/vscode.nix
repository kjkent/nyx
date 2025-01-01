{
  config,
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  config = {
    programs = {
      vscode = {
        enable = true;
        enableUpdateCheck = false;
        extensions =
          (
            # In multiple `with` exprs, earlier order == namespace priority.
            with vscode-marketplace-release;
            with vscode-marketplace; [
              astro-build.astro-vscode
              biomejs.biome
              ms-python.black-formatter
              ms-vscode.cmake-tools
              matthewpi.caddyfile-support
              catppuccin.catppuccin-vsc-icons
              llvm-vs-code-extensions.vscode-clangd
              naumovs.color-highlight
              ms-azuretools.vscode-docker
              editorconfig.editorconfig
              ms-vscode.makefile-tools
              unifiedjs.vscode-mdx
              jnoortheen.nix-ide
              christian-kohler.npm-intellisense
              platformio.platformio-ide
              yoavbls.pretty-ts-errors
              alefragnani.project-manager
              ms-python.vscode-pylance
              ms-python.python
              timonwong.shellcheck
              bradlc.vscode-tailwindcss
            ]
          )
          ++ (with vscode-extensions; [
            # Removed from nix-vscode-extensions
            # https://github.com/nix-community/nix-vscode-extensions/issues/69
            ms-vscode.cpptools
            ms-vscode.cpptools-extension-pack
          ]);
        package = vscode.fhsWithPackages (p:
          with p; [
            avrdude
            biome
            dfu-util
            nixd
            nodejs_22
            openocd
            platformio
            platformio-core
            python3
            typescript
          ]);
        userSettings = {
          # (not on nix) "update.mode" = "none";
          # (not on nix) "extensions.autoUpdate" = true;
          "terminal.external.linuxExec" = "foot";
          "terminal.integrated.allowMnemonics" = true;
          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.cursorStyleInactive" = "underline";
          "terminal.integrated.cursorStyle" = "underline";
          "terminal.integrated.gpuAcceleration" = "auto";
          "terminal.integrated.smoothScrolling" = true;
          # (stylix) "workbench.colorTheme" = "Catppuccin Mocha";
          # (stylix) "terminal.integrated.fontFamily" = "BerkeleyMono Nerd Font";
          # (stylix) "editor.fontFamily" = lib.mkDefault "Berkeley Mono";
          "editor.fontLigatures" = true;
          "editor.formatOnPaste" = true;
          "editor.formatOnType" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnSaveMode" = "modifications";
          "editor.tabSize" = 2;
          "editor.quickSuggestions" = {
            "other" = "on";
            "comments" = "off";
            "strings" = "on";
          };
          "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
          "window.customTitleBarVisibility" = "auto";
          "window.dialogStyle" = "custom";
          "window.titleBarStyle" = "custom";
          "files.autoSave" = "afterDelay";
          "eslint.useFlatConfig" = true;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmDelete" = false;
          "files.autoSaveDelay" = 5000;
          "prettier.printWidth" = 80;
          "prettier.tabWidth" = 2;
          "prettier.useTabs" = true;
          "prettier.semi" = true;
          "prettier.singleQuote" = true;
          "prettier.trailingComma" = "all";
          "prettier.embeddedLanguageFormatting" = "auto";
          "prettier.resolveGlobalModules" = true;
          "prettier.experimentalTernaries" = true;
          "prettier.endOfLine" = "lf";
          "prettier.bracketSpacing" = true;
          "prettier.bracketSameLine" = false;
          "prettier.jsxSingleQuote" = true;
          "prettier.quoteProps" = "as-needed";
          "prettier.requirePragma" = false;
          "prettier.htmlWhitespaceSensitivity" = "css";
          "prettier.insertPragma" = false;
          "prettier.arrowParens" = "always";
          "prettier.proseWrap" = "always";
          "prettier.requireConfig" = false; # If true; disallows falling back to this config
          "caddyfile.executable" = "/usr/bin/caddy";
          "projectManager.supportSymlinksOnBaseFolders" = true;
          "projectManager.showParentFolderInfoOnDuplicates" = true;
          "projectManager.tags" = ["Work" "Web" "Embedded" "Android"];
          "projectManager.removeCurrentProjectFromList" = false;
          "projectManager.git.baseFolders" = [
            "${config.home.homeDirectory}/dev"
          ];
          "git.openRepositoryInParentFolders" = "never";
          "black-formatter.importStrategy" = "fromEnvironment";
          "files.exclude" = {
            "**/node_modules" = true;
          };
          "telemetry.telemetryLevel" = "off";
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.black-formatter";
          };
          "python.analysis.typeCheckingMode" = "basic";
          "python.analysis.autoImportCompletions" = true;
          "files.associations" = {
            "*.css" = "tailwindcss";
          };
          "workbench.settings.openDefaultKeybindings" = true;
          "editor.hover.delay" = 500;
          "editor.colorDecoratorsActivatedOn" = "click";
          "javascript.preferences.quoteStyle" = "single";
          "typescript.preferences.quoteStyle" = "single";
          "markdown.preview.typographer" = true;
          "terminal.integrated.enableImages" = true;
          "html.completion.attributeDefaultValue" = "singlequotes";
          "tailwindCSS.emmetCompletions" = true;
          "makefile.configureOnOpen" = true;
          "cmake.showOptionsMovedNotification" = false;
          "cmake.pinnedCommands" = [
            "workbench.action.tasks.configureTaskRunner"
            "workbench.action.tasks.runTask"
          ];
          "C_Cpp.intelliSenseEngine" = "disabled";
          "C_Cpp.enhancedColorization" = "enabled";
          "[c]" = {
            "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          };
          "[cpp]" = {
            "editor.defaultFormatter" = "ms-vscode.cpptools";
          };
          "editor.stickyScroll.enabled" = false;
          "markdown.validate.fileLinks.markdownFragmentLinks" = "warning";
          "mdx.validate.validateMarkdownFileLinkFragments" = "warning";
          "markdown.occurrencesHighlight.enabled" = true;
          "markdown.validate.unusedLinkDefinitions.enabled" = "warning";
          "astro.content-intellisense" = true;
          "editor.linkedEditing" = true;
          "html.autoClosingTags" = true;
          "javascript.autoClosingTags" = true;
          "javascript.suggest.autoImports" = true;
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "editor.minimap.enabled" = false;
          "editor.unicodeHighlight.ambiguousCharacters" = false;
          "editor.wrappingStrategy" = "advanced";
          "gitlens.currentLine.enabled" = false;
          "gitlens.hovers.currentLine.over" = "line";
          "gitlens.codeLens.enabled" = false;
          "editor.defaultFormatter" = "biomejs.biome";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
        };
      };
    };
  };
}
