const { assert, expect } = require("chai")
const { getNamedAccounts, deployments, ethers, network } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")

describe("BasicNFT Unit Tests", function () {
    let BasicNFT, deployer
    beforeEach(async function () {
        accounts = await ethers.getSigners()
        deployer = accounts[0]
        await deployments.fixture(["basicnft"])
        BasicNFT = await ethers.getContract("BasicNft")
    })

    describe("Construtor", () => {
        it("Initilizes the NFT Correctly.", async () => {
            const name = await BasicNFT.name()
            const symbol = await BasicNFT.symbol()
            const tokenCounter = await BasicNFT.getTokenCounter()

            assert.equal(name, "Dogie")
            assert.equal(symbol, "DOG")
            assert.equal(tokenCounter.toString(), "0")
        })
    })

    describe("Mint NFT", async function () {
        it("Minting and Increase token counter +1 after a mint", async function () {
            const txResponse = await BasicNFT.mintNft()
            await txResponse.wait(1)
            const tokenURI = await BasicNFT.tokenURI(0)
            const updatedTokenCounter = await BasicNFT.getTokenCounter()

            assert.equal(updatedTokenCounter.toString(), "1")
            assert.equal(tokenURI, await BasicNFT.TOKEN_URI())
        })
    })
})
