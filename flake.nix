{
  description = "signed distance functions to triangle mesh format";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; }; 
      sdf = pkgs.python312Packages.buildPythonPackage {
        pname = "sdf";
        version = "0.1";
        format = "setuptools";
        src = pkgs.fetchFromGitHub {
          owner = "fogleman";
          repo = "sdf";
          rev = "89a8868";
          sha256 = "sha256-+vrGBDrmPqSwLypqvaLYhwQKQSrjem3CqjlCAQHnx5o=";
        };
        doCheck = false;
        propagatedBuildInputs = with pkgs.python312Packages; [
          setuptools
          matplotlib
          meshio
          numpy
          scikit-image
          scipy
          pillow
        ];
      };
    in {
      packages.x86_64-linux.default = sdf;
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "sdf-develop";
        buildInputs = [ (pkgs.python3.withPackages(ps: [ sdf ])) ];
      };
    };
}
