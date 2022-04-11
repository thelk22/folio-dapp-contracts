const { expect } = require('chai');

let _name = "Portfolio";
let _ticker = "FOLO";
let _tokenAddresses = ["0xa36085F69e2889c224210F603D836748e7dC0088", "0xd0A1E359811322d97991E03f863a0C30C2cF029C"];
let _percentageHoldings = [40, 60];
let _ownerFee = 100;

// Check variables
const OWNER = "0xF1C37BC188643DF4Bf15Fd437096Eb654d30abc1"
const INITIALISE_AMOUNT = "10000000000" 


describe('Integration test for PortfolioFactory and Portfolio', function () {
    before(async function () {
        // Deploy PortfolioFactory.sol
        PortfolioFactory = await ethers.getContractFactory('PortfolioFactory');
        portfolioFactory = await PortfolioFactory.deploy();

        // Create a portfolio
        await portfolioFactory.create(
            _name,
            _ticker,
            _tokenAddresses,
            _percentageHoldings,
            _ownerFee
        );

        // Access address of newly created portfolio
        portfolioAddress = await portfolioFactory.portfolios(0);  // Get the portfolio address

        // Create contract instance of 'Portfolio.sol' using address and known code.
        Portfolio = await ethers.getContractFactory("Portfolio");
        portfolio = await Portfolio.attach(portfolioAddress);
        
        // Log the addresses to the terminal for debugging
        console.log("Portfolio factory address:", portfolioFactory.address)
        console.log("Portfolio address: ", portfolio.address)
    });

    it('has a total supply of 0 before initialisation', async function () {
        let result = await portfolio.totalSupply.call();
        console.log('total supply: ', result)
        expect(await result.toString()).to.equal("0");
    });

    describe('Initialisation testing', function () {
        before(async function () {
            await portfolio.initialisePortfolio({value:INITIALISE_AMOUNT});
        });


        it('has a total supply of 1000000000000000 after initialisation', async function () {
            let result = await portfolio.totalSupply.call();
            console.log('total supply: ', result)
            expect(await result.toString()).to.equal("100000000000000000000");
        });
    });
});