let
  pkgs = import <nixpkgs> {};
  # Replace with whichever packages you need
  myPython = pkgs.python312.withPackages (ps: with ps; [
    pandas
    numpy
    scikit-learn
    matplotlib
    seaborn
  ]);
in
pkgs.mkShell {
  buildInputs = [
    myPython
    pkgs.git
    pkgs.which
  ];

  shellHook = ''
    export PYTHONNOUSERSITE="true"
    export PYTHONPATH=""
}
