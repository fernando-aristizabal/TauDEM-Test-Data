# Integrating Acclerated Flow Direction Algorithms into TauDEM #

This branch seeks to test the accelerated flow direction algorithms within the [CyberGIS repository] (https://github.com/cybergis/cybergis-toolkit) for the purpose of integrating them into the [TauDEM repository](https://github.com/dtarb/TauDEM). It uses Docker as a means of easily reproducing the testing across host operating systems. Below are the steps to reproduce the tests. Both the original TauDEM repository (TauDEM dev) and the acclerated TauDEM repository (TauDEM acc) are ran through the testing suite.

## Steps to Reproduce

1. Go to the [Docker website](https://docs.docker.com/get-docker/) to install Docker on your host machine.
2. Clone this fork of the TauDEM testing repository: `git clone -b taudem_compare https://github.com/fernando-aristizabal/TauDEM-Test-Data.git <source_code_dir>`
3. Build the testing Docker image (may need to run as sudo): `docker build -t taudem_compare <source_code_dir>`
4. Run the tests for non-zero exit codes on the TauDEM dev and TauDEM acc repos (may need to run as sudo): `docker run --rm -it taudem_compare /bin/bash test_taudem_and_accelerated_repos.sh`
5. Run the tests to compare outputs of d8flowdir and dinfflowdir within both TauDEM dev and TauDEM acc repos to reference results (may need to run as sudo): `docker run --rm -it taudem_compare /bin/bash compare_outputs.sh`
