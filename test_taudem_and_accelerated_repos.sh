#!/bin/bash -e

# navigate to testing script directory
cd $taudem_tests_dirs/Input

# set original path
ORIG_PATH=$PATH

# add path to taudem dev
PATH=$taudem_dev_bin_dir:$PATH

# run tests on dev taudem
echo "##### TAUDEM DEV TESTING ######"
sleep 4
bats taudem-tests.sh

# add path to taudem acclerated
PATH=$taudem_acc_bin_dir:$PATH

# run tests on acc taudem
echo "##### TAUDEM ACC TESTING ######"
sleep 4
bats taudem-tests.sh

