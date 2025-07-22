 VaultLock

 Bitcoinbacked timelocked savings with stacking rewards on Stacks blockchain

License: MIT(https://img.shields.io/badge/LicenseMITyellow.svg)(https://opensource.org/licenses/MIT)
Stacks(https://img.shields.io/badge/StacksBlockchainorange)(https://stacks.co)
Clarity(https://img.shields.io/badge/LanguageClarityblue)(https://claritylang.org)

VaultLock is a secure, decentralized savings protocol built on the Stacks blockchain that enables users to lock STX tokens for specified time periods while earning stacking rewards. By combining timelocked savings with Bitcoin's security through Stacks' unique ProofofTransfer consensus, VaultLock offers a disciplined approach to cryptocurrency savings with builtin rewards.

 🚀 Features

 TimeLocked Savings: Lock STX tokens for custom durations to prevent impulsive spending
 Stacking Integration: Earn Bitcoin rewards while your STX tokens are locked
 Multiple Vaults: Create unlimited savings vaults with different lock periods
 Emergency Withdrawal: Access funds early with a 10% penalty fee
 Transparent Tracking: Monitor total locked amounts and individual vault details
 NonCustodial: You retain full ownership of your funds through smart contract security

 📋 Table of Contents

 Installation(installation)
 Usage(usage)
 Contract Functions(contractfunctions)
 Examples(examples)
 Security Features(securityfeatures)
 Testing(testing)
 Deployment(deployment)
 Contributing(contributing)
 License(license)
 Support(support)

 🛠 Installation

 Prerequisites

 Clarinet(https://github.com/hirosystems/clarinet)  Stacks smart contract development toolkit
 Node.js(https://nodejs.org/) (v16 or higher)
 Stacks CLI(https://docs.stacks.co/references/stackscli)

 Setup

1. Clone the repository:
bash
git clone https://github.com/yourusername/vaultlock.git
cd vaultlock


2. Initialize Clarinet project:
bash
clarinet new vaultlock
cd vaultlock


3. Add the contract to your Clarinet.toml:
toml
contracts.vaultlock
path = "contracts/vaultlock.clar"


 💡 Usage

 Creating a Vault

Lock STX tokens for a specified duration:

clarity
 Lock 1000 STX for 52560 blocks (~1 year)
(contractcall? .vaultlock createvault u1000000000 u52560)


 Withdrawing from a Vault

Withdraw funds after the lock period expires:

clarity
 Withdraw from vault ID 1
(contractcall? .vaultlock withdrawvault u1)


 Emergency Withdrawal

Access funds early with a penalty:

clarity
 Emergency withdraw from vault ID 1 (10% penalty applies)
(contractcall? .vaultlock emergencywithdraw u1)


 📚 Contract Functions

 Public Functions

 Function  Description  Parameters 

 createvault  Create a new timelocked savings vault  amount: uint, lockduration: uint 
 withdrawvault  Withdraw funds from an unlocked vault  vaultid: uint 
 emergencywithdraw  Withdraw funds early with penalty  vaultid: uint 

 ReadOnly Functions

 Function  Description  Parameters  Returns 

 getvault  Get vault details  vaultid: uint  Vault data or none 
 getuservaultcount  Get user's total vault count  user: principal  uint 
 gettotallocked  Get total STX locked in protocol    uint 
 getnextvaultid  Get next available vault ID    uint 
 isvaultunlocked  Check if vault is unlocked  vaultid: uint  bool 

 🔧 Examples

 Basic Savings Strategy

clarity
 Create a 6month savings vault
(definepublic (createsixmonthsavings (amount uint))
  (contractcall? .vaultlock createvault amount u26280)  ~6 months in blocks
)

 Create a 1year savings vault  
(definepublic (createannualsavings (amount uint))
  (contractcall? .vaultlock createvault amount u52560)  ~1 year in blocks
)


 Vault Management

clarity
 Check vault status
(definereadonly (checkmyvault (vaultid uint))
  (let ((vaultdata (contractcall? .vaultlock getvault vaultid)))
    (match vaultdata
      vault {
        unlocked: (contractcall? .vaultlock isvaultunlocked vaultid),
        amount: (get amount vault),
        unlockheight: (get unlockheight vault)
      }
      { error: "vaultnotfound" }
    )
  )
)


 🔒 Security Features

 Builtin Protections

 Owner Verification: Only vault owners can withdraw their funds
 Balance Validation: Ensures sufficient balance before vault creation
 Lock Period Enforcement: Prevents early withdrawal without penalty
 Overflow Protection: Uses safe arithmetic operations
 State Consistency: Maintains accurate total locked amounts

 Error Handling

The contract includes comprehensive error codes:

 ERROWNERONLY (100): Unauthorized access attempt
 ERRNOTFOUND (101): Vault does not exist
 ERRINSUFFICIENTBALANCE (102): Insufficient STX balance
 ERRVAULTLOCKED (103): Vault still locked
 ERRINVALIDAMOUNT (104): Invalid amount specified
 ERRINVALIDDURATION (105): Invalid lock duration

 🧪 Testing

Run the test suite:

bash
 Run all tests
clarinet test

 Run specific test file
clarinet test tests/vaultlock_test.ts

 Check contract syntax
clarinet check


 Test Coverage

 Vault creation with various parameters
 Withdrawal scenarios (success and failure cases)
 Emergency withdrawal functionality
 Edge cases and error conditions
 Gas optimization tests

 🚀 Deployment

 Testnet Deployment

bash
 Deploy to Stacks testnet
clarinet deploy testnet

 Verify deployment
stx call_read_only_function <contractaddress vaultlock gettotallocked


 Mainnet Deployment

bash
 Deploy to Stacks mainnet (requires STX for fees)
clarinet deploy mainnet


 🤝 Contributing

We welcome contributions Please follow these steps:

1. Fork the Repository
   bash
   git fork https://github.com/yourusername/vaultlock.git
   

2. Create a Feature Branch
   bash
   git checkout b feature/amazingfeature
   

3. Make Your Changes
    Follow Clarity best practices
    Add comprehensive tests
    Update documentation as needed

4. Test Thoroughly
   bash
   clarinet test
   clarinet check
   

5. Submit a Pull Request
    Provide clear description of changes
    Reference any related issues
    Ensure all tests pass

 Development Guidelines

 Code Style: Follow consistent Clarity formatting
 Documentation: Update README and inline comments
 Testing: Maintain 90% test coverage
 Security: Consider all edge cases and potential vulnerabilities

 📄 License

This project is licensed under the MIT License  see the LICENSE(LICENSE) file for details.


MIT License

Copyright (c) 2025 VaultLock Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.


 🆘 Support

 Getting Help

 Documentation: Check this README and inline code comments
 Issues: Report bugs via GitHub Issues(https://github.com/yourusername/vaultlock/issues)
 Discussions: Join our GitHub Discussions(https://github.com/yourusername/vaultlock/discussions)
 Discord: Join the Stacks community on Discord(https://discord.gg/stacks)

 Frequently Asked Questions

Q: What happens to my stacking rewards?
A: Stacking rewards are earned automatically while your STX is locked. Rewards are distributed according to Stacks protocol rules.

Q: Can I extend my vault's lock period?
A: Currently, lock periods cannot be extended. You'll need to create a new vault after withdrawal.

Q: What's the minimum lock duration?
A: The minimum is 1 block, but we recommend longer periods (weeks to years) for meaningful savings goals.

Q: Is there a maximum vault amount?
A: No explicit maximum, limited only by your STX balance and total supply.

 🌟 Acknowledgments

 Stacks Foundation  For the innovative ProofofTransfer consensus
 Blockstack PBC  For the Clarity smart contract language
 Community Contributors  For testing, feedback, and improvements

 🔗 Related Projects

 Stacks.js(https://github.com/blockstack/stacks.js)  JavaScript library for Stacks
 Clarinet(https://github.com/hirosystems/clarinet)  Clarity development toolkit  
 Stacking Pools(https://stacking.club)  Community stacking resources



Built with ❤️ on Stacks  Secured by Bitcoin