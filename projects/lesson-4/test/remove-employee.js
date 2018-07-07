let Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 1;

  let payroll;

  beforeEach("Add an employee into the contract for later tests", function () {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test call removeEmployee() by owner", function () {
    // Remove employee
    return payroll.removeEmployee(employee, {from: owner});
  });

  it("Test remove the same employee again", function () {
    // Remove employee
    payroll.removeEmployee(employee, {from: owner});
    // Remove employee again
    return payroll.removeEmployee(employee, {from: owner}).then(function (){
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot remove the same employee again");
    });
  });

  it("Test call removeEmployee() by guest", () => {
    return payroll.removeEmployee(employee, {from: guest}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
    });
  });
});