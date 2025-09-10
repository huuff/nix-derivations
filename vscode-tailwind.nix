{ pkgs, lib, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-tailwindcss";
    publisher = "bradlc";
    version = "0.14.11";
    hash = "sha256-agntfMsLAYASviH7Wuw/W8JwfHRi6qAfuMkqmFWT0bg=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/bradlc.vscode-tailwindcss/changelog";
    description = "Tailwind CSS tooling for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss";
    homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
    license = lib.licenses.mit;
  };
}
