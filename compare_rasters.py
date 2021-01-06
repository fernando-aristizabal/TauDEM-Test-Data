#!/usr/bin/env python3

import rasterio
import sys
from numpy import isclose

ref_file=sys.argv[1]
tst_file=sys.argv[2]

ref_obj=rasterio.open(ref_file)
tst_obj=rasterio.open(tst_file)

assert isclose(ref_obj.read(1),tst_obj.read(1),atol=1e-4).all(), "{} and {} raster values are NOT identical".format(ref_file,tst_file)

print("{} and {} raster values ARE identical".format(ref_file,tst_file))

