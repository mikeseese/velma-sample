import { provider } from "ganache-core";
import { CompilerInput, CompilerOutput, compileStandardWrapper } from "solc";
import { join as joinPath } from "path";
import { readFileSync } from "fs";

const Web3 = require("web3");
const async = require("async");

describe("SdbSampleTest", () => {
    const sourceRoot = joinPath(__dirname, "../../src/contracts/"); // take into consideration this is in the output folder
    const contracts: {[name: string]: { path: string, name: string, interface: any, instance: any }} = {
        "Sample": {
            path: joinPath(sourceRoot, "sample.sol"),
            name: "Sample",
            interface: null,
            instance: null
        },
        "Test": {
            path: joinPath(sourceRoot, "test.sol"),
            name: "Test",
            interface: null,
            instance: null
        }
    };
    const sdbPort = process.env.SDB_PORT ? parseInt(process.env.SDB_PORT) : null;
    let web3;
    let ganacheProvider;
    let compilerOutput: CompilerOutput;
    let accounts;
    let addressMapping = {};

    before("initialize/connect to testrpc/ganache-core", (callback) => {
        let ganacheOptions: any = {
            sdb: true
        };
        if (sdbPort !== null) {
            ganacheOptions.sdbPort = sdbPort;
        }
        ganacheProvider = provider(ganacheOptions, callback);
    });

    before("set web3 provider", (callback) => {
        web3 = new Web3(ganacheProvider);
        callback();
    });

    before("get accounts", function() {
      return web3.eth.getAccounts().then(accs => {
        accounts = accs;
      });
    });

    before("compile contract", (callback) => {
        let inputJson: CompilerInput = {
            language: "Solidity",
            settings: {
                optimizer: {
                    enabled: false
                },
                outputSelection: {
                    "*": {
                        "*": [
                            "abi",
                            "evm.bytecode.object",
                            "evm.deployedBytecode.object",
                            "evm.deployedBytecode.sourceMap",
                            "evm.methodIdentifiers"
                        ],
                        "": [ "legacyAST" ]
                    }
                }
            },
            sources: {}
        };
        for (const contract in contracts) {
            const filePath = contracts[contract].path.replace(sourceRoot, "").replace(/\\/g, "/").replace(/^\//, "");
            inputJson.sources[filePath] = { content : readFileSync(contracts[contract].path, "utf8") };
        }

        const compilerOutputJson = compileStandardWrapper(JSON.stringify(inputJson));
        compilerOutput = JSON.parse(compilerOutputJson);
        callback();
    });

    before("upload contracts", () => {
        for (const contract in contracts) {
            const filePath = contracts[contract].path.replace(sourceRoot, "").replace(/\\/g, "/").replace(/^\//, "");
            contracts[contract].interface = new web3.eth.Contract(compilerOutput.contracts[filePath][contracts[contract].name].abi);
            contracts[contract].interface._code = "0x" + compilerOutput.contracts[filePath][contracts[contract].name].evm.bytecode.object;

            return contracts[contract].interface.deploy({ data: contracts[contract].interface._code }).send({from: accounts[0], gas: 3141592}).then(instance => {
                contracts[contract].instance = instance;

                addressMapping[contracts[contract].name] = instance._address;

                // TODO: ugly workaround - not sure why this is necessary.
                if (!contracts[contract].instance._requestManager.provider) {
                    contracts[contract].instance._requestManager.setProvider(web3.eth._provider);
                }
            });
        }
    });

    before("link compiler output", (callback) => {
        const sdbHook = ganacheProvider.manager.state.sdbHook;
        if (sdbHook) {
            sdbHook.linkCompilerOutput(sourceRoot, compilerOutput, callback);
        }
        else {
            callback("sdbhook isn't defined. are you sure testrpc/ganache-core was initialized properly?");
        }
    });

    before("link contract addresses", (callback) => {
        const sdbHook = ganacheProvider.manager.state.sdbHook;
        if (sdbHook) {
            const keys = Object.keys(addressMapping);
            async.each(keys, (contractName, callback) => {
                sdbHook.linkContractAddress(contractName, addressMapping[contractName], callback);
            }, (err) => {
                if (err) {
                    callback(err);
                }
                else {
                    callback();
                }
            });
        }
        else {
            callback("sdbhook isn't defined. are you sure testrpc/ganache-core was initialized properly?");
        }
    });

    it("#sdbTest", async () => {
        // We want to trace the transaction that sets the value to 26
        return contracts["Sample"].instance.methods.test6().call({from: accounts[0], gas: 3411592});
    });
})