{
  description = "SWIG - Simplified Wrapper and Interface Generator (fork)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Take the version from AC_INIT in configure.ac so it never goes stale.
      version = builtins.head (builtins.match ".*AC_INIT\\(\\[swig],\\[([^]]+)].*"
        (builtins.readFile ./configure.ac));
    in
    {
      packages = forAllSystems (pkgs: {
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.swig;

        swig = pkgs.stdenv.mkDerivation {
          pname = "swig";
          inherit version;
          src = self;

          nativeBuildInputs = with pkgs; [ autoconf automake libtool bison pkg-config ];
          buildInputs = [ pkgs.pcre2 ];

          # A git checkout has no configure script yet.
          preConfigure = "./autogen.sh";

          enableParallelBuilding = true;

          # The test suite needs target language toolchains; run it from the dev shell.
          doCheck = false;

          meta = with pkgs.lib; {
            description = "Interface compiler that connects C/C++ code to higher-level languages";
            homepage = "https://www.swig.org";
            license = licenses.gpl3Plus;
            mainProgram = "swig";
            platforms = platforms.unix;
          };
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [ self.packages.${pkgs.stdenv.hostPlatform.system}.swig ];
          packages = with pkgs; [
            clang-tools   # clang-format for 'make format-check'
            python3       # Python test suite
          ];
        };
      });
    };
}
