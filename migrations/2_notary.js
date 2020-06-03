const Migrations = artifacts.require("Notary");

module.exports = function (deployer) {
    deployer.deploy(Migrations);
};
