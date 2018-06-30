var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee_a = accounts[1];
  const employee_b = accounts[2];
  const outsider = accounts[3];
  const salary = 1;
  const payDuration = 30;
  const fund = 100;

  it("The employee calling getPaid() before the next payday", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
        payroll = instance;
        return payroll.addEmployee(employee_a, salary, {from: owner});
    }).then(() => {
        return payroll.getPaid({from: employee_a});
    }).then(() => {
        assert(false, "This employee just got paid incorrectly before the payday.";
    }).catch(error => {
        assert.include(error.toString(), "Error", "The employee should not get paid before the payday")
    })
  });

  it("An outsider calling getPaid()", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
        payroll = instance;
        return payroll.addEmployee(employee_a, salary, {from: owner});
    }).then(() => {
      return payroll.getPaid({from: outsider})
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error", "Should not call getPaid() by a non-employee");
    });
  });
});
