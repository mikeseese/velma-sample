# <img src="https://user-images.githubusercontent.com/549323/41639879-a6eeb290-742d-11e8-8ece-bb1c292b407a.png" alt="" width="100" height="auto" valign="middle"> Velma Solidity Debugger - Sample Project
This repository contains a sample project that uses the [Velma Solidity Debugger](https://github.com/seeseplusplus/velma) and associated [VS Code Extension](https://github.com/seeseplusplus/vscode-velma-debug).

For the scope of the [Augur bounty](https://github.com/AugurProject/augur-bounties#-bounty-2-portable-solidity-debugger), the only way you can currently use the debugger is through Ganache (formally TestRPC). The recommended method is by setting up a Mocha test which will compile the contracts, upload them to the Ganache, link the debug symbols (aka compilation output and contract addresses) to Velma, and execute transactions.

I **highly recommend** you familiarize yourself with the test application found within this repository before integrating your own project.

## :warning: Velma is alpha software! We're still working out a lot of kinks/bugs so please bare with us :warning:

## Get Status Updates About Releases!
Follow me on Twitter at https://twitter.com/seeseplusplus to get updates about new releases/etc about Velma

## Usage
1. Make sure you got the [prerequisites for Velma](https://github.com/seeseplusplus/vscode-velma-debug#prerequisites) installed
1. Make sure you have the [Velma VS Code Extension](https://github.com/seeseplusplus/vscode-velma-debug) installed
1. Clone this repository
1. Navigate to this repository's root folder
1. Run `npm install`
1. Run `npm run build`
1. Place breakpoint at `src/contracts/sample.sol` lines `60` and `107` (inside the constructor and the currently executed `test5` function)
1. Review the [current limitations](https://github.com/seeseplusplus/vscode-velma-debug/#current-limitations-of-both-velma-and-velma-vs-code-extension) of the debugger/extension
1. Run the `Velma & Test` launch configuration
1. ???
1. Profit.
1. Once you've seen around `test5()`, I suggest taking a look at `test6()` and `test11()`:
    1. Change line `142` in `test/test.ts` to `return sampleInstance.methods.test6().call({from: accounts[0], gas: 3411592});`
    1. Run `npm run build`
    1. You may need to stop the current running VS Code debug instance (this is due to the Velma VS Code task to just running indefinitely listening for things to break) despite the prior test had finished
    1. Place breakpoints where you want in `src/contracts/sample.sol` rerun the test

## Launch Configuration
Since this extension doesn't handle the compilation and linking of your contracts for you, you must treat its launch configuration as an `attach` configuration (but the type is actually `launch`). You can see the launch configuration setup for this [test application](https://github.com/seeseplusplus/vscode-velma-debug/blob/master/test/test.ts) can be found in [.vscode/launch.json](https://github.com/seeseplusplus/vscode-velma-debug/blob/master/.vscode/launch.json#L24-30). Also in that file you can see a compound configuration which runs both my `Debug Solidity` and `Tests` configurations; this gives me the ability to just press `F5`/run to get started quickly.

## Contracts
Not much to say here other than your contracts should share some root directory as the extension expects a root and relative paths to the contract files.

## Mocha Test
I've tried to structure the [sample Mocha Test](https://github.com/seeseplusplus/vscode-velma-debug/blob/master/test/test.ts) to the core steps to working with Velma. Some notes to consider:
- SDB expects that you use the [standard compiler input/output JSON structures](http://solidity.readthedocs.io/en/develop/using-the-compiler.html#compiler-input-and-output-json-description).
- The [ouputSelection](https://github.com/seeseplusplus/vscode-velma-debug/blob/master/test/test.ts#L44-54) options seen for the `CompilerInput` are the **minimum required fields** for Velma to function properly.
- The keys to `CompilerInput.sources` are designed to be relative (relative to the `sourceRoot`) paths to the files.
- You'll need an `addressMapping` which is an object which keys are the contract names (not file paths/etc) and values are the installed addresses as strings. It doesn't matter if the addresses have preceeding `0x` or have mixed-case letters (fun fact: the mixed-casing is used for an [optional checksum validation](https://github.com/ethereum/EIPs/issues/55#issuecomment-187159063)).
- You **must** link the debug symbols for the debugger to be able to do anything. The order of linking **must** be the compiler output, and then each contract's addresses. I highly suggest that you compile your contracts once and have one large `CompilerOutput` for all contracts. It might work to do compartmental builds, but it's not supported.
