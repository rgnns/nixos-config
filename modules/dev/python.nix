{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.dev.python;

    python2Packages = pypkgs: with pypkgs; [
      setuptools
    ];
    python3Packages = pypkgs: with pypkgs; [
      black
      setuptools
    ];
    myPython2 = pkgs.python27.withPackages python2Packages;
    myPython3 = pkgs.python39.withPackages python3Packages;
in {
  options.modules.dev.python = {
    enable = mkEnableOption "Python";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      myPython2
      myPython3
    ];

    env.IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
    env.PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
    env.PYLINTHOME = "$XDG_DATA_HOME/pylint";
    env.PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
    env.PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
    env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
  };
}
