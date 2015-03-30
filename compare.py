import h5py
import numpy as np
import csv
import click
import matplotlib.pyplot as plt

exposures = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10]
pictures = [1000, 1000, 1000, 500, 500, 500, 200, 200, 200, 100]


@click.command()
@click.argument("src", nargs=1, type=click.Path(exists=True))
@click.argument("dst", nargs=1, type=click.File("w"))
@click.argument("chi_dst", nargs=1, type=click.File("w"))
def print_means(src, dst, chi_dst):
    writer = csv.writer(dst)
    chi_writer = csv.writer(chi_dst)
    writer.writerow(["exposure", "counts"])
    chis = []
    with h5py.File(src, "r") as input_file:
        group = input_file["raw_images"]
        datasets = np.vstack([dataset for dataset in group.values()])
        i = 0
        for exposure, n in zip(exposures, pictures):
            images = datasets[i: i + n, ...]
            mean = np.mean(images, axis=0)
            var = np.var(images, axis=0)
            chi = mean / var
            chis.extend(chi)
            i += n
            writer.writerow([exposure, np.mean(mean)])
    chis = np.array(chis)
    chis = chis[np.isfinite(chis)]
    chi_writer.writerow(["chi"])
    for chi in chis:
        chi_writer.writerow([chi])


if __name__ == '__main__':
    print_means()
