let Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 1;

  const runway = 20;
  const fund = runway * salary;

  let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {
        from: owner
      });
    });
  });

  it("Test call removeEmployee() by owner", () => {
    // Remove employee
    return payroll.removeEmployee(employee, {
      from: owner
    });
  });

  it("Test call removeEmployee() with calculateRunway", function() {
    return Payroll.new.call(owner, {
      from: owner,
      value: web3.toWei(fund, 'ether')
    }).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {
        from: owner
      });
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
    });
  });

  it("Test call removeEmployee() by guest", () => {
    return payroll.removeEmployee(employee, {
      from: guest
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
    });
  });
});