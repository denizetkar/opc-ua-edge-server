//@ts-check
"use strict";
const {
    OPCUAServer,
    Variant,
    DataType,
    nodesets,
    StatusCodes,
    VariantArrayType,
    ServerEngine
} = require("node-opcua");
const os = require("os");
const path = require("path");
const {
    execSync
} = require("child_process");


/**
 * @param server {OPCUAServer} server
 */
function constructAddressSpace(server) {
    const addressSpace = server.engine.addressSpace;
    const namespace = addressSpace.getOwnNamespace();
    namespace.addressSpace.rootFolder.objects["edgeTestDevice1"].location.latitudeLongitude.bindVariable({
        get: () => {
            let out = JSON.parse(execSync(`python3 ${path.join(__dirname, "data", "telemetry.py")}`, {
                cwd: __dirname,
                windowsHide: true,
                encoding: "utf8"
            }));
            return new Variant({
                dataType: DataType.Double,
                arrayType: VariantArrayType.Array,
                value: new Float64Array([out.location.latitude, out.location.longitude])
            });
        }
    });
}

(async () => {

    try {
        // Let create an instance of OPCUAServer
        const server = new OPCUAServer({
            port: 4840, // the port of the listening socket of the server

            nodeset_filename: [
                nodesets.standard,
                nodesets.di,
                path.join("nodesets", "custom.xml")
            ],
            buildInfo: {
                productName: "Sample NodeOPCUA Server",
                buildNumber: "1234",
                buildDate: new Date(2021, 7, 8)
            }
        });

        await server.initialize();

        constructAddressSpace(server);

        // we can now start the server
        await server.start();

        console.log("Server is now listening ... ( press CTRL+C to stop) ");
        server.endpoints[0].endpointDescriptions().forEach(function (endpoint) {
            console.log(endpoint.endpointUrl, endpoint.securityMode.toString(), endpoint.securityPolicyUri.toString());
        });


        process.on("SIGINT", async () => {
            await server.shutdown();
            console.log("terminated");

        });
    } catch (err) {
        console.log(err);
        process.exit(-1);
    }
})();