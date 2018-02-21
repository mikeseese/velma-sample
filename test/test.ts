import { provider } from "ganache-core";
import { CompilerInput, CompilerOutput, compileStandardWrapper } from "solc";
import { join as joinPath } from "path";
import { readFileSync } from "fs";

const Web3 = require("web3");

describe("SdbSampleTest", () => {
    const sourceRoot = joinPath(__dirname, "../../src/contracts/"); // take into consideration this is in the output folder
    const contractPath = joinPath(sourceRoot, "sample.sol");
    let web3;
    let ganacheProvider;
    let compilerOutput: CompilerOutput;
    let contractName;
    let Sample;
    let sampleInstance;
    let accounts;
    let addressMapping = {};

    before("initialize/connect to testrpc/ganache-core", (callback) => {
        ganacheProvider = provider({
            sdb: true
        }, callback);
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
        const filePath = contractPath.replace(sourceRoot, "").replace(/\\/g, "/").replace(/^\//, "");
        inputJson.sources[filePath] = { content : readFileSync(contractPath, "utf8") };

        const compilerOutputJson = compileStandardWrapper(JSON.stringify(inputJson));
        compilerOutput = JSON.parse(compilerOutputJson);
        contractName = Object.keys(compilerOutput.contracts[filePath])[0];
        callback();
    });

    before("upload contract", () => {
        const filePath = contractPath.replace(sourceRoot, "").replace(/\\/g, "/").replace(/^\//, "");
        Sample = new web3.eth.Contract(compilerOutput.contracts[filePath][contractName].abi);
        Sample._code = "0x" + compilerOutput.contracts[filePath][contractName].evm.bytecode.object;

        return Sample.deploy({ data: Sample._code }).send({from: accounts[0], gas: 3141592}).then(instance => {
            sampleInstance = instance;

            addressMapping[contractName] = instance._address;

            // TODO: ugly workaround - not sure why this is necessary.
            if (!sampleInstance._requestManager.provider) {
                sampleInstance._requestManager.setProvider(web3.eth._provider);
            }
        });
    });

    before("link debug symbols", (callback) => {
        const sdbHook = ganacheProvider.manager.state.sdbHook;
        if (sdbHook) {
            sdbHook.linkCompilerOutput(sourceRoot, compilerOutput);
            const keys = Object.keys(addressMapping);
            for (let i = 0; i < keys.length; i++) {
                const contractName = keys[i];
                sdbHook.linkContractAddress(contractName, addressMapping[keys[i]]);
            }
        }
        callback();
    });

    it("#sdbTest", async () => {
        // We want to trace the transaction that sets the value to 26
        return sampleInstance.methods.test6().call({from: accounts[0], gas: 3411592});
    });
})