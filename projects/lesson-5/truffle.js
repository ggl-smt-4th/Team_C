module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "10.154.45.27",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
