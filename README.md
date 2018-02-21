# SDB Sample Project
This repository contains a sample project that uses the [SDB (Solidity Debugger)](https://gitlab.com/seeseplusplus/solidity-debugger) and associated [VS Code Extension](https://gitlab.com/seeseplusplus/vscode-sdb-debug).

For the scope of the [Augur bounty](https://github.com/AugurProject/augur-bounties#-bounty-2-portable-solidity-debugger), the only way you can currently use the debugger is through Ganache (formally TestRPC). The recommended method is by setting up a Mocha test which will compile the contracts, upload them to the Ganache, link the debug symbols (aka compilation output and contract addresses) to SDB, and execute transactions.

I **highly recommend** you familiarize yourself with the test application found within this repository before integrating your own project.

## Usage
1. Make sure you have the [SDB VS Code Extension](https://gitlab.com/seeseplusplus/vscode-sdb-debug) installed
1. Clone this repository
1. Navigate to this repository's root folder
1. Run `npm install`
1. Run `npm run build`
1. Place breakpoint at `src/contracts/sample.ts` line 42
1. Review the [current limitations](https://gitlab.com/seeseplusplus/vscode-sdb-debug/#current-limitations-of-both-sdb-and-sdb-vs-code-extension) of the debugger/extension
1. Run the `SDB & Test` launch configuration
1. ???
1. Profit.

## Launch Configuration
Since this extension doesn't handle the compilation and linking of your contracts for you, you must treat its launch configuration as an `attach` configuration (but the type is actually `launch`). You can see the launch configuration setup for this [test application](https://gitlab.com/seeseplusplus/vscode-sdb-debug/blob/master/test/test.ts) can be found in [.vscode/launch.json](https://gitlab.com/seeseplusplus/vscode-sdb-debug/blob/master/.vscode/launch.json#L24-30). Also in that file you can see a compound configuration which runs both my `Debug Solidity` and `Tests` configurations; this gives me the ability to just press `F5`/run to get started quickly.

## Contracts
Not much to say here other than your contracts should share some root directory as the extension expects a root and relative paths to the contract files.

## Mocha Test
I've tried to structure the [sample Mocha Test](https://gitlab.com/seeseplusplus/vscode-sdb-debug/blob/master/test/test.ts) to the core steps to working with SDB. Some notes to consider:
- SDB expects that you use the [standard compiler input/output JSON structures](http://solidity.readthedocs.io/en/develop/using-the-compiler.html#compiler-input-and-output-json-description).
- The [ouputSelection](https://gitlab.com/seeseplusplus/vscode-sdb-debug/blob/master/test/test.ts#L44-54) options seen for the `CompilerInput` are the **minimum required fields** for SDB to function properly.
- The keys to `CompilerInput.sources` are designed to be relative (relative to the `sourceRoot`) paths to the files.
- You'll need an `addressMapping` which is an object which keys are the contract names (not file paths/etc) and values are the installed addresses as strings. It doesn't matter if the addresses have preceeding `0x` or have mixed-case letters (fun fact: the mixed-casing is used for an [optional checksum validation](https://github.com/ethereum/EIPs/issues/55#issuecomment-187159063)).
- You **must** link the debug symbols for the debugger to be able to do anything. The order of linking **must** be the compiler output, and then each contract's addresses. I highly suggest that you compile your contracts once and have one large `CompilerOutput` for all contracts. It might work to do compartmental builds, but it's not supported.
