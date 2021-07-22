# OPC UA Edge Server
A dockerized OPC UA server that serves telemetry data to the clients. The information structure is defined in `nodesets/custom.xml` which is in compliance with the official OPC UA information model XML schema, as described [HERE](https://reference.opcfoundation.org/v104/Core/docs/Part6/F.1/).

## Dependencies
* To build and push the container image:
  * Latest **Docker** (>= 20.10.6), see [HERE](https://docs.docker.com/get-docker/) for details.
  * Latest **Powershell** (>=7.1.3), see [HERE](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1) for details.
* To run the container image:
  * Latest **Docker** (>= 20.10.6), see [HERE](https://docs.docker.com/get-docker/) for details.
  * Latest **docker-compose**, see [HERE](https://github.com/docker/compose#using-pip) for details.

## Usage
* To build and push the container image:
  * Open a **powershell** terminal in the project root folder,
  * Run `docker login <image-repo-url>` to login to the image repository,
  * Run `build-and-push-image.ps1` with its command line arguments. For example:
    * `./build-and-push-image.ps1 -DockerId <image-repo-url>`
* To run the container image:
  * Modify `TATUM_IMAGE_REGISTRY_HOST` variable in `.env` file to have the value of `<image-repo-url>`,
  * Run the following command in some terminal `docker-compose up -d`,
  * You may also need to run `sudo ./scripts/iiot-opcua-setup-trust.sh` script in order to establish a trust between the OPC UA server and the Azure IoT Edge runtime. Or you could modify the script to fit your particular use case.
* To stop the container:
  * `docker-compose down`
