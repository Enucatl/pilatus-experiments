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
    absorption = hdf5_group["dpc_reconstruction"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3], 0]
    differential_phase = hdf5_group["dpc_reconstruction"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3], 1]
    dark_field = hdf5_group["dpc_reconstruction"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3], 2]
    visibility = hdf5_group["visibility"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3]]
    phase_stepping_curves = hdf5_group["phase_stepping_curves"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3], ...]
    flat_phase_stepping_curves = hdf5_group["flat_phase_stepping_curves"][0, crop[0]:crop[1],
                                                  crop[2]:crop[3], ...]
    writer.writerow(["pixel", "absorption", "differential_phase",
                     "dark_field", "visibility", "phase_stepping_curve",
                     "flat_phase_stepping_curve"])
    phase_steps = phase_stepping_curves.shape[-1]
    for i, (a, dpc, df, v, psc, fpsc) in enumerate(zip(
        absorption.flat,
        differential_phase.flat,
        dark_field.flat,
        visibility.flat,
        np.reshape(phase_stepping_curves, (-1, phase_steps)),
        np.reshape(flat_phase_stepping_curves, (-1, phase_steps))
        )):
        writer.writerow(
            [i + 1, a, dpc, df, v, list(psc), list(fpsc.astype(np.int32))])
    hdf5_file.close()
