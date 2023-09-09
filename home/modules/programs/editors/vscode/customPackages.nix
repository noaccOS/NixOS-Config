{ buildVscodeMarketplaceExtension
, licenses
}:
let
  cut-all-right = buildVscodeMarketplaceExtension
    {
      mktplcRef = {
        publisher = "cou929";
        name = "vscode-cut-all-right";
        version = "0.0.1";
        sha256 = "sha256-QBYOSklu1scLjMSQ2ZWFwr2+UoJMAZIxjeFdo5d67Lg=";
      };
      meta = {
        description = "Cut rest of line. Like `Delete All Right` but cut it and store to clipboard.";
        downloadPage = "https://marketplace.visualstudio.com/items?itemName=cou929.vscode-cut-all-right";
        homepage = "https://github.com/cou929/vscode-cut-all-right";
        license = licenses.unlicense;
      };
    } // { recurseForDerivations = true; };

  markdown-table = buildVscodeMarketplaceExtension
    {
      mktplcRef = {
        publisher = "TakumiI";
        name = "markdowntable";
        version = "0.10.4";
        sha256 = "sha256-rynWwTPsDQirKu1uhs7rHIglTay/4S1MA0M17Mdjtxw=";
      };
      recurseForDerivations = true;
      meta = {
        description = "A vscode extension to add markdown table features.";
        downloadPage = "https://marketplace.visualstudio.com/items?itemName=TakumiI.markdowntable";
        homepage = "https://github.com/takumisoft68/vscode-markdown-table";
        license = licenses.asl20;
      };
    } // { recurseForDerivations = true; };

  org-mode = buildVscodeMarketplaceExtension
    {
      mktplcRef = {
        publisher = "vscode-org-mode";
        name = "org-mode";
        version = "1.0.0";
        sha256 = "sha256-o9CIjMlYQQVRdtTlOp9BAVjqrfFIhhdvzlyhlcOv5rY=";
      };
      recurseForDerivations = true;
      meta = {
        description = "Emacs Org Mode for Visual Studio Code";
        downloadPage = "https://marketplace.visualstudio.com/items?itemName=vscode-org-mode.org-mode";
        homepage = "https://github.com/vscode-org-mode/vscode-org-mode";
        license = licenses.gpl3;
      };
    } // { recurseForDerivations = true; };
in
[
  cut-all-right
  markdown-table
  org-mode
]
