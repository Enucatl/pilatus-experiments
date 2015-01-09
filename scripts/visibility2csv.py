"""Read the visibility map from the hdf5 and output a csv"""

import argparse
import h5py
import csv
import sys

parser = argparse.ArgumentParser(
    __doc__,
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument(
    "file",
    nargs=1,
    help="hdf5 file with the visibility map"
)
parser.add_argument(
    "--dataset",
    nargs="?",
    default="postprocessing/visibility_map",
    help="path of the dataset with the visibility inside the file"
)

if __name__ == '__main__':
    args = parser.parse_args()
    file_name = args.file[0]
    dataset_path = args.dataset
    hdf5_file = h5py.File(file_name, "r")
    dataset = hdf5_file[dataset_path]
    writer = csv.writer(sys.stdout)
    writer.writerow(["pixel", "visibility"])
    for i, visibility in enumerate(dataset[0, ..., 0]):
        writer.writerow([i + 1, visibility])
    hdf5_file.close()
