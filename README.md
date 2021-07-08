# OPC UA Edge Server
A dockerized OPC UA server that serves telemetry data to the clients. The information structure is defined in `nodesets/custom.xml` which is in compliance with the official OPC UA information model XML schema, as described [HERE](https://reference.opcfoundation.org/v104/Core/docs/Part6/F.1/).

## Dependencies
* To build and push the container image:
  * Latest Docker (>= 20.10.6), see [HERE](https://docs.docker.com/get-docker/) for details.
  * Latest Powershell (>=7.1.3), see [HERE](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1) for details.

## Usage
* To build and push the container image:
  * Open a **powershell** terminal in the project root folder,
  * Run `docker login <image-repo-url>` to login to the image repository,
  * Run `build-and-push-image.ps1` with its command line arguments.
