var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 1;

  it("Test removeEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      payroll.addEmployee(employee, salary, {from: owner})
      return payroll.removeEmployee(employee, {from: owner});
    });
  });

  
  it("Test removeEmployee() by guest", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      payroll.addEmployee(employee, salary, {from: owner})
      return payroll.removeEmployee(employee, {from: guest});
    }).then(() => {
        assert(false, "Should not be successful");
      }).catch(error => {
        assert.include(error.toString(), "Error: VM Exception", "Can not call removeEmployee() by guest");
      });
  });

  it("Test removeEmployee() nonexist employee", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.removeEmployee(employee, {from: owner});
    }).then(() => {
        assert(false, "Should not be successful");
      }).catch(error => {
        assert.include(error.toString(), "Error: VM Exception", "Can not call removeEmployee() with nonexist employee");
      });
  });
});