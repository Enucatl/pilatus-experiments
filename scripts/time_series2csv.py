"""Read the time series and output a csv"""

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

if __name__ == '__main__':
    args = parser.parse_args()
    file_name = args.file[0]
    hdf5_file = h5py.File(file_name, "r")
    hdf5_group = hdf5_file["raw_images"]
    writer = csv.writer(sys.stdout)
    exposures = [0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1]
    n_files = [1000, 1000, 1000, 500, 500, 500, 200, 200, 200, 100]
    writer.writerow(["exposure", "signal", "noise", "snr"])
    datasets = np.array([dataset for dataset in hdf5_group.values()])
    print(datasets.shape)
    i = 0
    for exposure, n in zip(exposures, n_files):
        dataset = datasets[i:(i + n), 0, ...]
        print(dataset.shape)
        i += n
        signal = np.mean(dataset, axis=0)
        noise = np.std(dataset, axis=0)
        snr = signal / noise
        writer.writerow([exposure, signal, noise, snr])
    hdf5_file.close()
