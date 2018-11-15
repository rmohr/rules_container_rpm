import subprocess
import tempfile
import shutil
import tarfile
import argparse
from os import path


parser = argparse.ArgumentParser(
    description='Install RPMs and update the RPM database inside the docker image')

parser.add_argument('--uncompressed_layer', action='append', required=True,
                    help='The output file, mandatory')

parser.add_argument('--rpm', action='append', required=True,
                    help=('rpms to add to the database'))

parser.add_argument('--output', action='store', required=True,
                    help=('target archive'))

def main():
    args = parser.parse_args()
    dirpath = tempfile.mkdtemp()
    rpmdb = path.join(dirpath, "var/lib/rpm")
    try:
        # Uncompress the latest database state into a temporary directory
        for tar in args.uncompressed_layer:
            with tarfile.open(tar, "r") as archive:
                for member in archive.getmembers():
                    if member.name.startswith(("/var/lib/rpm", "./var/lib/rpm")):
                        archive.extract(member, dirpath)

        # Add the rpm database if it is not there
        subprocess.check_call(["rpm", "--dbpath", rpmdb, "--initdb"])

        # Register the RPMs in the database
        for rpm in args.rpm:
            subprocess.check_call(["rpm", "--nosignature", "--dbpath", rpmdb, "-i", "-v", "--ignoresize", "--nodeps", "--noscripts" ,"--notriggers" ,"--excludepath", "/",  rpm])

        # Extract the rpms into the shared folder
        for rpm in args.rpm:
            p1 = subprocess.Popen(["rpm2cpio", rpm], stdout=subprocess.PIPE)
            p2 = subprocess.Popen(["cpio", "-i", "-d", "-m", "-v", "-D", dirpath], stdin=p1.stdout, stdout=subprocess.PIPE)
            p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
            p2.communicate()

        with tarfile.open(args.output, "a") as tar:
            tar.add(dirpath, arcname="/")
    finally:
        shutil.rmtree(dirpath)

if __name__ == '__main__':
    main()