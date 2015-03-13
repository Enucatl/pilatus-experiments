"""Read the postprocessing folder in the hdf5 and output a csv"""

import argparse
import h5py
import csv
import sys
import numpy as np

parser = argparse.ArgumentParser(
    __doc__,
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument(
    "file",
    nargs=1,
    help="hdf5 file"
)
parser.add_argument(
    "--crop",
    nargs=4,
    default=[0, -1, 0, -1],
    type=int,
    help="area inside the plot (min_x, max_x, min_y, max_y)")


if __name__ == '__main__':
    args = parser.parse_args()
    file_name = args.file[0]
    hdf5_file = h5py.File(file_name, "r")
    hdf5_group = hdf5_file["postprocessing"]
    writer = csv.writer(sys.stdout)
    crop = args.crop
    visibility = np.mean(hdf5_group["visibility"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3]], axis=1)
    writer.writerow(["pixel", "visibility"])
    for i, v in enumerate(visibility):
        writer.writerow([i, v])
    hdf5_file.close()
