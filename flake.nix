{
  description = "signed distance functions to triangle mesh format";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    sdf-src = { url = "https://github.com/fogleman/sdf"; flake = false; };
  };
  outputs = { self, nixpkgs, sdf-src }: 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; }; 
      sdf = pkgs.python312Packages.buildPythonPackage {
        pname = "sdf";
        version = "0.1";
        src = sdf-src;
        doCheck = true;
        buildInputs = with pkgs.python312Packages; [
          matplotlib
          meshio
          numpy
          scikit-image
          scipy
          pillow
        ];
      };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "sdf-develop";
        buildInputs = [ pkgs.python3.withPackages([ sdf ]) ];
      };
    };
}
