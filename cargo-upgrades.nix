{
  rustPlatform,
  fetchCrate,
  lib,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-upgrades";
  version = "2.1.2";

  src = fetchCrate {
    inherit version;
    crateName = pname;
    hash = "sha256-P8vHhjmNPYGq3SchJpXQ4gmJ0ZrcNgbNf7KNySJYPeQ=";
  };

  cargoHash = "sha256-YYVDlIy8hJeqBfsGROAY5fVXTpenigRhI3tk2vv66K4=";
  checkFlags = [
    # I think this tests checks cargo-upgrades for outdated dependencies, which ironically
    # fails because there is some
    "--skip=test_self"
  ];

  meta = {
    description = "Shows which dependencies in `Cargo.toml` can be upgraded to newer versions";
    mainProgram = "cargo-upgrades";
    homepage = "https://lib.rs/crates/cargo-upgrades";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
}
