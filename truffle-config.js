module.exports = {

    networks: {
        testnet: {
            host: "https://testnet.tomochain.com",
            network_id: "89",
            gas: 5000000,
            gasPrice: 10000000000000,
        },
        mainnet: {
            host: "https://rpc.tomochain.com",
            network_id: "88",
            gas: 5000000,
            gasPrice: 10000000000000,
        },
    },

    compilers: {
        solc: {
            version: "0.4.26",  // TomoChain highest supported solc version
        }
    }

}
