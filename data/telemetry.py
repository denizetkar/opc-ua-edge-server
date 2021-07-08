import argparse
import json
import os
import sys

import serial
from ublox_gps import UbloxGps


def main(args: argparse.Namespace):
    # Can also use SPI here - import spidev
    # I2C is not supported

    port = serial.Serial(args.gps_port, baudrate=38400, timeout=1)
    gps = UbloxGps(port)

    try:
        coords = gps.geo_coords()
        sys.stdout.write(
            json.dumps(
                {
                    "location": {
                        "latitude": coords.lat,
                        "longitude": coords.lon,
                    }
                }
            )
            + os.linesep
        )
    except (ValueError, IOError) as err:
        sys.stderr.write("{}{}".format(err, os.linesep))
    finally:
        port.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--gps-port", type=str, default="/dev/ttyACM0", help="Path to the serial port to which a ublox GPS board is connected."
    )
    main(parser.parse_args())
