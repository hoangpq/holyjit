{ nixpkgs ? <nixpkgs>
, rust_overlay ? ~/.config/nixpkgs/overlays/nixpkgs-mozilla/rust-overlay.nix
}:

let
  rustChannel = { rustToolchain = ./rust-toolchain; };
  hj_overlay = self: super: {
    hj_rust = (super.rustChannelOf rustChannel).rust.override {
      extensions = [ "rust-src" ];
    };
    holyjit = super.callPackage ./default.nix {
      rust = self.hj_rust;
    };
  };
  pkgs = import nixpkgs { overlays = [ (import rust_overlay) hj_overlay ];  };
  jobs = {
    inherit (pkgs) holyjit;
  };
in
  jobs
