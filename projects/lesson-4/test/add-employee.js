var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[5];
  const salary = 1;
  const runway = 20;
  const fund = runway * salary;

  it("Test call addEmployee() by owner", function() {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {
        from: owner
      });
    });
  });

  it("Test call addEmployee() with calculateRunway", function() {
    var payroll;
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

  it("Test call addEmployee() with negative salary", function() {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, -salary, {
        from: owner
      });
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });

  it("Test addEmployee() by guest", function() {
    var payroll;
    return Payroll.new().then(function(instance) {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {
        from: guest
      });
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
    });
  });
});